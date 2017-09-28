<cfsetting enablecfoutputonly=true>


<cfassociate baseTag="cf_datatable">

<cfparam name="attributes.colname" type="string" default="">
<cfparam name="attributes.name" type="string" default="#attributes.colname#">
<cfparam name="attributes.label" type="string" default="#attributes.name#">
<cfparam name="attributes.data" type="string" default="">
<cfparam name="attributes.sort" type="string" default="true">

<cfif attributes.name is "" and attributes.data is "">
	<cfthrow message="dataCol: Both name and data cannot be empty.">
</cfif>

<cfif len(attributes.data)>
	<cfset attributes.name = attributes.data>
</cfif>

<cfsetting enablecfoutputonly=false>

<cfexit method="EXITTAG">
