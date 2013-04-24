
function resultCallback( resultData )
{
    window.location = ( 'http://' + resultData )
};

function testCreateMediaItem()
{
    try
    {
        function onDeviceReady()
        {
            scmobile.console.log('test_create_media_item');

            var createItemInfo = {};
            createItemInfo.imageUrl   = 'http://mytutorblog.org/wp-content/uploads/2011/05/Prepare-for-a-test.jpg';
            createItemInfo.login      = 'admin';
            createItemInfo.password   = 'b';
            createItemInfo.database   = 'web';
            createItemInfo.path       = 'Test Data';
            createItemInfo.itemName   = 'mediaItem name';

            createItemInfo.fields     = { Alt: 'test test' };

            function onSuccess( resultItems_ )
            {
                var item_ = resultItems_[0];
                resultCallback( 'OK?itemId=' + item_.itemId );
            }

            function onError( msg )
            {
                scmobile.console.log('js create media item error: ' + msg);
                resultCallback( 'ERROR_CAN_NOT_CREATE_MEDIA_ITEM' );
            }

            scmobile.contentapi.createMediaItem( createItemInfo, onSuccess, onError );
        }

        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
    }
    catch( exception )
    {
        resultCallback( 'EXCEPTION' );
    }
}

function testCreateLargeMediaItem()
{
    try
    {
        function onDeviceReady()
        {
            //alert( 'testCreateLargeMediaItem->onDeviceReady' );
            scmobile.console.log('test_create_media_item');
            
            var createItemInfo = {};
            createItemInfo.imageUrl   = 'http://newevolutiondesigns.com/images/freebies/flowers-wallpaper-2.jpg';
            createItemInfo.login      = 'admin';
            createItemInfo.password   = 'b';
            createItemInfo.database   = 'core';
            createItemInfo.path       = 'Test Data';
            createItemInfo.itemName   = 'largeMediaItem name';
            
            createItemInfo.fields     = { Alt: ' _!', Title: 'Title' };
            
            function onSuccess( resultItems_ )
            {
                var item_ = resultItems_[0];
                resultCallback( 'OK?itemId=' + item_.itemId );
            }
            
            function onError( msg )
            {
                scmobile.console.log('js create media item error: ' + msg);
                resultCallback( 'ERROR_CAN_NOT_CREATE_MEDIA_ITEM' );
            }
            
            scmobile.contentapi.createMediaItem( createItemInfo, onSuccess, onError );
        }
        
        // Wait for Device2Web to load
        document.addEventListener('scmobileReady', onDeviceReady, false);
        
        return 'testCreateLargeMediaItem - JS';
    }
    catch( exception )
    {
        resultCallback( 'EXCEPTION' );
    }
}