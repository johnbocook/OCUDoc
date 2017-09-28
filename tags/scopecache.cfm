

<!--- allow for quick exit --->
<cfif isDefined("attributes.disabled") and attributes.disabled>
	<cfexit method="exitTemplate">
</cfif>

<!--- Allow for cachename in case we use cfmodule --->
<cfif isDefined("attributes.cachename")>
	<cfset attributes.name = attributes.cachename>
</cfif>

<!--- Must pass scope, and must be a valid value. --->
<cfif not isDefined("attributes.scope") or not isSimpleValue(attributes.scope) or not listFindNoCase("application,session,server,request,file",attributes.scope)>
	<cfthrow message="scopeCache: The scope attribute must be passed as one of: application, session, server, request, or file.">
</cfif>

<cfparam name="attributes.file" default="">

<!--- create pointer to scope --->
<cfif attributes.scope is not "file">
	<cfset ptr = structGet(attributes.scope)>
	
	<!--- init cache root --->
	<cflock scope="#attributes.scope#" type="readOnly" timeout="30">
		<cfif not structKeyExists(ptr,"scopeCache")>
			<cfset needInit = true>
		<cfelse>
			<cfset needInit = false>
		</cfif>
	</cflock>
	
	<cfif needInit>
		<cflock scope="#attributes.scope#" type="exclusive" timeout="30">
			<!--- check twice in cace another thread finished --->
			<cfif not structKeyExists(ptr,"scopeCache")>
				<cfset ptr["scopeCache"] = structNew()>
			</cfif>
		</cflock>
	</cfif>
	
</cfif>

<!--- Do they simply want the keys? --->
<cfif isDefined("attributes.r_cacheItems") and attributes.scope neq "file">
	<cfset caller[attributes.r_cacheItems] = structKeyList(ptr.scopeCache)>
	<cfexit method="exitTag">
</cfif>

<!--- Do they want to nuke it all? --->
<cfif isDefined("attributes.clearAll") and attributes.scope neq "file">
	<cfset structClear(ptr["scopeCache"])>
	<cfexit method="exitTag">
</cfif>

<!--- Require name if we get this far. --->
<cfif not isDefined("attributes.name") or not isSimpleValue(attributes.name)>
	<cfthrow message="scopeCache: The name attribute must be passed as a string.">
</cfif>

<!--- The default timeout is no timeout, so we use the year 3999. We will have flying cars then. --->
<cfparam name="attributes.timeout" default="#createDate(3999,1,1)#">
<!--- Default dependancy list --->
<cfparam name="attributes.dependancies" default="" type="string">

<cfif not isDate(attributes.timeout) and (not isNumeric(attributes.timeout) or attributes.timeout lte 0)>
	<cfthrow message="scopeCache: The timeout attribute must be either a date/time or a number greater than zero.">
<cfelseif isNumeric(attributes.timeout)>
	<!--- convert seconds to a time --->
	<cfset attributes.timeout = dateAdd("s",attributes.timeout,now())>
</cfif>


<!--- This variable will store all the guys we need to update --->
<cfset cleanup = "">
<!--- This variable determines if we run the caching. This is used when we clear a cache --->
<cfset dontRun = false>

<cfif isDefined("attributes.clear") and attributes.clear and thisTag.executionMode is "start">
	<cfif attributes.scope neq "file" and structKeyExists(ptr.scopeCache,attributes.name)>
		<cfset cleanup = ptr.scopeCache[attributes.name].dependancies>
		<cfset structDelete(ptr.scopeCache,attributes.name)>
	<cfelseif fileExists(attributes.file)>
		<cffile action="delete" file="#attributes.file#">
	</cfif>
	<cfset dontRun = true>
</cfif>

