<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<cfmodule template="../../tags/scopecache.cfm" cachename="pod_recententries" scope="application" timeout="#application.timeout#">

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("recententries")#">
	<cfset params = structNew()>
	<cfset params.maxEntries = 5>
	<cfset params.releasedonly = true>
	<cfset entryData = application.blog.getEntries(duplicate(params))>
	<cfset entries = entryData.entries>
	<cfloop query="entries">
		<cfoutput><li><a href="#application.blog.makeLink(id)#">#title#</a></li></cfoutput>
	</cfloop>
	<cfif not entries.recordCount>
		<cfoutput>#application.resourceBundle.getResource("norecententries")#</cfoutput>
	</cfif>
	
</cfmodule>

</cfmodule>
	
<cfsetting enablecfoutputonly=false>
