<cfprocessingdirective pageencoding="utf-8">


<!--- Critical error --->
<cfif not structKeyExists(application, "init")>
	<h2>Critical Error</h2>
	<p>
	A critical error has been thrown. Please visit <a href="http://www.blogcfc.com/index.cfm/main/support">BlogCFC support</a>.
	</p>
	<cfdump var="#error#">
	<cfabort>
</cfif>
	
<!--- Send the error report --->
<cfset blogConfig = application.blog.getProperties()>

<cfsavecontent variable="mail">
<cfoutput>
#rb("errorOccured")#:<br />
<table border="1" width="100%">
	<tr>
		<td>#rb("date")#:</td>
		<td>#dateFormat(now(),"m/d/yy")# #timeFormat(now(),"h:mm tt")#</td>
	</tr>
	<tr>
		<td>#rb("scriptName")#:</td>
		<td>#cgi.script_name#?#cgi.query_string#</td>
	</tr>
	<tr>
		<td>#rb("browser")#:</td>
		<td>#error.browser#</td>
	</tr>
	<tr>
		<td>#rb("referer")#:</td>
		<td>#error.httpreferer#</td>
	</tr>
	<tr>
		<td>#rb("message")#:</td>
		<td>#error.message#</td>
	</tr>
	<tr>
		<td>#rb("type")#:</td>
		<td>#error.type#</td>
	</tr>
	<cfif structKeyExists(error,"rootcause")>
	<tr>
		<td>#rb("rootCause")#:</td>
		<td><cfdump var="#error.rootcause#"></td>
	</tr>
	</cfif>
	<tr>
		<td>#rb("tagContext")#:</td>
		<td><cfdump var="#error.tagcontext#"></td>
	</tr>
</table>
</cfoutput>
</cfsavecontent>

<cfif blogConfig.mailserver is "">
	<cfmail to="#blogConfig.owneremail#" from="#blogConfig.owneremail#" type="html" subject="Error Report">#mail#</cfmail>
<cfelse>
	<cfmail to="#blogConfig.owneremail#" from="#blogConfig.owneremail#" type="html" subject="Error Report"
			server="#blogConfig.mailserver#" username="#blogConfig.mailusername#" password="#blogConfig.mailpassword#">#mail#</cfmail>
</cfif>

<cfmodule template="tags/layout.cfm">

	<cfoutput>
	<div class="date">#rb("errorpageheader")#</div>
	<div class="body">
	<p>
	#rb("errorpagebody")#
	</p>
	<cfif isUserInRole("admin")>
		<cfoutput>#mail#</cfoutput>
	</cfif>
	</div>
	</cfoutput>
	
</cfmodule>