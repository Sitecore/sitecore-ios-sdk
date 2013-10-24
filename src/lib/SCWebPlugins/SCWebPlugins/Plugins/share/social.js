
scmobile.share = scmobile.share || {}
scmobile.share._constructSocial = function()
{
    function _genericSend( socialThis, onSuccess, onError )
    {
        var urlArgs = '';
        socialThis.urls.forEach(
                                
        function( localUrl_ )
        {
            try
            {
                urlArgs = urlArgs + '&url=' + encodeURIComponent( localUrl_ );
            }
            catch( exception )
            {
                scmobile.console.log( 'Tweet url exception: ' + exception );
            }
        } );
        
        socialThis.imageUrls.forEach(
        function( localUrl_ )
        {
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
        
        //
        var encodedText = encodeURIComponent( socialThis.text ? socialThis.text : '' );
        
        var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/share/generic_social'
                                                       + '?social_engine=' + socialThis.engineName
                                                       + '&text=' + encodedText
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
    
    function _Tweet()
    {
        var tweetThis  = this;
        
        this.engineName  = 'twitter';
        this.urls      = [];
        this.imageUrls = [];
        this.text      = '';

        function _send( onSuccess, onError )
        {
            _genericSend( tweetThis, onSuccess, onError )
        }
        this.send = _send;
    }
    this.Tweet = _Tweet;
    
    
    function _Facebook()
    {
        var facebookThis  = this;
        
        this.engineName  = 'facebook';
        this.urls      = [];
        this.imageUrls = [];
        this.text      = '';
        
        function _send( onSuccess, onError )
        {
            _genericSend( facebookThis, onSuccess, onError )
        }
        this.send = _send;
    }
    this.Facebook = _Facebook;
    
    function _Weibo()
    {
        var weiboThis  = this;
        
        this.engineName  = 'weibo';
        this.urls      = [];
        this.imageUrls = [];
        this.text      = '';
        
        function _send( onSuccess, onError )
        {
            _genericSend( weiboThis, onSuccess, onError )
        }
        this.send = _send;
    }
    this.Weibo = _Weibo;
    
    function _Social()
    {
        var socialThis  = this;
        
        this.urls      = [];
        this.imageUrls = [];
        this.text      = '';
        
        function _send( onSuccess, onError )
        {
            _genericSend( socialThis, onSuccess, onError )
        }
        this.send = _send;
    }
    this.Social = _Social;
}
scmobile.share._constructSocial();
