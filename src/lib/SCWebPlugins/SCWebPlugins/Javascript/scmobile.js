//STODO pack this file before compile

String.prototype.trim = function () {
    return this.replace(/^\s*/, "").replace(/\s*$/, "");
};

//namespace http://stackoverflow.com/questions/881515/javascript-namespace-declaration
var scmobile = {};

scmobile.version = '1.0';
scmobile.device = {};

scmobile._construct = function() {}
scmobile._construct()

scmobile.utils = {};
scmobile.utils._construct = function()
{
    this.base64 = {

        // private property
        _keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

        // public method for encoding
        encode : function (input) {
            var output = "";
            var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
            var i = 0;

            input = scmobile.utils.base64._utf8_encode(input);

            while (i < input.length) {

                chr1 = input.charCodeAt(i++);
                chr2 = input.charCodeAt(i++);
                chr3 = input.charCodeAt(i++);

                enc1 = chr1 >> 2;
                enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                enc4 = chr3 & 63;

                if (isNaN(chr2)) {
                    enc3 = enc4 = 64;
                } else if (isNaN(chr3)) {
                    enc4 = 64;
                }

                output = output +
                this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
                this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
            }

            return output;
        },

        // public method for decoding
        decode : function (input) {
            var output = "";
            var chr1, chr2, chr3;
            var enc1, enc2, enc3, enc4;
            var i = 0;

            input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

            while (i < input.length) {

                enc1 = this._keyStr.indexOf(input.charAt(i++));
                enc2 = this._keyStr.indexOf(input.charAt(i++));
                enc3 = this._keyStr.indexOf(input.charAt(i++));
                enc4 = this._keyStr.indexOf(input.charAt(i++));

                chr1 = (enc1 << 2) | (enc2 >> 4);
                chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
                chr3 = ((enc3 & 3) << 6) | enc4;

                output = output + String.fromCharCode(chr1);

                if (enc3 != 64) {
                    output = output + String.fromCharCode(chr2);
                }
                if (enc4 != 64) {
                    output = output + String.fromCharCode(chr3);
                }
            }

            output = scmobile.utils.base64._utf8_decode(output);

            return output;
        },

        // private method for UTF-8 encoding
        _utf8_encode : function (string) {
            string = string.replace(/\r\n/g,"\n");
            var utftext = "";

            for (var n = 0; n < string.length; n++) {

                var c = string.charCodeAt(n);

                if (c < 128) {
                    utftext += String.fromCharCode(c);
                }
                else if((c > 127) && (c < 2048)) {
                    utftext += String.fromCharCode((c >> 6) | 192);
                    utftext += String.fromCharCode((c & 63) | 128);
                }
                else {
                    utftext += String.fromCharCode((c >> 12) | 224);
                    utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                    utftext += String.fromCharCode((c & 63) | 128);
                }
                
            }
            
            return utftext;
        },
        
        // private method for UTF-8 decoding
        _utf8_decode : function (utftext) {
            var string = "";
            var i = 0;
            var c = c1 = c2 = 0;
            
            while ( i < utftext.length ) {
                
                c = utftext.charCodeAt(i);
                
                if (c < 128) {
                    string += String.fromCharCode(c);
                    i++;
                }
                else if((c > 191) && (c < 224)) {
                    c2 = utftext.charCodeAt(i+1);
                    string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                    i += 2;
                }
                else {
                    c2 = utftext.charCodeAt(i+1);
                    c3 = utftext.charCodeAt(i+2);
                    string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                    i += 3;
                }
            }
            
            return string;
        }
    };

    function _guid()
    {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                                                              var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
                                                              return v.toString(16);
                                                              });
    }
    this.guid = _guid;

    var scWebSocketByGUID = {};
    var scSCWebSocketRedirects = [];

    function performSCWebSocketRedirect( newLocation )
    {
        scSCWebSocketRedirects.push( newLocation );

        var delay_ = scSCWebSocketRedirects.length * 10.;

        setTimeout(function()
        {
            if ( scSCWebSocketRedirects.length > 0 )
            {
                var currLocation = scSCWebSocketRedirects[ 0 ];
                window.location = currLocation;
                scSCWebSocketRedirects.splice(0,1);
            }
        }, delay_ );
    }

    function _SCWebSocket( path_ )
    {
        this.guid = scmobile.utils.guid();
        scWebSocketByGUID[ this.guid ] = this;
        this.opened = true;

        var scWebSocketThis = this;

        var pathWithParams = ( typeof path_ === 'undefined' ? '/' : path_ );
        if ( pathWithParams.charAt(0) != '/' )
        {
            pathWithParams = '/' + pathWithParams;
        }
        if ( pathWithParams.indexOf("?") != -1 )
        {
            pathWithParams = pathWithParams + '&';
        }
        else
        {
            pathWithParams = pathWithParams + '?';
        }
        pathWithParams = pathWithParams + 'guid=' + this.guid;
        performSCWebSocketRedirect( 'sc://localhost' + pathWithParams );

        function _privateCloseSocket()
        {
            if ( scWebSocketThis.opened )
            {
                scWebSocketThis.opened = false;
                delete scWebSocketByGUID[scWebSocketThis.guid];
            }
        }
        this.privateCloseSocket = _privateCloseSocket;

        function _close()
        {
            scmobile.console.log( 'Web Socket close called' );
            if ( scWebSocketThis.opened )
            {
                performSCWebSocketRedirect( 'sc://localhost/didClose?guid=' + scWebSocketThis.guid );
                scWebSocketThis.privateCloseSocket();
            }
        }
        this.close = _close;

        function _send( message )
        {
            performSCWebSocketRedirect( 'sc://localhost?message=' + encodeURIComponent( message ) + '&guid=' + scWebSocketThis.guid );
        }
        this.send = _send;
    }
    this.SCWebSocket = _SCWebSocket;

    function _closeSCWebSocketWithGUID( guid )
    {
        var socket_ = scWebSocketByGUID[ guid ];
        if ( socket_ )
        {
            socket_.privateCloseSocket();
            if ( socket_.onclose != undefined )
                socket_.onclose();
        }
    }
    this.internalCloseSCWebSocketWithGUID = _closeSCWebSocketWithGUID;

    function _sendMessageSCWebSocketWithGUID( guid, message )
    {
        var socket_ = scWebSocketByGUID[ guid ];
        if ( socket_ && socket_.onmessage )
        {
            socket_.onmessage( scmobile.utils.base64.decode( message ) );
        }
    }

    this.internalSendMessageSCWebSocketWithGUID = _sendMessageSCWebSocketWithGUID;
}
scmobile.utils._construct()

