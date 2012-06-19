
scmobile.google_maps = scmobile.share || {}
scmobile.google_maps._construct = function()
{
    function _GoogleMaps()
    {
        this.addresses    = [];
        this.drawRoute    = false;
        this.regionRadius = 100000000.;

        var googleMapsThis_ = this;

        function _show()
        {
            var urlArgs_ = '';

            if ( googleMapsThis_.addresses != undefined
                && googleMapsThis_.addresses instanceof Array )
            {
                urlArgs_ = urlArgs_ + '&addresses=' + encodeURIComponent( JSON.stringify( googleMapsThis_.addresses ) );
            }

            urlArgs_ = urlArgs_ + '&drawRoute='    + googleMapsThis_.drawRoute;
            urlArgs_ = urlArgs_ + '&regionRadius=' + googleMapsThis_.regionRadius;

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
