
function resultCallback( resultData )
{
    window.location = ( 'http://' + resultData )
};

function testShowAlertAndSelectFirstButton()
{
   try
   {
      function onDeviceReady()
      {
         var index_ = 0;

         var alertCallback = function( buttonIndex ) {
            if ( index_ == buttonIndex )
               resultCallback( 'OK' );
            else
               resultCallback( 'INVALID_INDEX_' + buttonIndex );
         }

         var alert_ = scmobile.notification.alert( 'Warning', 'test message'
                                                    , alertCallback
                                                    , 'One,Two,Three' );

         alert_.onPresent = function() {
            new scmobile.utils.SCWebSocket( '/sitecore/close_alert?bt=' + index_ );
         }
      }

      // Wait for Device2Web to load
      document.addEventListener('scmobileReady', onDeviceReady, false);
   }
   catch( exception )
   {
      resultCallback( 'EXCEPTION' );
   }
};

function testShowAlertAndSelectLastButton()
{
    try
    {
        function onDeviceReady()
        {
            var index_ = 2;

            var alertCallback = function( buttonIndex ) {
                if ( index_ == buttonIndex )
                    resultCallback( 'OK' );
                else
                    resultCallback( 'INVALID_INDEX_' + buttonIndex );
            }

            var alert_ = scmobile.notification.alert( 'Warning', 'test message'
                                                     , alertCallback
                                                     , 'One,Two,Three' );

            alert_.onPresent = function() {
                new scmobile.utils.SCWebSocket( '/sitecore/close_alert?bt=' + index_ );
            }
        }
      
        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( 'EXCEPTION' );
    }
};