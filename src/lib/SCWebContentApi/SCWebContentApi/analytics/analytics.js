scmobile.analytics = {};
scmobile.analytics._construct = function()
{
    function _invokeNativeTrigger( webSocketRequest, onSuccess, onError )
    {
        //scmobile.console.log( '[INSIDE] _invokeNativeTrigger.' )
        var socket_ = new scmobile.utils.SCWebSocket( webSocketRequest );
        
        //
        socket_.onmessage = function( message )
        {
            //scmobile.console.log( '[INSIDE] socket_.onmessage' )
            //scmobile.console.log( 'onSuccess : ' + onSuccess )
            //scmobile.console.log( 'onError   : ' + onError   )
            
            var data = eval( '(' + message + ')' );
            
            //scmobile.console.log( 'socket_.onmessage - eval passed' )
            
            //scmobile.console.log( 'data = ' + data )
            //scmobile.console.log( 'data.error : ' + data.error )
            
            if ( data.error )
            {
                //scmobile.console.log( 'socket_.onmessage - onError()' )
                onError( data );
            }
            else
            {
                //scmobile.console.log( 'socket_.onmessage - onSuccess()' )                
                onSuccess();
            }
        }
    }
    
    function _triggerPageEventForItem( triggerPageEventInfo, onSuccess, onError )
    {
        //scmobile.console.log( '[INSIDE] triggerPageEventForItem.' )
        
        //scmobile.console.log( 'onSuccess : ' + onSuccess )
        //scmobile.console.log( 'onError   : ' + onError   )

        
        var createArgs = '';
        createArgs = createArgs + '&itemRenderingUrl=' + encodeURIComponent( triggerPageEventInfo.itemRenderingUrl );
        createArgs = createArgs + '&pageEventName=' + encodeURIComponent( triggerPageEventInfo.pageEventName );

        //scmobile.console.log( 'createArgs = ' + createArgs )
        _invokeNativeTrigger( '/scmobile/analytics/trigger_page_event?1=1' + createArgs, onSuccess, onError );
    }
    
    function _triggerCampaignForItem( triggerCampaignInfo, onSuccess, onError )
    {
        //scmobile.console.log( '[INSIDE] _triggerCampaignForItem.' )
        
        var createArgs = '';
        createArgs = createArgs + '&itemRenderingUrl=' + encodeURIComponent( triggerCampaignInfo.itemRenderingUrl );
        //scmobile.console.log( '[x] itemRenderingUrl' )
        
        createArgs = createArgs + '&campaignId=' + encodeURIComponent( triggerCampaignInfo.campaignId );
        //scmobile.console.log( '[x] campaignId' )
        
        //scmobile.console.log( 'createArgs = ' + createArgs )
        _invokeNativeTrigger( '/scmobile/analytics/trigger_campaign?1=1' + createArgs, onSuccess, onError );
    }
    
    
    this.triggerPageEventForItem = _triggerPageEventForItem;
    this.triggerCampaignForItem  = _triggerCampaignForItem ;
}
scmobile.analytics._construct()
