
scmobile.contentapi = {};
scmobile.contentapi._construct = function()
{
    function _createMediaItem( mediaItemInfo, onSuccess, onError )
    {
        var createArgs = '';
        if ( mediaItemInfo.imageUrl != undefined )
        {
            createArgs = createArgs + '&imageUrl=' + encodeURIComponent( mediaItemInfo.imageUrl );
        }

        if ( mediaItemInfo.login != undefined )
        {
            createArgs = createArgs + '&login=' + encodeURIComponent( mediaItemInfo.login );
        }

        if ( mediaItemInfo.password != undefined )
        {
            createArgs = createArgs + '&password=' + encodeURIComponent( mediaItemInfo.password );
        }

        if ( mediaItemInfo.database != undefined )
        {
            createArgs = createArgs + '&database=' + encodeURIComponent( mediaItemInfo.database );
        }

        if ( mediaItemInfo.path != undefined )
        {
            createArgs = createArgs + '&path=' + encodeURIComponent( mediaItemInfo.path );
        }

        if ( mediaItemInfo.itemName != undefined )
        {
            createArgs = createArgs + '&itemName=' + encodeURIComponent( mediaItemInfo.itemName );
        }

        if ( mediaItemInfo.site != undefined )
        {
            createArgs = createArgs + '&site=' + encodeURIComponent( mediaItemInfo.site );
        }
        
        if ( mediaItemInfo.language != undefined )
        {
            createArgs = createArgs + '&language=' + encodeURIComponent( mediaItemInfo.language );
        }
        
        if ( mediaItemInfo.compressionQuality != undefined )
        {
            createArgs = createArgs + '&compressionQuality=' + encodeURIComponent( mediaItemInfo.compressionQuality );
        }

        if ( mediaItemInfo.fields != undefined )
        {
            createArgs = createArgs + '&fields=' + encodeURIComponent( JSON.stringify(mediaItemInfo.fields) );
        }
        

        var protocolAndHost_ = window.location.protocol + '//' + window.location.host;
        createArgs = createArgs + '&location=' + encodeURIComponent( protocolAndHost_ );

        var socket_ = new scmobile.utils.SCWebSocket( '/scmobile/contentapi/create_media_item?1=1'
                                                     + createArgs );

        //
        socket_.onmessage = function( message )
        {
            var data = eval( '(' + message + ')' );

            if ( data.error )
            {
                onError( data.error );
            }
            else
            {
                onSuccess( data.items );
            }
        }
    }

    this.createMediaItem = _createMediaItem;
}
scmobile.contentapi._construct()
