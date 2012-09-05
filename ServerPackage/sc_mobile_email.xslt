<?xml version="1.0" encoding="UTF-8"?>

<!--=============================================================
    File: ProductInfo.xslt                                                   
    Created by: sitecore\admin                                       
    Created: 12.05.2008 12:22:42                                               
==============================================================-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sc="http://www.sitecore.net/sc"
  xmlns:dot="http://www.sitecore.net/dot"
  xmlns:scmobile="http://www.sitecore.net/scmobile"
  xmlns:wu="http://www.sitecore.net/webutil" 
  exclude-result-prefixes="sc dot wu" >

  <!--<xsl:strip-space elements="Message Body"/>-->
  <!--<xsl:preserve-space elements="toRecipients ccRecipients bccRecipients Subject"/> -->

  <!-- output directives -->
  <xsl:output method="html" indent="no" encoding="UTF-8" />

  <!-- parameters -->
  <xsl:param name="lang" select="'en'"/>
  <xsl:param name="id" select="''"/>
  <xsl:param name="sc_item"/>
  <xsl:param name="sc_currentitem"/>
  <xsl:param name="ImageFieldName" select="'Image'"/>
  
  <!-- variables -->
  <xsl:variable name="home" select="$sc_item/ancestor-or-self::item[@template='site root']" />

  <!-- entry point -->
  <xsl:template match="*">
    <xsl:apply-templates select="$sc_item" mode="main"/>
  </xsl:template>

  <!--==============================================================-->
  <!-- main                                                         -->
  <!--==============================================================-->
  <xsl:template match="*" mode="main">
    <xsl:variable name="element_uid" select="generate-id()" />
	<div style="display: inline-block;">
      <script type="text/javascript"> 
        function scmobile_send_email_<xsl:value-of select="$element_uid" disable-output-escaping="yes"/>()
        {
          function htmlDecode( str )
          {
		    if ( str.length == 0 )
			   return '';
            var div = document.createElement('div');
            div.innerHTML  = str;
            return div.firstChild.nodeValue;
          }

		  var email = new scmobile.share.Email();
          var brTagStr_ = unescape('%3C%62%72%2F%3E');
          email.toRecipients  = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('toRecipients' ,$sc_item))"/>' ).split(brTagStr_);
          email.ccRecipients  = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('ccRecipients' ,$sc_item))"/>' ).split(brTagStr_);
          email.bccRecipients = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('bccRecipients',$sc_item))"/>' ).split(brTagStr_);
          email.subject       = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Subject'      ,$sc_item))"/>' );
          
		  var localBody = '<xsl:value-of select="translate( sc:field('Message Body' ,$sc_item), '&#xa;', ' ' )" />';
		  var loc = window.location;
		  var hostPrefix = loc.protocol + '//' + loc.hostname + ':' + loc.port;
		  localBody = localBody.replace( '"~/', '"' + hostPrefix + '/~/' );	  
		  email.messageBody = localBody;
		  
          email.isHTML = true;

          function onSuccess( data )
          {
              scmobile.console.log('onSuccess: ' + data.result);
          }

          function onError( data )
          {
            scmobile.console.log('onError: ' + data.error);
          }

          email.send( onSuccess, onError );
        }
	  </script>
	  <xsl:choose>
	    <xsl:when test="sc:pageMode()/pageEditor/edit">
          <sc:editFrame title="Edit email fields" Buttons="/Sitecore/Content/Applications/WebEdit/Edit Frame Buttons/Mobile SDK/Email" >
		    <sc:image field="Icon" select="$sc_item" disable-web-editing="true"/>
		  </sc:editFrame>
	    </xsl:when>
    	<xsl:otherwise>
	      <a onclick="scmobile_send_email_{$element_uid}()">
            <xsl:value-of select="sc:image('Icon',$sc_item)" disable-output-escaping="yes"/>
          </a>
    	</xsl:otherwise>
	  </xsl:choose>
	</div>
  </xsl:template>

</xsl:stylesheet>
