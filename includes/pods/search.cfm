<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("search")#">

	<cfoutput>
    <div class="center">
	<form action="#application.rooturl#/search.cfm" method="post" onsubmit="return(this.search.value.length != 0)">
	<p class="center"><input type="text" name="search" size="15" /> <input type="submit" value="#application.resourceBundle.getResource("search")#" /></p>
	</form>
  </div>
	</cfoutput>
		
</cfmodule>
	
<cfsetting enablecfoutputonly=false>