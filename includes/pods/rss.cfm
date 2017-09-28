<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<cfset rssURL = application.rootURL & "/rss.cfm">

<cfmodule template="../../tags/podlayout.cfm" title="RSS">

	<cfoutput>
	<p class="center">
	<a href="#rssURL#?mode=full" rel="noindex,nofollow"><img src="#application.rootURL#/images/rssbutton.gif" border="0" /></a><br />
	</p>
	</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>