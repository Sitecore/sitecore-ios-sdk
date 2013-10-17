scmobile.events = {}
scmobile.events._construct = function()
{
    function Event( properties )
    {
        var eventThis = this;
        
        if ( properties )
        {
            this.title = properties.title;
            this.notes = properties.notes;
            this.location = properties.location;
            this.alarm = properties.alarm;
            
            try
            {
                if ( properties.startDate != undefined )
                {
                    if ( properties.startDate.constructor === String )
                    {
                        var startDate = parseFloat( properties.startDate );
                        this.startDate = new Date( startDate );
                    }
                    else if ( properties.startDate.constructor === Date )
                    {
                        this.startDate = properties.startDate;
                    }
                }
            }
            catch( ex ){}
            
            try
            {
                if ( properties.endDate != undefined )
                {
                    if ( properties.endDate.constructor === String )
                    {
                        var endDate = parseFloat( properties.endDate );
                        this.endDate = new Date( endDate );
                    }
                    else if ( properties.endDate.constructor === Date )
                    {
                        this.endDate = properties.endDate;
                    }
                }
            }
            catch( ex ){}
        }
        
        var getSaveEventArgs = function()
        {
            var createArgs = '';

            if ( eventThis.title != undefined )
                createArgs = createArgs + '&title=' + encodeURIComponent( eventThis.title );
           
            if ( eventThis.notes != undefined )
                createArgs = createArgs + '&notes=' + encodeURIComponent( eventThis.notes );
            
            if ( eventThis.location != undefined )
                createArgs = createArgs + '&location=' + encodeURIComponent( eventThis.location );
            
            if ( eventThis.alarm != undefined )
                createArgs = createArgs + '&alarm=' + encodeURIComponent( eventThis.alarm );
            
            try
            {
                if ( eventThis.startDate != undefined )
                {
                    createArgs = createArgs + '&startDate='   + encodeURIComponent( eventThis.startDate.getTime() );
                }
            }
            catch( ex ){
            }
            
            try
            {
                if ( eventThis.endDate != undefined )
                    createArgs = createArgs + '&endDate='   + encodeURIComponent( eventThis.endDate.getTime() );
            }
            catch( ex ){}
            
            return createArgs;
        }
        
        function _save( onSuccess, onError )
        {
            var saveArgs = getSaveEventArgs();
            
            var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/events/save_event'
                                                           + '?1=1'
                                                           + saveArgs );
            
            webSocket.onmessage = function( data ) {
                
                var sendResult = eval( '(' + data + ')' );
                
                if ( sendResult.hasOwnProperty('error') )
                {
                    if ( onError )
                        onError( sendResult.error );
                }
                else
                {
                    eventThis.eventInternalId = sendResult.eventInternalId;
                    
                    if ( onSuccess )
                        onSuccess();
                }
            };
            
            webSocket.onerror = function(event) {
                if ( onError )
                    onError( 'events.Save: socket error' );
                webSocket.close();
            };
        }
        this.save = _save;
        
        function _silentSave( onSuccess, onError )
        {
            var saveArgs = getSaveEventArgs();
            
            var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/events/silent_save_event?s=s'
                                                           + saveArgs );
            
            webSocket.onmessage = function( data ) {
                eventThis.eventInternalId = data;
                
                if ( onSuccess )
                    onSuccess();
            };
            
            webSocket.onerror = function(event) {
                if ( onError )
                    onError( 'events.silentSave: socket error' );
                webSocket.close();
            };
        }
        this.silentSave = _silentSave;
        
    }
    
    function _create( properties )
    {
        return new Event( properties );
    }
    this.create = _create
    
    function _silentSelect( predicate, onSuccess, onError )
    {
        var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/events/silent_select_event' );
        
        webSocket.onmessage = function( data ) {
            
            var eventsJson = eval ( "(" + data + ")" );
            
            var eventsResult = [];
            
            eventsJson.events.forEach(
                                          function( eventsFieldsJSON ) {
                                          var event = new Event( eventsFieldsJSON );
                                          
                                          event.eventInternalId = eventsFieldsJSON.eventInternalId;
                                          
                                          if ( !predicate || predicate( event ) )
                                          eventsResult.push( event );
                                          }
                                          );
            
            if ( onSuccess != undefined )
                onSuccess( eventsResult );
        };
        webSocket.onerror = function(event) {
            if ( onError )
                onError( 'events.silentSelect: socket error' );
            webSocket.close();
        };
    }
    this.silentSelect = _silentSelect
    
    function _select( onSuccess, onError )
    {
        var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/events/select_event' );
        
        webSocket.onmessage = function( data ) {
            
            var eventsJson = eval( '(' + data + ')' );
            
            if ( eventsJson.hasOwnProperty('error') )
            {
                if ( onError )
                    onError( eventsJson.error );
            }
            else
            {
                var eventsResult = [];
                
                eventsJson.events.forEach(
                                              function( eventsFieldsJSON ) {
                                              var event = new Event( eventsFieldsJSON );
                                              event.eventInternalId = eventsFieldsJSON.eventInternalId;
                                              eventsResult.push( event );
                                              }
                                              );
                
                if ( onSuccess )
                    onSuccess( eventsResult );
            }
        };
        webSocket.onerror = function(event) {
            if ( onError )
                onError( 'events.Select: socket error' );
            webSocket.close();
        };
    }
    this.select = _select
}
scmobile.events._construct()