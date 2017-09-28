<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<cfmodule template="../../tags/scopecache.cfm" cachename="pod_archives" scope="application" timeout="#application.timeout#">

<cfmodule template="../../tags/podlayout.cfm" title="Categories">

	<cfset cats = application.blog.getCategories()>
	<cfloop query="cats">
		<cfoutput><li><a href="#application.blog.makeCategoryLink(categoryid)#" title="#categoryName# RSS">#categoryName# (#entryCount#)</a></li></cfoutput>
	</cfloop>
	
</cfmodule>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>