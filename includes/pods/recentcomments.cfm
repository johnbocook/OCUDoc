<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<cfmodule template="../../tags/scopecache.cfm" cachename="#application.applicationname#_rc" scope="application" timeout="#application.timeout#">

<cfset numComments = 5>
<cfset lenComment = 100>

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("recentcomments")#">
	<cfset getComments = application.blog.getRecentComments(numComments)>
	<cfloop query="getComments">
		<cfset formattedComment = comment>
		<cfif len(formattedComment) gt len(lenComment)>
			<cfset formattedComment = left(formattedComment, lenComment)>
		</cfif>
		<cfset formattedComment = caller.replaceLinks(formattedComment,25)>
		<cfoutput><p><a href="#application.blog.makeLink(getComments.entryID)#">#getComments.title#</a><br />
		#getComments.name# #application.resourceBundle.getResource("said")#: #formattedComment#<cfif len(comment) gt lenComment>...</cfif>
		<a href="#application.blog.makeLink(getComments.entryID)###c#getComments.id#">[#application.resourceBundle.getResource("more")#]</a></p></cfoutput>
	</cfloop>
	<cfif not getComments.recordCount>
		<cfoutput>#application.resourceBundle.getResource("norecentcomments")#</cfoutput>
	</cfif>


</cfmodule>

</cfmodule>

<cfsetting enablecfoutputonly=false>
