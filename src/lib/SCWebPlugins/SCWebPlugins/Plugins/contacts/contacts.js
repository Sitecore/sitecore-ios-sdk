
scmobile.contacts = {}
scmobile.contacts._construct = function()
{
    function Contact( properties )
    {
        var contactThis = this;

        if ( properties )
        {
            this.firstName = properties.firstName;
            this.lastName  = properties.lastName ;
            this.company   = properties.company  ;
            this.emails    = properties.emails   ;
            this.phones    = properties.phones   ;
            this.websites  = properties.websites ;
            this.photo     = properties.photo    ;

            try
            {
                if ( properties.addresses != undefined )
                {
                    if ( properties.addresses.constructor === String )
                    {
                        var addresses = eval('(' + properties.addresses + ')');;
                        this.addresses = addresses;
                    }
                    else if ( properties.addresses.constructor === Array )
                    {
                        this.addresses = properties.addresses;
                    }
                }
            }
            catch( ex ){}
            try
            {
                if ( properties.birthday != undefined )
                {
                    if ( properties.birthday.constructor === String )
                    {
                        var birthday = parseFloat( properties.birthday );
                        this.birthday = new Date( birthday );
                    }
                    else if ( properties.birthday.constructor === Date )
                    {
                        this.birthday = properties.birthday;
                    }
                }
            }
            catch( ex ){}
        }

        var getSaveContactArgs = function()
        {
            var createArgs = '';
            if ( contactThis.firstName != undefined )
                createArgs = createArgs + '&firstName=' + encodeURIComponent( contactThis.firstName );
            if ( contactThis.lastName != undefined )
                createArgs = createArgs + '&lastName='  + encodeURIComponent( contactThis.lastName );
            if ( contactThis.company != undefined )
                createArgs = createArgs + '&company='   + encodeURIComponent( contactThis.company );
            if ( contactThis.photo != undefined )
                createArgs = createArgs + '&photo='     + encodeURIComponent( contactThis.photo );
            try
            {
                if ( contactThis.birthday != undefined )
                    createArgs = createArgs + '&birthday='   + encodeURIComponent( contactThis.birthday.getTime() );
            }
            catch( ex )
            {
            }
            if ( contactThis.contactInternalId != undefined )
                createArgs = createArgs + '&contactInternalId=' + encodeURIComponent( contactThis.contactInternalId );

            if ( contactThis.emails != undefined )
                contactThis.emails.forEach(
                    function( email ) {
                        createArgs = createArgs + '&emails=' + encodeURIComponent( email );
                    }
                );
            if ( contactThis.phones != undefined )
                contactThis.phones.forEach(
                    function( phone ) {
                        createArgs = createArgs + '&phones=' + encodeURIComponent( phone );
                    }
                );
            if ( contactThis.websites != undefined )
                contactThis.websites.forEach(
                    function( website ) {
                        createArgs = createArgs + '&websites=' + encodeURIComponent( website );
                    }
                );
            if ( contactThis.addresses != undefined
                && contactThis.addresses instanceof Array )
            {
                createArgs = createArgs + '&addresses=' + encodeURIComponent( JSON.stringify(contactThis.addresses) );
            }
            return createArgs;
        }

        function _save( onSuccess, onError )
        {
            var saveArgs = getSaveContactArgs();

            var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/contacts/save_contact'
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
                    contactThis.contactInternalId = sendResult.contactInternalId;

                    if ( onSuccess )
                        onSuccess();
                }
            };

            webSocket.onerror = function(event) {
                if ( onError )
                    onError( 'contacts.silentSave: socket error' );
                webSocket.close();
            };
        }
        this.save = _save;

        function _silentSave( onSuccess, onError )
        {
            var saveArgs = getSaveContactArgs();

            var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/contacts/silent_save_contact?s=s'
                                                           + saveArgs );

            webSocket.onmessage = function( data ) {
                contactThis.contactInternalId = data;

                if ( onSuccess )
                    onSuccess();
            };

            webSocket.onerror = function(event) {
                if ( onError )
                    onError( 'contacts.silentSave: socket error' );
                webSocket.close();
            };
        }
        this.silentSave = _silentSave;
        
        function _remove( onSuccess, onError )
        {
            var removeArgs = '?contactInternalId=' + encodeURIComponent( contactThis.contactInternalId );
            var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/contacts/remove_contact'
                                                           + removeArgs );

            webSocket.onmessage = function( event ) {

                contactThis.contactInternalId = null;

                if ( onSuccess )
                    onSuccess();
            };
            webSocket.onerror = function(event) {
                if ( onError )
                    onError( 'contacts.remove: socket error' );
                webSocket.close();
            };
        }

        this.remove = _remove;
    }

    function _create( properties )
    {
        return new Contact( properties );
    }
    this.create = _create

    function _silentSelect( predicate, onSuccess, onError )
    {
        var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/contacts/silent_select_contact' );

        webSocket.onmessage = function( data ) {

            var contactsJson = eval ( "(" + data + ")" );

            var contactsResult = [];
            
            contactsJson.contacts.forEach(
                function( contactsFieldsJSON ) {
                    var contact = new Contact( contactsFieldsJSON );

                    contact.contactInternalId = contactsFieldsJSON.contactInternalId;
 
                    if ( !predicate || predicate( contact ) )
                        contactsResult.push( contact );
                }
            );

            if ( onSuccess != undefined )
                onSuccess( contactsResult );
        };
        webSocket.onerror = function(event) {
            if ( onError )
                onError( 'contacts.silentSelect: socket error' );
            webSocket.close();
        };
    }
    this.silentSelect = _silentSelect

    function _select( onSuccess, onError )
    {
        var webSocket = new scmobile.utils.SCWebSocket( '/scmobile/contacts/select_contact' );

        webSocket.onmessage = function( data ) {

            var contactsJson = eval( '(' + data + ')' );

            if ( contactsJson.hasOwnProperty('error') )
            {
                if ( onError )
                    onError( contactsJson.error );
            }
            else
            {
                var contactsResult = [];

                contactsJson.contacts.forEach(
                    function( contactsFieldsJSON ) {
                        var contact = new Contact( contactsFieldsJSON );
                        contact.contactInternalId = contactsFieldsJSON.contactInternalId;
                        contactsResult.push( contact );
                    }
                );

                if ( onSuccess )
                    onSuccess( contactsResult );
            }
        };
        webSocket.onerror = function(event) {
            if ( onError )
                onError( 'contacts.silentSelect: socket error' );
            webSocket.close();
        };
    }
    this.select = _select
}
scmobile.contacts._construct()
