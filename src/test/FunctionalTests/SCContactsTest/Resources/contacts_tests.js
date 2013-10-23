
function resultCallback( resultData )
{
    window.location = ( "http://" + resultData )
};

function testFindContactWithFirstName( contactName )
{
    try
    {
        function onDeviceReady()
        {
            var onSuccess = function( contacts )
            {
                if ( contacts && contacts.length == 1 )
                {
                    var contact = contacts[0];
                    if ( contact.firstName == contactName && contact.contactInternalId > 0 )
                    {
                        resultCallback( "OK" );
                    }
                    else
                    {
                        resultCallback( "FAIL_INVALID_NAME" );
                    }
                }
                else
                {
                    resultCallback( "FAIL_ACCOUNTS_COUNT_" + contacts.length );
                }
            }
            var onError = function( error )
            {
                resultCallback( "FAIL_FIND_ERROR_CALLBACK" );
            }

            var predicate = function( contact ){ return ( contact.firstName == contactName ) };
            scmobile.contacts.silentSelect( predicate, onSuccess, onError );
        }

        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};

function testCreateContactWithFirstName( contactName )
{
    try
    {
        function onDeviceReady()
        {
            var contact = scmobile.contacts.create( { firstName: contactName } );

            var onSuccess = function()
            {
                if ( contact.firstName == contactName && contact.contactInternalId > 0 )
                {
                    resultCallback( "OK" );
                }
                else
                {
                    resultCallback( "FAIL_INVALID_NAME" );
                }
            }
            var onError = function( error )
            {
                resultCallback( "CREATE_ERROR_CALLBACK" );
            }

            contact.silentSave( onSuccess, onError );
        }

        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
}

function testFindContactWithFirstLastName( contactName, contactLName )
{
   try
   {
      function onDeviceReady()
      {
         var onSuccess = function( contacts )
         {
            if ( contacts && contacts.length == 1 )
            {
               var contact = contacts[0];
               if ( contact.firstName == contactName 
                   && contact.lastName == contactLName 
                   && contact.contactInternalId > 0 )
               {
                  resultCallback( "OK" );
               }
               else
               {
                  resultCallback( "FAIL_INVALID_NAME" );
               }
            }
            else
            {
               resultCallback( "FAIL_ACCOUNTS_COUNT_" + contacts.length );
            }
         }
         var onError = function( error )
         {
            resultCallback( "FAIL_FIND_ERROR_CALLBACK" );
         }
         
         var predicate = function( contact ){ return ( contact.firstName == contactName && contact.lastName == contactLName ) };
         scmobile.contacts.silentSelect( predicate, onSuccess, onError );
      }
      
      // Wait for Device2Web to load
      document.addEventListener('scmobileReady', onDeviceReady, false);
   }
   catch( exception )
   {
      resultCallback( "EXCEPTION" );
   }

}


function testCreateContactWithFirstLastName( contactName, contactLName )
{
   try
   {
      function onDeviceReady()
      {
         var contact = scmobile.contacts.create( { firstName: contactName, lastName: contactLName } );

         var onSuccess = function()
         {
            if ( contact.firstName == contactName 
                && contact.lastName == contactLName 
                && contact.contactInternalId > 0 )
            {
               resultCallback( "OK" );
            }
            else
            {
               resultCallback( "FAIL_INVALID_NAME" );
            }
         }
         var onError = function( error )
         {
            resultCallback( "CREATE_ERROR_CALLBACK" );
         }

         contact.silentSave( onSuccess, onError );
         return 'JS->testCreateContactWithFirstLastName';
      }

      // Wait for Device2Web to load
      document.addEventListener('scmobileReady', onDeviceReady, false);
   }
   catch( exception )
   {
      resultCallback( "EXCEPTION" );
   }
};

function testNoContacts()
{
    try
    {
        var onSuccess = function( contacts )
        {
            if ( contacts.length == 0 )
            {
                resultCallback( "OK" );
            }
            else
            {
                resultCallback( "SHOULD_NOT_HAVE_CONTACTS" );
            }
        }
        var onError = function( error )
        {
            resultCallback( "FAIL_FIND_ERROR_CALLBACK" );
        }

        scmobile.contacts.silentSelect( null, onSuccess, onError );
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};

function testRemoveContacts( contacts )
{
    var contact_count_ = contacts.length;
    var index_ = 0;
    var onSuccessGl_;
    var onErrorGl_;

    
    scmobile.console.log( '[BEGIN] testRemoveContacts: ' + contact_count_ );
    var onSuccess = function( contacts )
    {
        //alert( '>> remove contact onSuccess called. Contacts count : ' + contact_count_ + 'Index : ' + index_ );

        
        contact_count_ = contact_count_ - 1;
        index_ = index_ + 1;

        //alert( '>> Updating indices : ' + contact_count_ + 'Index : ' + index_ );

        
        if ( contact_count_ == 0 )
        {
            //alert( '>> >> testNoContacts +' );
             testNoContacts();
            //alert( '>> >> testNoContacts -' );
        }
        else
        {
            //alert( '>> >> remove again' );
            try
            {
               contacts[index_].remove( onSuccessGl_, onErrorGl_ );
            }
            catch ( error_ )
            {
                //alert( '>> >> remove again error: ' + error_ );
            }
            //alert( '>> >> remove again done' );
        }
    }
    var onError = function( error )
    {
        scmobile.console.log( 'remove contact error' );
        resultCallback( "REMOVE_CONTACT_ERROR" );
    }
    

    scmobile.console.log( 'try to remove contact' );
    onSuccessGl_ = onSuccess;
    onErrorGl_   = onError;

    contacts[index_].remove( onSuccessGl_, onErrorGl_ );
    scmobile.console.log( '[END] testRemoveContacts: ' + contact_count_ );
};

function testFindAllAndRemoveContacts()
{
    try
    {
        function onDeviceReady()
        {
            scmobile.console.log( 'onDeviceReady 1' );
            var onSuccess = function( contacts )
            {
                if ( contacts.length > 0 )
                {
                    scmobile.console.log( '[CALL] testRemoveContacts' );
                    testRemoveContacts( contacts );
                }
                else
                {
                    resultCallback( "OK" );
                }
            }
            var onError = function( error )
            {
                resultCallback( "FAIL_FIND_ERROR_CALLBACK" );
            }

            scmobile.console.log( '[CALL] silentSelect' );
            scmobile.contacts.silentSelect( null, onSuccess, onError );
            scmobile.console.log( '[END] testFindAllAndRemoveContacts' );
        }

        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
        return 'testFindAllAndRemoveContacts - JS';
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};


function testCreateContactWithPhonesAndEmails( phone1, phone2, email1, email2 )
{
   try
   {
      function onDeviceReady()
      {
         var contact = scmobile.contacts.create();
         contact.emails = [ email1, email2 ];
         contact.phones = [ phone1, phone2 ];

         var onSuccess = function()
         { 
            scmobile.console.log('Contact phone: ' + contact.phones[0]);
            scmobile.console.log('Contact phones count: ' + contact.phones.length);
            scmobile.console.log('Contact email: ' + contact.emails[0]);
            scmobile.console.log('Contact emails count: ' + contact.emails.length);
            if ( contact.emails[0] == email1 
                && contact.phones[0] == phone1 
                && contact.emails[1] == email2 
                && contact.phones[1] == phone2 
                && contact.emails.length == 2 
                && contact.phones.length == 2
                && contact.contactInternalId > 0 )
            //if ( true )
            {
               resultCallback( "OK" );
            }
            else 
            {
               resultCallback( "FAIL_INVALID_NAME" );
            }
         }
         var onError = function( error )
         {
            resultCallback( "CREATE_ERROR_CALLBACK" );
         }
         
         contact.silentSave( onSuccess, onError );
      }
      
      // Wait for Device2Web to load
      document.addEventListener('scmobileReady', onDeviceReady, false);
   }
   catch( exception )
   {
      resultCallback( "EXCEPTION" );
   }
};

function testFindContactWithPhonesAndEmails( phone1, phone2, email1, email2 )
{
    try
    {
        function onDeviceReady()
        {
            var onSuccess = function( contacts )
            {
                if ( contacts && contacts.length == 1 )
                {
                    var contact = contacts[0];
                    if ( contact.emails[0] == email1
                        && contact.phones[0] == phone1
                        && contact.emails[1] == email2
                        && contact.phones[1] == phone2
                        && contact.emails.length == 2 
                        && contact.phones.length == 2
                        && contact.contactInternalId > 0 )
                    {
                        scmobile.console.log( 'Contact with two phones and emails was found' );
                        resultCallback( "OK" );
                    }
                    else
                    {
                        resultCallback( "FAIL_INVALID_NAME" );
                    }
                }
                else
                {
                    resultCallback( "FAIL_ACCOUNTS_COUNT_" + contacts.length );
                }
            }
            var onError = function( error )
            {
                resultCallback( "FAIL_FIND_ERROR_CALLBACK" );
            }

            var predicate = function( contact ){ return ( contact.emails[0] == email1 && contact.phones[0] == phone1 ) };
            scmobile.contacts.silentSelect( predicate, onSuccess, onError );
        }

        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};


function testFindContactWithCompany( companyName )
{
    try
    {
        function onDeviceReady()
        {
            var onSuccess = function( contacts )
            {
                if ( contacts && contacts.length == 1 )
                {
                    var contact = contacts[0];
                    if ( contact.company == companyName && contact.contactInternalId > 0 )
                    {
                        resultCallback( "OK" );
                    }
                    else
                    {
                        resultCallback( "FAIL_INVALID_NAME" );
                    }
                }
                else
                {
                    resultCallback( "FAIL_ACCOUNTS_COUNT_" + contacts.length );
                }
            }
            var onError = function( error )
            {
                resultCallback( "FAIL_FIND_ERROR_CALLBACK" );
            }
            
            var predicate = function( contact ){ return ( contact.company == companyName ) };
            scmobile.contacts.silentSelect( predicate, onSuccess, onError );
        }
        
        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};

function testCreateContactWithCompany( contactCompany )
{
    try
    {
        function onDeviceReady()
        {
            var contact = scmobile.contacts.create( { company: contactCompany } );
            
            var onSuccess = function()
            {
                if ( contact.company == contactCompany && contact.contactInternalId > 0 )
                {
                    resultCallback( "OK" );
                }
                else
                {
                    resultCallback( "FAIL_INVALID_NAME" );
                }
            }
            var onError = function( error )
            {
                resultCallback( "CREATE_ERROR_CALLBACK" );
            }
            
            contact.silentSave( onSuccess, onError );
        }
        
        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};

function testFindContactWithBirthday( birthday )
{
    try
    {
        var bithday_to_find = new Date(birthday);
        function onDeviceReady()
        {
            var onSuccess = function( contacts )
            {
                if ( contacts && contacts.length == 1 )
                {
                    var contact = contacts[0];
                    if ( contact.birthday.toLocaleTimeString() == bithday_to_find.toLocaleTimeString() && contact.contactInternalId > 0 )
                    {
                        resultCallback( "OK" );
                    }
                    else
                    {
                        resultCallback( "FAIL_INVALID_NAME" );
                    }
                }
                else
                {
                    resultCallback( "FAIL_BIRTHDAY_ACCOUNTS_COUNT_" + encodeURIComponent( JSON.stringify(contacts) ) );
                    //resultCallback( "FAIL_BIRTHDAY_ACCOUNTS_COUNT_" + contacts.length );
                }
            }
            var onError = function( error )
            {
                resultCallback( "FAIL_FIND_ERROR_CALLBACK" );
            }
            
            var predicate = function( contact ){ return ( contact.birthday.toLocaleTimeString() == bithday_to_find.toLocaleTimeString() ) };
            scmobile.contacts.silentSelect( predicate, onSuccess, onError );
        }
        
        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};



function testCreateContactWithBirthday( birthday )
{
    //alert('testCreateContactWithBirthday');
    
    try
    {
        function onDeviceReady()
        {
            var bithday_to_create = new Date(birthday);
            var contact = scmobile.contacts.create( { birthday: bithday_to_create } );
            scmobile.console.log('Contact birthday inFunction: ' + contact.birthday);
            var onSuccess = function()
            {
                scmobile.console.log('Contact birthday onSuccess: ' + contact.birthday);
                if ( contact.birthday.toLocaleTimeString() == bithday_to_create.toLocaleTimeString() && contact.contactInternalId > 0 )
                {
                    scmobile.console.log('Contact birthday Checked: ' + contact.birthday);
                    resultCallback( "OK" );
                }
                else
                {
                    resultCallback( "FAIL_INVALID_NAME" );
                }
            }
            var onError = function( error )
            {
                resultCallback( "CREATE_ERROR_CALLBACK" );
            }
            
            contact.silentSave( onSuccess, onError );
        }
        
        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};

function testCreateContactWithPhoto( photo_url )
{
    try
    {
        function onDeviceReady()
        {
            var contact = scmobile.contacts.create( /*{ photo = image_create }*/ );
            contact.photo = photo_url;
            scmobile.console.log('Contact photo inFunction: ' + contact.photo );
            var onSuccess = function()
            {
                scmobile.console.log('Contact photo onSuccess');
                if ( contact.photo != null && contact.contactInternalId > 0 )
                {
                    scmobile.console.log('Contact photo Checked');
                    resultCallback( "OK" );
                }
                else
                {
                    resultCallback( "FAIL_INVALID_NAME" );
                }
            }
            var onError = function( error )
            {
                resultCallback( "CREATE_ERROR_CALLBACK" );
            }
            
            contact.silentSave( onSuccess, onError );
        }
        
        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};


function testCreateContactWithSites( site1, site2 )
{
    try
    {
        function onDeviceReady()
        {
            var contact = scmobile.contacts.create();
            contact.websites = [ site1, site2 ];
            
            var onSuccess = function()
            { 
                scmobile.console.log('Contact site: ' + contact.websites[0]);
                scmobile.console.log('Contact sites count: ' + contact.websites.length);
                if ( contact.websites[0] == site1 
                    && contact.websites[1] == site2 
                    && contact.websites.length == 2 
                    && contact.contactInternalId > 0 )
                {
                    resultCallback( "OK" );
                }
                else 
                {
                    resultCallback( "FAIL_INVALID_NAME" );
                }
            }
            var onError = function( error )
            {
                resultCallback( "CREATE_ERROR_CALLBACK" );
            }
            
            contact.silentSave( onSuccess, onError );
        }
        
        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};

function testFindContactWithSites( site1, site2 )
{
    try
    {
        function onDeviceReady()
        {
            var onSuccess = function( contacts )
            {
                if ( contacts && contacts.length == 1 )
                {
                    var contact = contacts[0];
                    if ( contact.websites[0] == site1
                        && contact.websites[1] == site2
                        && contact.websites.length == 2 
                        && contact.contactInternalId > 0 )
                    { 
                        scmobile.console.log( 'Contact with two sites was found' );
                        resultCallback( "OK" );
                    }
                    else
                    {
                        resultCallback( "FAIL_INVALID_NAME" );
                    }
                }
                else
                {
                    resultCallback( "FAIL_ACCOUNTS_COUNT_" + contacts.length );
                }
            }
            var onError = function( error )
            {
                resultCallback( "FAIL_FIND_ERROR_CALLBACK" );
            }
            
            var predicate = function( contact ){ return ( contact.websites[0] == site1 ) };
            scmobile.contacts.silentSelect( predicate, onSuccess, onError );
        }
        
        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};

function testCreateContactWithAddresses( street1, city1, state1, zip1, country1, street2, city2, state2, zip2, country2 )
{
    try
    {
        function onDeviceReady()
        {
            var contact = scmobile.contacts.create();
            var address1 = {};
            address1.street = street1;
            address1.city = city1;
            address1.state = state1;
            address1.zip = zip1;
            address1.country = country1;
            var address2 = {};
            address2.street = street2;
            address2.city = city2;
            address2.state = state2;
            address2.zip = zip2;
            address2.country = country2;

            contact.addresses = [ address1, address2 ];
            
            var onSuccess = function()
            { 
                scmobile.console.log('Contact address: ' + contact.addresses[0]);
                scmobile.console.log('Contact addresses count: ' + contact.addresses.length);
                if ( contact.addresses[0] == address1 
                    //&& contact.addresses[1] == address2 
                    //&& contact.addresses.length == 2 
                    && contact.contactInternalId > 0 )
                {
                    scmobile.console.log('Contact address successful created: ');
                    resultCallback( "OK" );
                }
                else 
                {
                    resultCallback( "FAIL_INVALID_NAME" );
                }
            }
            var onError = function( error )
            {
                resultCallback( "CREATE_ERROR_CALLBACK" );
            }
            
            contact.silentSave( onSuccess, onError );
        }
        
        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};

function testFindContactWithAddresses( street1, city1, state1, zip1, country1 )
{
    try
    {
        function onDeviceReady()
        {
            var onSuccess = function( contacts )
            {
                if ( contacts && contacts.length == 1 )
                {
                    var contact = contacts[0];
                    if ( contact.addresses[0].street == street1
                        && contact.addresses[0].city == city1
                        && contact.addresses[0].country == country1
                        && contact.addresses[0].state == state1
                        && contact.addresses[0].zip == zip1
                        && contact.addresses.length == 2 
                        && contact.contactInternalId > 0 )
                    {
                        scmobile.console.log( 'Contact with two addresses was found' );
                        resultCallback( "OK" );
                    }
                    else
                    {
                        resultCallback( "FAIL_INVALID_NAME" );
                    }
                }
                else
                {
                    resultCallback( "FAIL_ACCOUNTS_COUNT_" + contacts.length );
                }
            }
            var onError = function( error )
            {
                resultCallback( "FAIL_FIND_ERROR_CALLBACK" );
            }
            
            var predicate = function( contact ){ return ( contact.addresses[0].street == street1 
                                                         && contact.addresses[0].city == city1
                                                         && contact.addresses[0].country == country1
                                                         && contact.addresses[0].state == state1
                                                         && contact.addresses[0].zip == zip1) };
            scmobile.contacts.silentSelect( predicate, onSuccess, onError );
        }
        
        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};
///----

function findContactForCheckAllFields( contactName
                                      , contactLName
                                      , contactCompany
                                      , contactPhone
                                      , contactEmail
                                      , contactSite )
{
    scmobile.console.log( 'params: fname/lname to find: ' +  contactName + '/' + contactLName);
    var onSuccess = function( contacts )
    {
        scmobile.console.log( 'find count:  ' +  contacts.length);

        if ( contacts && contacts.length == 1 )
        {
            var contact = contacts[0];
            scmobile.console.log( 'find: fname/lname: ' +  contact.firstName + '/' + contact.lastName);
    
            if ( contact.firstName == contactName
                && contact.lastName == contactLName
                && contact.company == contactCompany 
                && contact.phones.length >= 1
                && contact.emails.length >= 1
                && contact.websites.length >= 1
                && contact.phones[0] == contactPhone
                && contact.emails[0] == contactEmail
                && contact.websites[0] == contactSite
                && contact.contactInternalId > 0
                )
            {
                resultCallback( "OK" );
            }
            else
            {
                resultCallback( "FAIL_INVALID_NAME" );
            }
        }
        else
        {
            resultCallback( "FAIL_CONTACTS_COUNT_" + contacts.length );
        }
    }
    var onError = function( error )
    {
        resultCallback( "FAIL_FIND_ERROR_CALLBACK" );
    }

   var predicate = function( contact ){ return ( contact.firstName == contactName 
                                                && contact.lastName == contactLName 
                                                && contact.company == contactCompany
                                                && contact.phones[0] == contactPhone
                                                && contact.emails[0] == contactEmail
                                                && contact.websites[0] == contactSite) };
    scmobile.contacts.silentSelect( predicate, onSuccess, onError );
};

//create contact with all info
function testCreateContactWithAllFields( contactName, contactLName, companyName, phone, email, site )
{
    try
    {
        function onDeviceReady()
        {
            var contact = scmobile.contacts.create( { firstName: contactName, lastName: contactLName, company: companyName } );
            contact.emails = [ email ];
            contact.phones = [ phone ];
            contact.websites = [ site ];

            var onSuccess = function()
            {
                if ( contact.firstName     == contactName 
                    && contact.lastName    == contactLName 
                    && contact.company     == companyName
                    && contact.emails[0]   == email 
                    && contact.phones[0]   == phone 
                    && contact.websites[0] == site 
                    && contact.emails.length == 1 
                    && contact.phones.length == 1
                    && contact.contactInternalId > 0 )
                {
                    resultCallback( "OK" );
                }
                else
                {
                    resultCallback( "FAIL_INVALID_NAME" );
                }
            }
            var onError = function( error )
            {
                resultCallback( "CREATE_ERROR_CALLBACK" );
            }

            contact.silentSave( onSuccess, onError );
        }
        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};

//edit all info
function testEditContactWithAllFields( contactName
                                      , newName
                                      , newLName
                                      , newCompany
                                      , newPhone
                                      , newEmail
                                      , newSite )
{
    try
    {
        function onDeviceReady()
        {
            var onSuccess = function( contacts )
            {
                if ( contacts && contacts.length == 1 )
                {
                    var contact = contacts[0];
                    if ( contact.firstName == contactName
                        && contact.phones.length >= 1
                        && contact.emails.length >= 1
                        && contact.websites.length >= 1
                        && contact.contactInternalId > 0 )
                    {
                        contact.firstName   = newName;
                        contact.lastName    = newLName;
                        contact.company     = newCompany;
                        contact.phones[0]   = newPhone;
                        contact.emails[0]   = newEmail;
                        contact.websites[0] = newSite;
                        var onSuccess = function()
                        {
                            findContactForCheckAllFields( newName, newLName, newCompany, newPhone, newEmail, newSite );
                        }
                        var onError = function()
                        {
                            resultCallback( "FAIL_ACCOUNT_NOT_SAVED");
                        }
                        contact.silentSave( onSuccess, onError );
                     }
                     else
                     {
                         resultCallback( "FAIL_INVALID_NAME" );
                     }
                }
                else
                {
                    resultCallback( "FAIL_ACCOUNTS_COUNT_" + contacts.length );
                }
            }
            var onError = function( error )
            {
                resultCallback( "FAIL_FIND_ERROR_CALLBACK" );
            }

            var predicate = function( contact ){ return ( contact.firstName == contactName ) };
            var contacts = scmobile.contacts.silentSelect( predicate, onSuccess, onError );
        }

      // Wait for Device2Web to load
      document.addEventListener('scmobileReady', onDeviceReady, false);
   }
   catch( exception )
   {
      resultCallback( "EXCEPTION" );
   }
};
