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
      function scmobile_show_addresses_<xsl:value-of select="$element_uid_as_js_func_name" disable-output-escaping="yes"/>()
      {
         function htmlDecode( str )
         {
		    if ( str.length == 0 )
			   return '';
            var div = document.createElement('div');
            div.innerHTML  = str;
            return div.firstChild.nodeValue;
         }

         var maps_ = new scmobile.google_maps.GoogleMaps();
         <xsl:choose>
           <xsl:when test="sc:fld( 'Show Route', $sc_item )">
             maps_.drawRoute = true;
           </xsl:when>
           <xsl:otherwise>
             maps_.drawRoute = false;
           </xsl:otherwise>
         </xsl:choose>

		maps_.regionRadius = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Region Radius', $sc_item))"/>' );

		<!-- If multilistfield is not empty -->
        <xsl:if test="sc:fld('Addresses',$sc_item)!=''">
          <!-- Holding guids in variable -->
          <xsl:variable name="guids" select="sc:Split('Addresses',$sc_item)" />
          <!-- Looping selected guids -->
          <xsl:for-each select="$guids">

		    <xsl:variable name="address" select="sc:item(.,.)" />
		    <xsl:variable name="iconsrc" select="sc:fld('Icon',$address,'src')"/>

		    try {
		      var address_ = {};
			  maps_.addresses.push( address_ );

              address_.icon = window.location.protocol + '//' + window.location.host + '/' +
			    htmlDecode( '<xsl:value-of select="scmobile:htmlEncode($iconsrc)"/>' );

              address_.title   = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Title'  , $address))"/>' );
              address_.street  = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Street' , $address))"/>' );
              address_.city    = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('City'   , $address))"/>' );
              address_.state   = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('State'  , $address))"/>' );
              address_.zip     = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('ZIP'    , $address))"/>' );
              address_.country = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Country', $address))"/>' );
           }
		   catch( ex ) {
		       scmobile.console.log( 'exception: ' + ex ); 
		   }
          </xsl:for-each>
        </xsl:if>

        maps_.show();
      }
	</script>
	  <xsl:choose>
	    <xsl:when test="sc:pageMode()/pageEditor/edit">
          <sc:editFrame title="Edit map fields" Buttons="/Sitecore/Content/Applications/WebEdit/Edit Frame Buttons/Mobile SDK/Map" >
		    <sc:image field="Icon" select="$sc_item" disable-web-editing="true"/>
		  </sc:editFrame>
	    </xsl:when>
    	<xsl:otherwise>
          <a onclick="scmobile_show_addresses_{$element_uid_as_js_func_name}()">
	        <xsl:value-of select="sc:image('Icon',$sc_item)" disable-output-escaping="yes"/>
          </a>
        </xsl:otherwise>
	  </xsl:choose>
    </div>
  </xsl:template>

</xsl:stylesheet>
