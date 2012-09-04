<%@ Register TagPrefix="sc" Namespace="Sitecore.Web.UI.WebControls" Assembly="Sitecore.Kernel" %>
<%@ Register TagPrefix="mt" Namespace="Sitecore.WebControls" Assembly="Sitecore.MetaTags" %>
<%-- <%@ Register TagPrefix="rad" Namespace="Telerik.WebControls" Assembly="RadSpell.NET2" %>--%>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Nicam.aspx.cs" Inherits="Nicam.Layout.Nicam"
    Debug="true" %>

<%@ OutputCache Location="None" VaryByParam="none" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" id="htmlpage" runat="server">
<head id="NicamHead" runat="server">
    <title>
        <%=this.Title%></title>
    <mt:metatags runat="server" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="CODE_LANGUAGE" content="C#" />
    <meta name="vs_defaultClientScript" content="JavaScript" />
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5" />
    <%--Using always in IE7 compatibility mode--%>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <link rel="shortcut icon" href="/images/favicon.ico" type="image/x-icon" />
    <%--Get styles from specific folder--%>
    <sc:xslfile runat="server" renderingid="{736EA695-1316-4AB3-9F4F-DC45D7013FB2}" path="/xsl/Nicam/Styles.xslt"
        id="XslFile5"></sc:xslfile>
    <%-- HACK: <p> on News Spots should wrap <img> in IE, but it doesn't in Page Editor mode --%>
    <!--[if IE]>
    <style>
      .news_spot > .scWebEditInput
      {
        display: block !important;
        width:243px;
      }
    </style>
    <![endif]-->
    <script language="JavaScript" src="/jscript/Nicam/jquery-1.3.2.min.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript" src="/jscript/LinksTracker.js"></script>
    <script language="javascript" type="text/javascript">
        jQuery.noConflict();
    </script>
    <script language="JavaScript" src="/jscript/Nicam/Nicam.js" type="text/javascript"></script>
</head>
<body id="index" runat="server">
    <form id="mainform" runat="server">
    <%-- <rad:RadSpell ID="RadSpell" runat="server" ButtonType="None" RadControlsDir="/sitecore/shell/RadControls" /> --%>
    <asp:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Release" />
    <div id="body_inner_1">
        <div id="body_inner_2">
            <div id="page_container" runat="server">
                <%----------------------------------------
                --               header
                ----------------------------------------%>
                <noindex>
                <div id="page_header">
                    <sc:XslFile runat="server" RenderingID="{8FB8E767-BD42-4ADA-9D6A-BCF96582BAA6}" Path="/xsl/Nicam/Logo.xslt"
                        ID="XslFile3" Cacheable="true" VaryByData="true" />
                    <sc:Sublayout runat="server" RenderingID="{64977EC7-B61C-4CFE-9633-88B23BB0909A}"
                        Path="/Components/Search/PresentationLayer/Search.ascx" ID="Sublayout1" />
                    <sc:XslFile runat="server" RenderingID="{087449E4-FC84-4098-A0A0-C2A833ADFE90}" Path="/Components/Navigation/PresentationLayer/Renderings/Top Menu.xslt"
                        ID="XslFile1" Cacheable="false" VaryByData="true" VaryByUser="true" />
                </div>
                </noindex>
                <%----------------------------------------
                --               Content
                ----------------------------------------%>
                <sc:placeholder runat="server" key="content" id="Placeholder2" />
				<script>
				function get_image() {
				 var createItemInfo = {};
            createItemInfo.imageUrl   = 'http://mytutorblog.org/wp-content/uploads/2011/05/Prepare-for-a-test.jpg';
            createItemInfo.login      = 'admin';
            createItemInfo.password   = 'b';
            createItemInfo.database   = 'web';
            createItemInfo.path       = 'Images';
            createItemInfo.itemName   = 'mediaItem name';

            createItemInfo.fields     = { Alt: 'test test' };

            function onSuccess( resultItems_ )
            {
				alert('ok');
                var item_ = resultItems_[0];
                resultCallback( 'OK?itemId=' + item_.itemId );
            }

            function onError( msg )
            {
                alert('js create media item error: ' + msg);
                resultCallback( 'ERROR_CAN_NOT_CREATE_MEDIA_ITEM' );
            }

            scmobile.contentapi.createMediaItem( createItemInfo, onSuccess, onError );
			}
				</script>
				<input type="button" value="Upload photo" onclick="get_image()" />
                <%----------------------------------------
                --               Footer
                ----------------------------------------%>
                <noindex>
				<div style="background-color:#000000;">
                <div id="page_footer" style="background-color:#000000;">
                    <div class="footer_menu" style="background-color:#000000;">
					    <sc:XslFile runat="server" RenderingID="{3154DA8E-836F-4DF0-875B-00704662B0B3}" Path="/Components/Navigation/PresentationLayer/Renderings/Bottom Menu.xslt"
                            ID="XslFile2" Cacheable="true" VaryByData="true" VaryByUser="true" />
                    </div>
					<script language="javascript" type="text/javascript">
						function accel()
						{
							var accelerometer = new scmobile.motion_manager.Accelerometer();
							accelerometer.onAcceleration = function( accelerData ) {
								// scmobile.console.log( 'got acceleration: x: ' + accelerData.x
								//                           + ' y: ' + accelerData.y
								//                           + ' z: ' + accelerData.z
								//                           + ' timestamp: ' + accelerData.timestamp );
								var div_elem = document.getElementById('div_accelerometer');
								div_elem.width = ((accelerData.z * accelerData.z)+(accelerData.y * accelerData.y)) * 260;
							}
						}

						function onDeviceReady() { 
							//scmobile.console.log( 'got acceleration');
							accel();
						}
						document.addEventListener("scmobileReady", onDeviceReady, false);
					</script>

					<table width="100%" style="background-color:#000000;"><tr><td align="center">
					<div width="800" style="background-color:#000000;">
                    <img align="left" id="div_accelerometer" src="/images/stroke_empty.png?w=300&amp;h=6&amp;as=1" width="300" height="6" style="background-image:url(/images/stroke.jpg); background-repeat:repeat-x;" />
                    </div>
					</td></tr></table><!--<input type="BUTTON" value="Accelerometer" onclick="accel()"/>-->
					</div>
					<!-- -----end of image ------ -->
                    <div class="footer_lang" style="background-color:#000000;">
                        <sc:Sublayout runat="server" RenderingID="{4F11FBA8-A4A0-4BD0-B432-1FDBB0963BD8}"
                            Path="/layouts/Nicam/Sublayout/LanguageSwitcher.ascx" ID="LanguageSwitcher" />
                    </div>
                    <sc:XslFile runat="server" RenderingID="{C47AD51F-6D9E-4F6E-8622-1A6DF9E76A95}" Path="/xsl/Nicam/Footer logo.xslt"
                        Cacheable="true" VaryByData="true" ID="XslFile4" />
                </div>
				</div>
                </noindex>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
