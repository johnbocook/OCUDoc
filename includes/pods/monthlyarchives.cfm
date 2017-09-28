<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">



<cfmodule template="../../tags/scopecache.cfm" cachename="pod_monthlyArchives" scope="application" timeout="#application.timeout#">
<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("archivesbymonth")#">

<!--- get the last 5 years by default. If you want all months/years, remove the param --->
<cfset getMonthlyArchives = application.blog.getArchives(archiveYears=5)>

<cfloop query="getMonthlyArchives">
	<cfoutput><a href="#application.rootURL#/index.cfm?mode=month&amp;month=#previousmonths#&amp;year=#previousyears#">#monthAsString(previousmonths)# #previousyears# (#entryCount#)</a><br /></cfoutput>
</cfloop>
	
</cfmodule>
</cfmodule>

<cfsetting enablecfoutputonly=false>