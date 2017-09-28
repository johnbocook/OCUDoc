<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<!--- 
	The following attributes are always passed in. You may not need them for your RTE, 
	but they are here for your use.
--->

<!--- Name of the form field. --->
<cfparam name="attributes.fieldname">
<!--- The value to use --->
<cfparam name="attributes.value" default="">
<!--- CSS class of the text area --->
<cfparam name="attributes.class" default="">
<!--- style class of the text area --->
<cfparam name="attributes.style" default="">

<!--- 
	NOTE: This is where you replace my code with your code. You may want to juse comment out my code
	in case you have to roll back.
--->

<cfoutput>
	<div style="width: 605px; margin-left: 170px;">
<textarea name="#attributes.fieldname#" id="#attributes.fieldname#" <cfif len(attributes.class)>class="#attributes.class# editme"</cfif><cfif len(attributes.style)>style="#attributes.style#"</cfif>>#attributes.value#</textarea></div>

 
</cfoutput>

<cfsetting enablecfoutputonly=false>
<cfexit method="exitTag" />