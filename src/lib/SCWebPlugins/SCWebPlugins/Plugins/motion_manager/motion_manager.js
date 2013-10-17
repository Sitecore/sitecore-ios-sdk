scmobile.motion_manager = {}
scmobile.motion_manager._construct = function()
{
    function Motion()
    {
        var accelerometerThis = this;
        var webSocket;
        
        function _subscribeAccelerometer( accelerometerThis )
        {
            webSocket.onmessage = function( data ) {
                
                var accelerationJson = eval ( "(" + data + ")" );
                accelerometerThis.onAcceleration( accelerationJson );
            };
            
            webSocket.onerror = function(event) {
                accelerometerThis.onError();
                scmobile.console.log('ws: onerror, ' + event.data);
                webSocket.close();
            };
        }

        function _start(onSuccess, onError)
        {
            //previous accelerometer listener will be deallocated
            if ( webSocket )
              webSocket.close();
            
            webSocket = new scmobile.utils.SCWebSocket( '/scmobile/motion_manager/start' );
            scmobile.console.log('[START]');
            accelerometerThis.onAcceleration = onSuccess;
            accelerometerThis.onError = onError;
            
            _subscribeAccelerometer( accelerometerThis );
        }
        this.start = _start
        
        function _stop(onSuccess, onError)
        {
            scmobile.console.log('[STOP]');
            webSocket.close();
        }
        this.stop = _stop
    }
    
    function _Accelerometer()
    {
        scmobile.console.log('[CREATE]');
        return new Motion();
    }
    this.Accelerometer = _Accelerometer
}
scmobile.motion_manager._construct()