//STODO impelement or use html 5 geolocation
scmobile.geolocation = {}
scmobile.geolocation._construct = function()
{
    //STODO add options
    function _getCurrentPosition( geolocationSuccess, geolocationError )
    {
        var webSocket = new WebSocket( 'ws://localhost:' + scmobile.device.socketPort + '/scmobile/geolocation/get_position' );

        webSocket.onmessage = function( event ) {
            var currentPosition = eval( "(" + event.data + ")" );

            if ( geolocationSuccess )
                geolocationSuccess( currentPosition );

            webSocket.close();
        };
        
        webSocket.onerror = function(event) {
            if ( onError )
                onError( 'geolocation.getCurrentPosition: socket error' );
            webSocket.close();
        };
    }
    this.getCurrentPosition = _getCurrentPosition;
}
scmobile.geolocation._construct()

scmobile.console = {}
scmobile.console._construct = function()
{
    function _log( message )
    {
        new WebSocket( 'ws://localhost:' + scmobile.device.socketPort + '/scmobile/console/log?log=' + encodeURIComponent( message ) );
    }

    //List of things to place publically
    this.log = _log
}
scmobile.console._construct()

scmobile.gesture_recognizer = {}
scmobile.gesture_recognizer._construct = function()
{
    this.__internal_observers = [];

    var gestureThis = this;

    function _fireSwipeEvent( eventType )
    {
        var observersCopy = gestureThis.__internal_observers.slice();
        observersCopy.forEach(
                              function(el) {
                              el.call(gestureThis, eventType);
                              }
                              );
    }
    this.fireSwipeEvent = _fireSwipeEvent
    
    function _Swipe()
    {
        this.onRightSwipe = function(){};
        this.onLeftSwipe = function(){};
        var swipeThis = this;
        
        var fun_ = function( eventType ) {
            if ( eventType == 'left' )
                swipeThis.onLeftSwipe();
            else
                swipeThis.onRightSwipe();
        }

        gestureThis.__internal_observers.push( fun_ );

        this.stop = function() {
            gestureThis.__internal_observers = gestureThis.__internal_observers.filter(
                function(el) {
                    if ( el !== fun_ ) {
                        return el;
                    }
                }
            );
        }
    }
    
    //List of things to place publically
    this.Swipe = _Swipe
}
scmobile.gesture_recognizer._construct()

