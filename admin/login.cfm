<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">



<cfmodule template="../tags/adminlayout.cfm" title="Logon">

<cfset qs = cgi.query_string>
<cfset qs = reReplace(qs, "logout=[^&]+", "")>

<cfoutput>
<div id="login">
	<div id="login-logo">
		<a href="#application.rooturl#"><h1>OCU Docs</h1></a>
		<p>Ohio Christian University</p>
		</div>
<form name="loginform" action="#cgi.script_name#?#qs#" method="post" enctype="multipart/form-data">
<!--- copy additional fields --->
<cfloop item="field" collection="#form#">
	<!--- the isSimpleValue is probably a bit much.... --->
	<cfif field is "enclosure" and len(trim(form.enclosure))>
		<input type="hidden" name="enclosureerror" value="true">
	<cfelseif not listFindNoCase("username,password", field) and isSimpleValue(form[field])>
		<input type="hidden" name="#field#" value="#htmleditformat(form[field])#">
	</cfif>
</cfloop>
		<table id="logintable">
			<tr>
				<td>#application.resourceBundle.getResource("username")#</td><td><input name="username" type="text" id="username" size="30"></td>
			</tr>
			<tr>
				<td>#application.resourceBundle.getResource("password")#</td><td><input name="password" type="password" id="password" size="30"></td>
			</tr>
			<tr>
				<td></td><td><input type="submit" value="#application.resourceBundle.getResource("login")#"></td>
			</tr>
			<!---<tr>
				<td></td><td><a href="">Forgot username or password?</a></td>
			</tr>--->
		</table>
	</form>
</div>

<script language="javaScript" TYPE="text/javascript">
<!--
document.forms[0].username.focus();
//-->
</script>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>