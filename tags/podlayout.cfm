<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<cfparam name="attributes.title">

<cfif thisTag.executionMode is "start">

	<cfoutput>

            <div id='cssmenu'>
             <div class="titlewrap"><h4><span>#attributes.title#</span></h4></div>
<ul>
           
				  
	</cfoutput>		

<cfelse>

	<cfoutput>
                  
             
</ul>
            </div>
	</cfoutput>

</cfif>

<cfsetting enablecfoutputonly=false>