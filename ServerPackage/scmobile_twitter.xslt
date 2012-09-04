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

	  function scmobile_send_tweet_<xsl:value-of select="$element_uid_as_js_func_name" disable-output-escaping="yes"/>()
      {
	     function htmlDecode( str )
         {
		    if ( str.length == 0 )
			   return '';
            var div = document.createElement('div');
            div.innerHTML  = str;
            return div.firstChild.nodeValue;
         }
            function when_ok( imageURI )
			{
                  var tweet_ = new scmobile.share.Tweet();
                  tweet_.text = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Text',$sc_item))"/>' );

				  if ( imageURI )
				  {
                     tweet_.imageUrls.push( imageURI );
                  }

				  var brTagStr_ = unescape('%3C%62%72%2F%3E');
				  tweet_.urls = htmlDecode( '<xsl:value-of select="scmobile:htmlEncode(sc:field('Urls',$sc_item))"/>' ).split(brTagStr_);

				  function okSend()
                  {
                        scmobile.console.log( 'Twitter send Ok' );
                  }
                  function errorSend( error )
                  {
                        scmobile.console.log( 'Twitter errorSend: ' + error );
                  }
                  tweet_.send( okSend, errorSend );
            }

            function when_error() {
                  scmobile.console.log( 'getPicture ERROR' );
            }

			<xsl:choose>
    		  <xsl:when test="sc:fld('Camera Mode',$sc_item) = 'Camera Snapshot'">
			    var options = {};
				if ( scmobile.camera.PictureSourceType.CAMERA )
				{
				   options.sourceType = scmobile.camera.PictureSourceType.CAMERA;
				}
    		    scmobile.camera.getPicture( when_ok, when_error, options );
    		  </xsl:when>
    		  <xsl:when test="sc:fld('Camera Mode',$sc_item) = 'Photo Album'">
			    var options = { sourceType: scmobile.camera.PictureSourceType.SAVEDPHOTOALBUM };
    		    scmobile.camera.getPicture( when_ok, when_error, options );
    		  </xsl:when>
    		  <xsl:when test="sc:fld('Camera Mode',$sc_item) = 'Photo Library'">
			    var options = { sourceType: scmobile.camera.PictureSourceType.PHOTOLIBRARY };
    		    scmobile.camera.getPicture( when_ok, when_error, options );
    		  </xsl:when>
    		  <xsl:otherwise>
   		        when_ok();
    		  </xsl:otherwise>
    		</xsl:choose>
      }
	</script>
	  <xsl:choose>
	    <xsl:when test="sc:pageMode()/pageEditor/edit">
          <sc:editFrame title="Edit tweet fields" Buttons="/Sitecore/Content/Applications/WebEdit/Edit Frame Buttons/Mobile SDK/Twitter" >
		    <sc:image field="Icon" select="$sc_item" disable-web-editing="true"/>
		  </sc:editFrame>
	    </xsl:when>
    	<xsl:otherwise>
          <a onclick="scmobile_send_tweet_{$element_uid_as_js_func_name}()">
            <xsl:value-of select="sc:image('Icon',$sc_item)" disable-output-escaping="yes"/>
          </a> 
	    </xsl:otherwise>
	  </xsl:choose>
    </div>
  </xsl:template>

</xsl:stylesheet>
