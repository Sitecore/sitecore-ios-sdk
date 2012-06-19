
scmobile.motion_manager = {}
scmobile.motion_manager._construct = function()
{
    function _subscribeAccelerometer( accelerometerThis )
    {
        var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/motion_manager/accelerometer' );

        webSocket.onmessage = function( data ) {
            var accelerationJson = eval ( "(" + data + ")" );
            accelerometerThis.onAcceleration( accelerationJson );
        };

        webSocket.onerror = function(event) {
            scmobile.console.log('ws: onerror, ' + event.data);
            webSocket.close();
        };

        accelerometerThis.stop = function() {
            webSocket.close();
        }
    }
    function _Accelerometer()
    {
        this.onAcceleration = function(){};
        var accelerometerThis = this;

        _subscribeAccelerometer( accelerometerThis );
    }

    //List of things to place publically
    this.Accelerometer = _Accelerometer
}
scmobile.motion_manager._construct()
