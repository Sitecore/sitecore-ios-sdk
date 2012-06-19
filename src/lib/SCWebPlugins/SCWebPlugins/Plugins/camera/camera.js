
//scmobile.camera.getPicture( cameraSuccess, cameraError, [ cameraOptions ] );
//STODO add options
//{ quality : 75, 
//  destinationType : Camera.DestinationType.DATA_URL, 
//  allowEdit : true,
//  encodingType: Camera.EncodingType.JPEG,
//  targetWidth: 100,
//  targetHeight: 100 };
scmobile.camera = scmobile.camera || {}
scmobile.camera._construct = function()
{
    function _getPicture( cameraSuccess, cameraError, options )
    {
        options = options || {};
        options.sourceType = options.sourceType || scmobile.camera.PictureSourceType.PHOTOLIBRARY;

        var socket_ = new scmobile.utils.SCWebSocket( '/scmobile/camera/get_picture'
                                                     + '?sourceType=' + options.sourceType );

        socket_.onmessage = function( message )
        {
            var data = eval( '(' + message + ')' );

            if ( data.error )
            {
                cameraError( data );
            }
            else
            {
                cameraSuccess( data.url );
            }
        }
    }

    this.getPicture = _getPicture
}
scmobile.camera._construct()
