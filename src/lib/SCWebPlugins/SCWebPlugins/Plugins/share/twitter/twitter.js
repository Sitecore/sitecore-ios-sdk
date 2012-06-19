
scmobile.share = scmobile.share || {}
scmobile.share._construct = function()
{
    function _Tweet()
    {
        var tweetThis  = this;
        this.urls      = [];
        this.imageUrls = [];

        function _send( onSuccess, onError )
        {
            var urlArgs = '';
            tweetThis.urls.forEach(
                function( localUrl_ ) {
                    try
                    {
                        urlArgs = urlArgs + '&url=' + encodeURIComponent( localUrl_ );
                    }
                    catch( exception )
                    {
                        scmobile.console.log( 'Tweet url exception: ' + exception );
                    }
                }
            );

            tweetThis.imageUrls.forEach(
                function( localUrl_ ) {
                    try
                    {
                        urlArgs = urlArgs + '&image_url=' + encodeURIComponent( localUrl_ );
                    }
                    catch( exception )
                    {
                        scmobile.console.log( 'Tweet image_url exception: ' + exception );
                    }
                }
            );

            var encodedText = encodeURIComponent( tweetThis.text ? tweetThis.text : '' );
            var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/share/twitter'
                                                           + '?text=' + encodedText
                                                           + urlArgs );

            webSocket.onmessage = function( data ) {
                var sendResult = eval( '(' + data + ')' );

                if ( sendResult.hasOwnProperty('error') )
                {
                    if ( onError )
                        onError( sendResult.error );
                }
                else
                {
                    if ( onSuccess )
                        onSuccess();
                }
            };

            webSocket.onerror = function( data ) {
                webSocket.close();
                webSocket = null;
            };
        }
        this.send = _send;
    }
    this.Tweet = _Tweet;
}
scmobile.share._construct();
