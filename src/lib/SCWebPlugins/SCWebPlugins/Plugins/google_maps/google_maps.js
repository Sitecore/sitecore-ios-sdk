
scmobile.google_maps = scmobile.share || {}
scmobile.google_maps._construct = function()
{
    function _GoogleMaps()
    {
        this.addresses    = [];
        this.drawRoute    = false;
        this.regionRadius = 100000.;

        var googleMapsThis_ = this;

        function _show()
        {
            var urlArgs_ = '';

            if ( googleMapsThis_.addresses != undefined
                && googleMapsThis_.addresses instanceof Array )
            {
                urlArgs_ = urlArgs_ + '&addresses=' + encodeURIComponent( JSON.stringify( googleMapsThis_.addresses ) );
            }

            scmobile.console.log( 'region radius: ' + googleMapsThis_.regionRadius )
            for (var key in googleMapsThis_) {
                if (googleMapsThis_.hasOwnProperty(key)) {
                    scmobile.console.log( 'googleMapsThis_ key : ' + key )
                }
            }
            
            urlArgs_ = urlArgs_ + '&drawRoute='    + googleMapsThis_.drawRoute;
            urlArgs_ = urlArgs_ + '&regionRadius=' + googleMapsThis_.regionRadius;
            urlArgs_ = urlArgs_ + '&cameraLatitude=' + googleMapsThis_.cameraLatitude;
            urlArgs_ = urlArgs_ + '&cameraLongitude=' + googleMapsThis_.cameraLongitude;
            urlArgs_ = urlArgs_ + '&cameraHeight=' + googleMapsThis_.cameraHeight;
            urlArgs_ = urlArgs_ + '&viewPointLatitude=' + googleMapsThis_.viewPointLatitude;
            urlArgs_ = urlArgs_ + '&viewPointLongitude=' + googleMapsThis_.viewPointLongitude;
            
            var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/google_maps/showAdresses?1=1'
                                                           + urlArgs_ );

            webSocket.onerror = function( data ) {
                webSocket.close();
                webSocket = null;
            };
        }
        this.show = _show;
    }
    this.GoogleMaps = _GoogleMaps;
}

scmobile.google_maps._construct();
