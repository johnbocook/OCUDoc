<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<!--- As with my stats page, this should most likely be abstracted into the CFC. --->
<cfset dsn = application.blog.getProperty("dsn")>
<cfset blog = application.blog.getProperty("name")>
<cfset sevendaysago = dateAdd("d", -7, now())>
<cfset username = application.blog.getProperty("username")>
<cfset password = application.blog.getProperty("password")>

<cfquery name="topByViews" datasource="#dsn#" maxrows="5" username="#username#" password="#password#">
	select	id, title, views, posted
	from	tblblogentries
	where 	tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
	and		posted > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#sevendaysago#">
	order by views desc
</cfquery>

<cfmodule template="../tags/adminlayout.cfm">

	<cfoutput>
		<script>
			$(document).ready(function() {
				$("##latestversioncheck").html("<p>Checking to see if the application is up to date. Please stand by...</p>").load("latestversioncheck.cfm")
			})
		</script>
	</cfoutput>
		
		<cfif structKeyExists(url, "reinit")>
			<cfoutput>
				<div id="alert">
					The cache has been refreshed.
				</div>
			</cfoutput>
		</cfif>

	<cfoutput>
		<h3>About</h3>
		<p>Welcome to #htmlEditFormat(application.blog.getProperty("blogtitle"))# Administrator. This is version #application.blog.getVersion()#.</p>

		<div id="latestversioncheck">
		</div>
		
		<cfif topByViews.recordCount>
			<h3>Top Entries</h3>
			<p>Here are the top entries over the past seven days based on the number of views:</p>
			<p>
				<cfloop query="topByViews">
					<a href="#application.blog.makeLink(id)#">#title#</a> (#views#)<br/>
				</cfloop>
			</p>
		</cfif>
		<div id="admin-footer">
			<small>This project was built on top of the <a href="http://www.blogcfc.com">BlogCFC</a> framework created by <a href="http://www.coldfusionjedi.com">Raymond Camden</a>.</small>
		</div>
	</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>