<cfif not dontRun>
	<cfif thisTag.executionMode is "start">
		<!--- determine if we have the info in cache already --->
		<cfif attributes.scope neq "file" and structKeyExists(ptr.scopeCache,attributes.name)>
			<cfif dateCompare(now(),ptr.scopeCache[attributes.name].timeout) is -1>
				<cflock scope="#attributes.scope#" type="exclusive" timeout="30">
					<cfset ptr.scopeCache[attributes.name].hitCount = ptr.scopeCache[attributes.name].hitCount + 1>
				</cflock>			
				<cfif not isDefined("attributes.r_Data")>
					<cfoutput>#ptr.scopeCache[attributes.name].value#</cfoutput>
				<cfelse>
					<cfset caller[attributes.r_Data] = ptr.scopeCache[attributes.name].value>
				</cfif>
				<cfexit method="exitTag">
			</cfif>
		<!--- Fix by Ken Gladden --->	
		<cfelseif (attributes.file is not "") and fileExists(attributes.file)>
			<!--- read the file in to check metadata --->
			<cflock name="#attributes.file#" type="readonly" timeout="30">			
				<cffile action="read" file="#attributes.file#" variable="contents" charset="UTF-8">
				<cfwddx action="wddx2cfml" input="#contents#" output="data">
			</cflock>
			<cfif dateCompare(now(),data.timeout) is -1>
				<cfif not isDefined("attributes.r_Data")>
					<cfoutput>#data.value#</cfoutput>
				<cfelse>
					<cfset caller[attributes.r_Data] = data.value>
				</cfif>
				<cfif not structKeyExists(attributes, "suppressHitCount")>
					<cflock name="#attributes.file#" type="exclusive" timeout="30">
						<cfset data.hitCount = data.hitCount + 1>
						<cfwddx action="cfml2wddx" input="#data#" output="packet">
						<cffile action="write" file="#attributes.file#" output="#packet#" charset="UTF-8">		
					</cflock>
				</cfif>
				<cfexit method="exitTag">						
			</cfif>
		</cfif>
	<cfelse>
		<!--- It is possible I'm here because I'm refreshing. If so, check my dependancies --->
		<cfif attributes.scope neq "file" and structKeyExists(ptr.scopeCache,attributes.name)>
			<cfif structKeyExists(ptr.scopeCache[attributes.name],"dependancies")>
				<cfset cleanup = listAppend(cleanup, ptr.scopeCache[attributes.name].dependancies)>
			</cfif>
		</cfif>
		<cfif attributes.scope neq "file">
			<cfset ptr.scopeCache[attributes.name] = structNew()>
			<cfif not isDefined("attributes.data")>
				<cfset ptr.scopeCache[attributes.name].value = thistag.generatedcontent>
			<cfelse>
				<cfset ptr.scopeCache[attributes.name].value = attributes.data>
			</cfif>
			<cfset ptr.scopeCache[attributes.name].timeout = attributes.timeout>
			<cfset ptr.scopeCache[attributes.name].dependancies = attributes.dependancies>
			<cfset ptr.scopeCache[attributes.name].hitCount = 0>
			<cfset ptr.scopeCache[attributes.name].created = now()>
			<cfif isDefined("attributes.r_Data")>
				<cfset caller[attributes.r_Data] = ptr.scopeCache[attributes.name].value>
			</cfif>
		<cfelse>
			<cfset data = structNew()>
			<cfif not isDefined("attributes.data")>
				<cfset data.value = thistag.generatedcontent>
			<cfelse>
				<cfset data.value = attributes.data>
			</cfif>
			<cfset data.timeout = attributes.timeout>
			<cfset data.dependancies = attributes.dependancies>
			<cfset data.hitCount = 0>
			<cfset data.created = now()>
			<cflock name="#attributes.file#" type="exclusive" timeout="30">
				<cfwddx action="cfml2wddx" input="#data#" output="packet">
				<cffile action="write" file="#attributes.file#" output="#packet#" charset="UTF-8">
			</cflock>
			<cfif isDefined("attributes.r_Data")>
				<cfset caller[attributes.r_Data] = data.value>
			</cfif>
		</cfif>
	</cfif>
</cfif>

<!--- Do I need to clean up? --->
<cfloop condition="listLen(cleanup)">
	<cfset toKill = listFirst(cleanup)>
	<cfset cleanUp = listRest(cleanup)>
	<cfif structKeyExists(ptr.scopeCache, toKill)>
		<cfloop index="item" list="#ptr.scopeCache[toKill].dependancies#">
			<cfif not listFindNoCase(cleanup, item)>
				<cfset cleanup = listAppend(cleanup, item)>
			</cfif>
		</cfloop>
		<cfset structDelete(ptr.scopeCache,toKill)>
	</cfif>
</cfloop>

<cfif dontRun>
	<cfexit method="exitTag">
</cfif>
