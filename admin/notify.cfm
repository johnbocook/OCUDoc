<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<cfif not structKeyExists(url, "id")>
	<cfabort>
</cfif>

<cftry>
	<cfset entry = application.blog.getEntry(url.id,true)>
	<cfcatch>
		<cfoutput>Error getting entry.</cfoutput>
		<cfabort>
	</cfcatch>
</cftry>

<!--- is it released? --->
<cfif not entry.released>
	<cfoutput>Not released.</cfoutput>
	<cfabort>
</cfif>

<!--- was it already mailed? --->
<cfif entry.mailed>
	<cfoutput>Already mailed.</cfoutput>
	<cfabort>
</cfif>

<!--- is posted < now()? --->
<cfif dateCompare(entry.posted, application.blog.blognow()) is 1>
	<cfoutput>This entry is in the future.</cfoutput>
	<cfabort>
</cfif>

<cfoutput>Yes, I will be emailing this.</cfoutput>
<cfset application.blog.mailEntry(url.id)>

<cfoutput>Clear the cache</cfoutput>
<cfmodule template="../tags/scopecache.cfm" scope="application" clearAll="true" />

<cfoutput>Now delete the scheduled task.</cfoutput>
<cfschedule action="delete" task="BlogCFC Notifier #url.id#">

<cfsetting enablecfoutputonly=false>
