
scmobile.share = scmobile.share || {}
scmobile.share._constructEmail = function()
{
    function _Email()
    {
        var emailThis      = this;
        this.toRecipients  = [];
        this.ccRecipients  = [];
        this.bccRecipients = [];
        this.subject       = '';
        this.messageBody   = '';
        this.isHTML        = false;

        function _send( onSuccess, onError ) {
            urlArgs = '';

            emailThis.toRecipients.forEach(
                function( toRecipient_ ) {
                    try {
                        urlArgs = urlArgs + '&to=' + encodeURIComponent( toRecipient_ );
                    }
                    catch( exception_ ) {
                        scmobile.console.log( 'Email toRecipient exception: ' + exception_ );
                    }
                }
            );
            emailThis.ccRecipients.forEach(
                function( ccRecipient_ ) {
                    try {
                        urlArgs = urlArgs + '&cc=' + encodeURIComponent( ccRecipient_ );
                    }
                    catch( exception_ ) {
                        scmobile.console.log( 'Email ccRecipient exception: ' + exception_ );
                    }
                }
            );
            emailThis.bccRecipients.forEach(
                function( bccRecipient_ ) {
                    try {
                        urlArgs = urlArgs + '&bcc=' + encodeURIComponent( bccRecipient_ );
                    }
                    catch( exception_ ) {
                        scmobile.console.log( 'Email bccRecipients exception: ' + exception_ );
                    }
                }
            );

            var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/share/email'
                                          + '?subject=' + encodeURIComponent( emailThis.subject )
                                          + '&body='    + encodeURIComponent( emailThis.messageBody )
                                          + '&isHTML='  + encodeURIComponent( emailThis.isHTML )
                                          + urlArgs
                                          );

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
                        onSuccess( sendResult );
                }
            };

            webSocket.onerror = function( data ) {
                webSocket.close();
                webSocket = null;
            };
        }
        this.send = _send;
    }
    this.Email = _Email;
}
scmobile.share._constructEmail();
