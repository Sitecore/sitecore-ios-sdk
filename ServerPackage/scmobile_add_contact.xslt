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
  exclude-result-prefixes="dot sc">

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
    <xsl:variable name="element_uid_as_js_func_name" select="generate-id()" />
	<div style="display: inline-block;">
    <script type="text/javascript">
      function sc_mobile_add_contact_<xsl:value-of select="$element_uid_as_js_func_name" disable-output-escaping="yes"/>()
      {
         function htmlDecode( str )
         {
		    if ( str.length == 0 )
			   return '';
            var div = document.createElement('div');
            div.innerHTML  = str;
            return div.firstChild.nodeValue;
         }

        var contact_ = scmobile.contacts.create();

        contact_.firstName = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('First Name',$sc_item))"/>' );
		contact_.lastName  = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Last Name' ,$sc_item))"/>' );
		contact_.company   = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Company'   ,$sc_item))"/>' );

		var brTagStr_ = unescape('%3C%62%72%2F%3E');
		contact_.emails   = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Emails',$sc_item))"/>' ).split(brTagStr_);
		contact_.websites = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Sites' ,$sc_item))"/>' ).split(brTagStr_);
		contact_.phones   = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Phones',$sc_item))"/>' ).split(brTagStr_);
		try
		{
		    contact_.birthday = new Date( htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Birthday',$sc_item))"/>' ) );
		}
		catch( ex ) {}
		try
		{
			<xsl:variable name="iconsrc" select="sc:fld('Photo',$sc_item,'src')"/>
			<xsl:if test="$iconsrc">
                contact_.photo = window.location.protocol + '//' + window.location.host + '/' + htmlDecode( '<xsl:value-of select="scmobile:htmlEncode($iconsrc)"/>' );
			</xsl:if>
	    }
		catch( ex ) {}

		var address_ = {};
        address_.street  = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Street' ,$sc_item))"/>' );
        address_.city    = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('City'   ,$sc_item))"/>' );
        address_.state   = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('State'  ,$sc_item))"/>' );
        address_.zip     = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('ZIP'    ,$sc_item))"/>' );
        address_.country = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Country',$sc_item))"/>' );
        contact_.addresses = [ address_ ];

		var onSuccess = function( contacts )
        {
        }
        var onError = function( error )
        {
           scmobile.console.log( 'cannot create Contact' );  
        }
        contact_.save( onSuccess, onError );
      }
	</script>
	  <xsl:choose>
	    <xsl:when test="sc:pageMode()/pageEditor/edit">
          <sc:editFrame title="Edit contact fields" Buttons="/Sitecore/Content/Applications/WebEdit/Edit Frame Buttons/Mobile SDK/Contacts" >
		    <sc:image field="Icon" select="$sc_item" disable-web-editing="true"/>
		  </sc:editFrame>
	    </xsl:when>
    	<xsl:otherwise>
          <a onclick="sc_mobile_add_contact_{$element_uid_as_js_func_name}()">
	        <xsl:value-of select="sc:image('Icon',$sc_item)" disable-output-escaping="yes"/>
          </a>
        </xsl:otherwise>
	  </xsl:choose>
    </div>
  </xsl:template>

</xsl:stylesheet>
