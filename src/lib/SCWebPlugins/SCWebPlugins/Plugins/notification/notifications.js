
scmobile.notification = {}
scmobile.notification._construct = function()
{
    //title: Dialog title (String)
    //message: Dialog message (String)
    //confirmCallback: Callback to invoke when alert dialog is dismissed. (Function)
    //buttonNames: Button names (String) (Optional, Default: "OK", Example: "Cancel,OK")
    function _alert( title, message, confirmCallback, buttonNames )
    {
        title       = title.trim();
        message     = message.trim();
        buttonNames = buttonNames.trim();

        var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/notification/alert?title=' + encodeURIComponent( title )
                                                       + '&message=' + encodeURIComponent( message )
                                                       + '&buttonNames=' + encodeURIComponent( buttonNames ) );

        var result_ = {};

        //STODO implement it ?
        webSocket.onopen = function( event ) {
            result_.opened = true;
            if ( result_.closeOnOpen )
            {
                webSocket.send( result_.closeOnOpenIndex );
                webSocket.close();
                webSocket = null;
            }
        };

        webSocket.onmessage = function( data ) {

            var alertEvent = eval( '(' + data + ')' );

            if ( alertEvent.hasOwnProperty('closeIndex') )
            {
                if ( confirmCallback )
                    confirmCallback( alertEvent.closeIndex );
                webSocket.close();
                webSocket = null;
            }
            else if ( alertEvent.hasOwnProperty('didPresent') )
            {
                if ( result_.onPresent )
                    result_.onPresent();
            }
        };

        webSocket.onerror = function( event ) {
            if ( confirmCallback )
                confirmCallback( 'error: ' + event.data );
            webSocket.close();
            webSocket = null;
        };

        result_.dismissWithIndex = function ( index ) {
            if ( webSocket.opened )
            {
                webSocket.send( index );
                webSocket.close();
                webSocket = null;
            }
            else
            {
                result_.closeOnOpen = true;
                result_.closeOnOpenIndex = index;
            }
        };
        return result_;
    }
    //List of things to place publically
    this.alert = _alert;

    this.beep = function()
    {
        new scmobile.utils.SCWebSocket( '/scmobile/notification/beep' );
    };
}
scmobile.notification._construct()