__private_scmobile_is_first_page = true;
__private_scmobile_is_last_page  = true;

scmobile.navigations = {}
scmobile.navigations._construct = function()
{
    var scmobileNavigationsThis = this;

    function _scmForwardLink(){
        var elements = document.getElementsByTagName("link");
        for(var i=0;i<elements.length;i++){
            if ( elements[i].rel == 'scm-forward' )
                return elements[i].href;
        }
        return null;
    }
    this.scmForwardLink = _scmForwardLink;

    function _scmBackwardLink(){
        var elements = document.getElementsByTagName("link");
        for(var i=0;i<elements.length;i++){
            if ( elements[i].rel == 'scm-back' )
                return elements[i].href;
        }
        return null;
    }
    this.scmBackwardLink = _scmBackwardLink;

    function _hasSCMForwardLink(){
        var elements = document.getElementsByTagName("link");
        for(var i=0;i<elements.length;i++){
            if ( elements[i].rel == 'scm-forward' )
                return true;
        }
        return false;
    }
    this.hasSCMForwardLink = _hasSCMForwardLink;

    function _hasSCMBackwardLink(){
        var elements = document.getElementsByTagName("link");
        for(var i=0;i<elements.length;i++){
            if ( elements[i].rel == 'scm-back' )
                return true;
        }
        return false;
    }
    this.hasSCMBackwardLink = _hasSCMBackwardLink;

    function _swipeBack()
    {
        window.location = "scr://swipe_back";
    }
    this.swipeBack = _swipeBack;

    function _swipeForward()
    {
        window.location = "scr://swipe_forward";
    }
    this.swipeForward = _swipeForward;

    function _isEmpty(str) {
        return (!str || 0 === str.length);
    }

    function _canSwipeBack()
    {
        var link = scmobileNavigationsThis.scmBackwardLink();
        return !_isEmpty(link) || !__private_scmobile_is_first_page;
    }
    this.canSwipeBack = _canSwipeBack;

    function _canSwipeForward()
    {
        var link = scmobileNavigationsThis.scmForwardLink();
        return !_isEmpty(link) || !__private_scmobile_is_last_page;
    }
    this.canSwipeForward = _canSwipeForward;
}
scmobile.navigations._construct()

scmobile.device = {}
scmobile.device._construct = function()
{
    function _pr_fireDeviceReady()
    {
        var evt = document.createEvent('Event');
        evt.initEvent( 'scmobileReady', true, false);
        document.dispatchEvent( evt );
    }
    this.__fireDeviceReady = _pr_fireDeviceReady

    function _pr_firePause()
    {
        var evt = document.createEvent('Event');
        evt.initEvent( 'pause', true, false);
        document.dispatchEvent( evt );
    }
    this.__firePause = _pr_firePause

    function _pr_fireResume()
    {
        var evt = document.createEvent('Event');
        evt.initEvent( 'resume', true, false);
        document.dispatchEvent( evt );
    }
    this.__fireResume = _pr_fireResume
}
scmobile.device._construct()
