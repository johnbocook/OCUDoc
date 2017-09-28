<cfsetting enablecfoutputonly=true>
    <cfprocessingdirective pageencoding="utf-8">
        
        <cfparam name="attributes.title" default="">
            <cfif thisTag.executionMode is "start">
                <cfoutput>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
                        <link rel="stylesheet" type="text/css" href="#application.rooturl#/includes/admin.css" media="screen" />
                        <script type="text/javascript" src="#application.rooturl#/includes/jquery.min.js"></script>
                        <script type="text/javascript" src="#application.rooturl#/includes/jquery.selectboxes.js"></script>
                        <script type="text/javascript" src="#application.rooturl#/includes/jquery.autogrow.js"></script>
                        <link type="text/css" href="#application.rooturl#/includes/jqueryui/css/custom-theme/jquery-ui-1.7.2.custom.css" rel="stylesheet" />
                        <link href='https://fonts.googleapis.com/css?family=Passion+One:400,700|Bad+Script' rel='stylesheet' type='text/css'>
                        <style type="text/css" media="screen">
                        @import "#application.rooturl#/includes/uni-form/css/uni-form.css";
                        </style>
                        <script type="text/javascript" src="#application.rooturl#/includes/uni-form/js/uni-form.jquery.js"></script>
                        <script type="text/javascript" src="#application.rooturl#/includes/jqueryui/jqueryui.js"></script>
                        <cfif NOT caller.isLoggedIn()>
                            <style type="text/css">
                            body {
                                background: none;
                            }
                            </style>
                        </cfif>
                        <title>#htmlEditFormat(application.blog.getProperty("blogTitle"))# Administrator: #attributes.title#</title>
                    </head>

                    <body>
                        <!--- TODO: Switch to request scope --->
                        <cfif caller.isLoggedIn()>
                            <div id="menu">
                                <div id="admin-logo">
                                    <h2>Administrator</h2>
                                </div>
                                <ul>
                                    <li><a href="../index.cfm?reinit=1">OCU Docs <small>Doc Portal</small></a></li>
                                    <li><a href="entry.cfm?id=0">Add Entry</a></li>
                                    <li><a href="entries.cfm">List Entries</a></li>
                                    <cfif application.blog.isBlogAuthorized( 'ManageCategories')>
                                        <li><a href="categories.cfm">Categories<small>List and Modify</small></a></li>
                                    </cfif>
                                    <!---<li><a href="comments.cfm">Comments</a></li>
									<cfif application.commentmoderation>
									<li><a href="moderate.cfm">Moderate Comments (<cfoutput>#application.blog.getNumberUnmoderated()#</cfoutput>)</a></li>
									</cfif>--->
                                    <li><a href="index.cfm?reinit=1">Refresh Cache</a></li>
                                    <li><a href="stats.cfm">Stats</a></li>
                                    <cfif application.blog.isBlogAuthorized( 'PageAdmin')>
                                        <cfif application.settings>
                                            <li><a href="settings.cfm">Settings</a></li>
                                        </cfif>
                                    </cfif>
                                    <!---<li><a href="subscribers.cfm">Subscribers</a></li>
										<li><a href="mailsubscribers.cfm">Mail Subscribers</a></li> --->
                                    <cfif application.blog.isBlogAuthorized( 'ManageUsers')>
                                        <li><a href="users.cfm">Users</a></li>
                                    </cfif>
                                    <cfif application.blog.isBlogAuthorized( 'PageAdmin')>
                                        <li><a href="pods.cfm">Pod Manager</a></li>
                                        <cfif application.filebrowse>
                                            <li><a href="filemanager.cfm">File Manager</a></li>
                                        </cfif>
                                        <li><a href="pages.cfm">Pages</a></li>
                                        <li><a href="slideshows.cfm">Slideshows</a></li>
                                        <li><a href="textblocks.cfm">Textblocks</a></li>
                                    </cfif>
                                    <!--- <li><a href="stats.cfm">Entry Stats</a></li> --->
                                    <ul style="border-bottom: none;">
                                        <li><a href="updatepassword.cfm">Update Password</a>
                                            <li>
                                                <li><a href="index.cfm?logout=youbetterbelieveit">Logout</a></li>
                                    </ul>
                            </div>
                            <div id="content">
                                <div id="header">#attributes.title#</div>
                                <cfelse>
                                    <div id="content">
                        </cfif>
                </cfoutput>
                <cfelse>
                    <cfoutput>
                        </div>
                        </body>

                        </html>
                    </cfoutput>
            </cfif>
            <cfsetting enablecfoutputonly=false>
