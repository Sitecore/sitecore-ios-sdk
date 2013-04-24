
function resultCallback( resultData )
{
    window.location = ( "http://" + resultData )
};

function testAccelerometer()
{
    try
    {
        function onDeviceReady()
        {
            var accelerometer = new scmobile.motion_manager.Accelerometer();

            var failOnAcceleration = false;

            accelerometer.onAcceleration = function( accelerData )
            {
                if ( failOnAcceleration )
                {
                    resultCallback( 'failOnAcceleration' );
                    return;
                }
                if ( accelerData.hasOwnProperty('x')
                    && accelerData.hasOwnProperty('y')
                    && accelerData.hasOwnProperty('z')
                    && accelerData.hasOwnProperty('timestamp') )
                {
                    failOnAcceleration = true;
                    accelerometer.stop();
                    setTimeout(function() { resultCallback( 'OK' ) }, 1000 );
                }
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
