
function resultCallback( resultData )
{
    window.location = ( "http://" + resultData )
};

function testViewDeviceVersion()
{
    try
    {
        function onDeviceReady()
        {
            scmobile.console.log( 'device version: ' +  scmobile.device.version);
            var device_version = new String(scmobile.device.version);
            if ( device_version.length > 0 )
            {
                resultCallback( "OK" );
            }
            else
            {
                resultCallback( "CREATE_ERROR_CALLBACK" );
            }
        }
        resultCallback( "OK" );
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
}

function testViewDeviceName()
{
    try
    {
        function onDeviceReady()
        {
            //scmobile.console.log( 'device name: ' +  scmobile.device.name);
            var device_name = new String(scmobile.device.name);

            if ( device_name.length > 0 )
            {
                resultCallback( "OK" );
            }
            else
            {
                resultCallback( "FAIL_NO_DEVICE_NAME" );
            }
        }
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};

function testViewDeviceUUID()
{
    try
    {
        function onDeviceReady()
        {
            //scmobile.console.log( 'device uuid: ' +  scmobile.device.uuid);
            var device_uuid = new String(scmobile.device.uuid);
            if ( device_uuid.length > 0 )
            {
                resultCallback( "OK" );
            }
            else
            {
                resultCallback( "FAIL_NO_DEVICE_UUID" );
            }
        }
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
};
