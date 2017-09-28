

<cfif not isDefined("url.id")>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cftry>
	<cfset entry = application.blog.getEntry(url.id,true)>
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfheader name="Content-Disposition" value="inline; filename=#entry.alias#.pdf">
<cfdocument format="pdf">

	<cfoutput>
	<html>

	<style type="text/css">
	@import url(#application.rooturl#/includes/style.css);
	</style>
	
	<body style="background:##FFFFFF">
	<div id="page">
	<div id="content">
	<div id="blogText">
	</cfoutput>
	
	<cfdocumentitem type="header">
	<cfoutput>
	<div style="font-size: 8px; text-align: right;">
	#application.blog.getProperty("blogTitle")#: #entry.title#
	</div>	
	</cfoutput>
	</cfdocumentitem>

	<cfsavecontent variable="display">	
	<cfoutput>
	<h1>#entry.title#</h1>

	<div class="byline">#rb("postedat")# : #application.localeUtils.dateLocaleFormat(entry.posted)# #application.localeUtils.timeLocaleFormat(entry.posted)# 
		<cfif len(entry.name)>| #rb("postedby")# : #entry.name#</cfif><br />
		#rb("relatedcategories")#:
		<cfloop item="cat" collection="#entry.categories#">
		#entry.categories[cat]#<cfif cat is not listLast(structKeyList(entry.categories))>,</cfif>
		</cfloop>
	</div>

	<div class="body">
	#application.blog.renderEntry(entry.body,true,entry.enclosure)#
	#application.blog.renderEntry(entry.morebody,true)#
	</div>
	</cfoutput>
	</cfsavecontent>
	
	<!--- 
	Older blog entries use class=code, so let's do a quick fix for them
	--->
	<cfset display = replace(display, "class=""code""", "class=""codePrint""", "all")>
	<cfoutput>#display#</cfoutput>

	<cfoutput>
	</div>
	</div>
	</div>
	
	</body>
	</html>
	</cfoutput>
	
</cfdocument>