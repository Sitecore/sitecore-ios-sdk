function resultCallback( resultData )
{
    window.location = ( 'http://' + resultData )
};

function testTriggerHomeGoal()
{
    try
    {
        function onDeviceReady()
        {
            function onSuccess()
            {
                scmobile.console.log( '[onSuccess] triggerGoalForItem.' )
                resultCallback( "OK" );
            }
            function onError( error )
            {
                scmobile.console.log( '[onError] triggerGoalForItem.' )                
                resultCallback( error.error );
            }
            
            triggerInfo =
            {
                itemRenderingUrl : 'http://mobiledev1ua1.dk.sitecore.net:9999/',
                pageEventName    : 'Page Visited'
            }
            
            
            scmobile.console.log( '[BEGIN] triggerGoalForItem... ' )
            scmobile.console.log( 'onSuccess : ' + onSuccess )
            scmobile.console.log( 'onError   : ' + onError   )
            
            scmobile.analytics.triggerPageEventForItem( triggerInfo, onSuccess, onError )
        }
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
}


function testTriggerHomeCampaign()
{
    try
    {
        function onDeviceReady()
        {
            function onSuccess()
            {
                scmobile.console.log( '[onSuccess] testTriggerHomeCampaign.' )
                resultCallback( "OK" );
            }
            function onError( error )
            {
                scmobile.console.log( '[onError] testTriggerHomeCampaign.' )
                resultCallback( error.error );
            }
            
            triggerInfo =
            {
                itemRenderingUrl : 'http://mobiledev1ua1.dk.sitecore.net:9999/',
                campaignId       : '94FD1606-139E-46EE-86FF-BC5BF3C79804'
            }
            
            
            scmobile.console.log( '[BEGIN] testTriggerHomeCampaign... ' )
            scmobile.console.log( 'onSuccess : ' + onSuccess )
            scmobile.console.log( 'onError   : ' + onError   )
            
            scmobile.analytics.triggerCampaignForItem( triggerInfo, onSuccess, onError )
        }
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( "EXCEPTION" );
    }
}

