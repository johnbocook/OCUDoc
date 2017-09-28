<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<cfif not isDefined("url.email")>
	<cflocation url = "#application.blog.getProperty("blogURL")#">
</cfif>


<cfmodule template="tags/layout.cfm" title="#rb("unsubscribe")#">

<cfoutput>
<div class="date">#rb("unsubscribe")#</div>
</cfoutput>

<cfif isDefined("url.commentID")>

	<!--- Attempt to unsub --->
	<cftry>
		<cfset result = application.blog.unsubscribeThread(url.commentID, url.email)>
		<cfcatch>
			<cfset result = false>
		</cfcatch>
	</cftry>
	
	<cfif result>
		<cfoutput>
		<p>#rb("unsubscribesuccess")#</p>
		</cfoutput>
	<cfelse>
		<cfoutput>
		<p>#rb("unsubscribefailure")#</p>
		</cfoutput>
	</cfif>

<cfelseif isDefined("url.token")>

	<!--- Attempt to unsub --->
	<cftry>
		<cfset result = application.blog.removeSubscriber(url.email, url.token)>
		<cfcatch>
			<cfset result = false>
		</cfcatch>
	</cftry>
	
	<cfif result>
		<cfoutput>
		<p>#rb("unsubscribeblogsuccess")#</p>
		</cfoutput>
	<cfelse>
		<cfoutput>
		<p>#rb("unsubscribeblogfailure")#</p>
		</cfoutput>
	</cfif>

</cfif>

<cfoutput><p><a href="#application.blog.getProperty("blogurl")#">#rb("returntoblog")#</a></p></cfoutput>

</cfmodule>
<cfsetting enablecfoutputonly=false>	