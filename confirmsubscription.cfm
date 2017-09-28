<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<cfif not isDefined("url.t")>
	<cflocation url="/" addToken="false">
<cfelse>
	<cftry>
		<cfset entry = application.blog.confirmSubscription(url.t)>
		<cfcatch>
			<!--- Do nothing, since most likely it is a spammer. --->
			<cfdump var="#cfcatch#">
		</cfcatch>
	</cftry>
</cfif>


<cfmodule template="tags/layout.cfm" title="#rb("subscribeconfirm")#">
	
	<cfoutput>
	<div class="date"><b>#rb("subscribeconfirm")#</b></div>
	
	<div class="body">
	#rb("subscribeconfirmbody")#
	</div>
	</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>