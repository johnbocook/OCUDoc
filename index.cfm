<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">


<!--- Handle URL variables to figure out how we will get betting stuff. --->

<cfmodule template="tags/getmode.cfm" r_params="params"/>
	
	<!--- Set homepage check --->
	<cfset homepage = 0>
	<cfif #CGI.path_info# EQ "">
		<cfset homepage = 1>
	</cfif>

	<!--- only cache on home page --->
	<cfset disabled = true>
	<cfif url.mode is not "" or len(cgi.query_string) or not structIsEmpty(form)>
		<cfset disabled = true>
	</cfif> 

	<cfmodule template="tags/scopecache.cfm" cachename="#application.applicationname#" scope="application" disabled="#disabled#" timeout="#application.timeout#">

	
		<!--- Try to get the articles. --->
		<cftry>
			<cfset articleData = application.blog.getEntries(params)>
			<cfset articles = articleData.entries>
			<!--- if using alias, switch mode to entry --->
			<cfif url.mode is "alias">
				<cfset url.mode = "entry">
				<cfset url.entry = articles.id>
			</cfif>
			<cfcatch>
				<cfset articleData = structNew()>
				<cfset articleData.totalEntries = 0>
				<cfset articles = queryNew("id")>
			</cfcatch>
		</cftry>

		<!--- Call layout custom tag. --->
		<cfset data = structNew()>
		<!--- 
		I already know what I'm doing - I got it from getMode, so let me bypass the work done normally for by Entry, it is the most
		popular view
		--->
		<cfif url.mode is "entry" and articleData.totalEntries is 1>
			<cfset data.title = articles.title[1]>
			<cfset data.entrymode = true>
			<cfset data.entryid = articles.id[1]>
			<cfif not structKeyExists(session.viewedpages, url.entry)>
				<cfset session.viewedpages[url.entry] = 1>
				<cfset application.blog.logView(url.entry)>
			</cfif>
		</cfif>

		<cfmodule template="tags/layout.cfm" attributecollection="#data#">

			<!--- load up swfobject --->
			<cfoutput>
				<script src="#application.rooturl#/includes/swfobject_modified.js" type="text/javascript"></script>
			</cfoutput>
			<cfset lastDate = "">
			<!--- Logged in check --->
			<cfif structKeyExists(SESSION,"loggedin")>
			<cfloop query="articles">
			
				<cfoutput>

		            <div class=<cfoutput>"post <cfif homepage EQ 1>homepage <cfelse>single-page</cfif>"</cfoutput>>
		            	<div class="post-header">
		            		<p class="post-date">
					   			<span class="month">#dateFormat(posted, "mmm")#</span>
		               			<span class="day">#day(posted)#</span>
		           			</p>
		          			<h3 class="post-title"><a href="#application.blog.makeLink(id)#">#title#</a><cfif homepage EQ 0><cfif len(enclosure)><a class="float-right blue-btn download" href="#application.rooturl#/enclosures/#urlEncodedFormat(getFileFromPath(enclosure))#">Download attachment.</a></cfif></a></cfif></h3>
		              		<p class="post-author">
		               			<span class="info">Posted on #dateFormat(posted, "mmmm d, yyyy")# at #timeFormat(posted, "h:mm tt")# <cfif len(name)>by <a href="#application.blog.makeUserLink(name)#">#name#</a></cfif> in 
				
									<cfset lastid = listLast(structKeyList(categories))>
									<cfloop item="catid" collection="#categories#">
										<a href="#application.blog.makeCategoryLink(catid)#">#categories[currentRow][catid]#</a>
										<cfif catid is not lastid>, </cfif>
									</cfloop>
									<span class="right">Total Views: #views#</span>
								</span>
		              		</p>
		             	</div> <!--- /.post-header --->

		             	<!--- Don't show post content or comments if homepage --->
	            		<cfif homepage EQ 0>

			             	<div class="post-content clearfix">
								#application.blog.renderEntry(body,false,enclosure)#

								<!--- STICK IN THE MP3 PLAYER --->
								<cfif enclosure contains "mp3">
									<cfset alternative=replace(getFileFromPath(enclosure),".mp3","") />
									<div class="audioPlayerParent">
										<div id="#alternative#" class="audioPlayer">
										</div>
									</div>
									<script type="text/javascript">
										// <![CDATA[
										var flashvars = {};
										// unique ID
										flashvars.playerID = "#alternative#";
										// load the file
										flashvars.soundFile= "#application.rooturl#/enclosures/#getFileFromPath(enclosure)#";
										// Load width and Height again to fix IE bug
										flashvars.width = "470";
										flashvars.height = "24";
										// Add custom variables
										var params = {};
										params.allowScriptAccess = "sameDomain";
										params.quality = "high";
										params.allowfullscreen = "true";
										params.wmode = "transparent";
										var attributes = false;
										swfobject.embedSWF("#application.rooturl#/includes/audio-player/player.swf", "#alternative#", "470", "24", "8.0.0","/includes/audio-player/expressinstall.swf", flashvars, params, attributes);
									// ]]>
									</script>
								</cfif>
								<cfif len(morebody) and url.mode is not "entry">
									<p align="right">
										<a href="#application.blog.makeLink(id)###more">[#rb("more")#]</a>
									</p>
								<cfelseif len(morebody)>
									#application.blog.renderEntry(morebody)#
								</cfif>

								<div class="clear"></div>


			            	</div><!--- /.post-content --->
			            </cfif>
		            </div> <!--- /.post --->

				</cfoutput>

				<!--- Things to do if showing one entry --->						
				<cfif articles.recordCount is 1>
					<cfset qRelatedBlogEntries = application.blog.getRelatedBlogEntries(entryId=id,bDislayFutureLinks=true) />	
					<cfif qRelatedBlogEntries.recordCount>
						<cfoutput>
							<div id="relatedentries">
								<p>
									<div class="relatedentriesHeader">Related Articles</div>
									<hr class="fade">
								</p>
				  				<ul id="relatedEntriesList">
									<cfloop query="qRelatedBlogEntries">
										<li><a href="#application.blog.makeLink(entryId=qRelatedBlogEntries.id)#">#qRelatedBlogEntries.title#</a> <small>#application.localeUtils.dateLocaleFormat(posted)#</small></li>
									</cfloop>			
						  		</ul>
					  		</div><!--- / relatedentries --->
				  		</cfoutput>
					</cfif>
	<!--- Hide comments
					<cfoutput>
						<h3 class="commentHeader">#rb("comments")# <cfif application.commentmoderation>(#rb("moderation")#)</cfif></h3>
					</cfoutput>
					<cfset comments = application.blog.getComments(id)>

					<cfif allowComments>
						<cfoutput>
							<div style="font-size:12px">
								[<a href="javaScript:launchComment('#id#')">#rb("addcomment")#</a>]
								[<a href="javaScript:launchCommentSub('#id#')">#rb("addsub")#</a>]
							</div>
						</cfoutput>
					</cfif>

					<cfoutput>
						<ul id="comments">
							<cfset entryid = id>
							<cfloop query="comments">
								<cfif currentRow mod 2 is 0>
									<cfset evenodd = "even">
								<cfelse>
									<cfset evenodd = "false">
								</cfif>
								<li class="comment #evenodd# thread-#evenodd# depth-1 with-avatar" id="c#id#">
						   			<div class="comment-mask regularcomment">
						    			<div class="comment-main">
									    	<div class="comment-wrap1">
									    		<div class="comment-wrap2">
									    			<div class="comment-head tiptrigger">
														<p>
															<a class="comment-id" href="#application.blog.makeLink(entryid)###c#id#">###currentRow#</a> by <b><cfif len(comments.website)><a href="#comments.website#" rel="nofollow">#name#</a><cfelse>#name#</cfif></b> 
								on #application.localeUtils.dateLocaleFormat(posted,"short")# - #application.localeUtils.timeLocaleFormat(posted)#
														</p>
							   						</div>
							   						<div class="comment-body clearfix" id="comment-body-#currentRow#">
														<div class="avatar">
															<img src="http://www.gravatar.com/avatar/#lcase(hash(lcase(email)))#?s=64&amp;r=pg&amp;d=#application.rooturl#/images/gravatar.gif" title="#name#'s Gravatar" border="0" class="avatar avatar-64 photo" height="64" width="64" />
														</div>
														<div class="comment-text">
															#paragraphFormat2(replaceLinks(comment))#
														</div>
						       						</div><!--- /.comment-body --->
						      					</div><!--- /.comment-wrap2 --->
						    				</div><!--- /.comment-wrap1 --->
						    			</div><!--- /.comment-main --->
						   			</div><!--- /.comment-mask --->
								</li> 

							</cfloop>
						</ul><!--- / comments --->


						<cfif allowComments and comments.recordCount gte 5>
							<div style="font-size:12px">
								[<a href="javaScript:launchComment('#id#')">#rb("addcomment")#</a>]
								[<a href="javaScript:launchCommentSub('#id#')">#rb("addsub")#</a>]
							</div>
						<cfelseif not allowcomments>
							<cfoutput>
								<div>#rb("commentsnotallowed")#
								</div>
							</cfoutput>
						</cfif>

					
					
				    <div class="clear"></div>
				    </cfoutput>
				    --->
					
				</cfif> <!--- End if showing one entry --->
			</cfloop>

			<!--- If no articles are found --->
			<cfif articles.recordCount is 0>
				<cfoutput>
					<h3>#rb("sorry")#</h3>
					<p>
						<cfif url.mode is "">
							#rb("noentries")#
						<cfelse>
							#rb("noentriesforcriteria")#
						</cfif>
					</p>
				</cfoutput>
			</cfif>
			
			<!--- Used for pagination. --->
			<cfif (url.startRow gt 1) or (articleData.totalEntries gte url.startRow + application.maxEntries)>
			
				<!--- get path if not /index.cfm --->
				<cfset path = rereplace(cgi.path_info, "(.*?)/index.cfm", "")>
				
				<!--- clean out startrow from query string --->
				<cfset qs = cgi.query_string>
				<cfset qs = reReplace(qs, "<.*?>", "", "all")>
				<cfset qs = reReplace(qs, "[\<\>]", "", "all")>
				<cfset qs = reReplaceNoCase(qs, "&*startrow=[\-0-9]+", "")>
				<cfif isDefined("form.search") and len(trim(form.search)) and not structKeyExists(url, "search")>
					<cfset qs = qs & "&amp;search=#htmlEditFormat(form.search)#">
				</cfif>

				<cfoutput>
					<p align="right">
						<cfif url.startRow gt 1>
							<cfset prevqs = qs & "&amp;startRow=" & (url.startRow - application.maxEntries)>
								<a href="#application.rooturl#/index.cfm#path#?#prevqs#">#rb("preventries")#</a>
						</cfif>
						
						<cfif (url.startRow gt 1) and (articleData.totalEntries gte url.startRow + application.maxEntries)>
							/
						</cfif>
						
						<cfif articleData.totalEntries gte url.startRow + application.maxEntries>
							<cfset nextqs = qs & "&amp;startRow=" & (url.startRow + application.maxEntries)>
								<a href="#application.rooturl#/index.cfm#path#?#nextqs#">#rb("moreentries")#</a>
						</cfif>
					</p>
				</cfoutput>
			</cfif> <!--- end used for pagination --->
			<cfelse>
				<cfoutput>
				<style>
				##sidebar, ##nav-wrap1, .search-block {
					display:none !important;
				}
				
				</style>
				You must be <a href="#application.rooturl#/admin">logged in</a> to view this site.
			</cfoutput>
	</cfif>	<!--- end logged in check --->
	</cfmodule>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>	
