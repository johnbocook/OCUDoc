<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<cfset pageAlias = listLast(cgi.path_info, "/")>

<cfif not len(pageAlias)>
	<cflocation url="#application.rooturl#/index.cfm" addToken="false">
</cfif>

<cfset page = application.page.getPageByAlias(pageAlias)>

<cfif structIsEmpty(page)>
	<cflocation url="#application.rooturl#/index.cfm" addToken="false">
</cfif>

<cfif page.showlayout>

	<cfmodule template="tags/layout.cfm" title="#page.title#">

		<cfoutput>
		<div class="date"><b>#page.title#</b></div>
		<div class="body">
		#application.blog.renderEntry(page.body)#
		</div>
		</cfoutput>

	</cfmodule>

<cfelse>

	<cfoutput>#application.blog.renderEntry(page.body)#</cfoutput>

</cfif>