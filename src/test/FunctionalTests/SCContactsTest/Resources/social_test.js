function resultCallback( resultData )
{
    window.location = ( 'http://' + resultData )
};

function testTwitter()
{
    try
    {
        function onDeviceReady()
        {
            scmobile.console.log( '[BEGIN] testTwitter... ' );
            
            function onSuccess()
            {
                scmobile.console.log( '[onSuccess] testTwitter.' )
                resultCallback( "OK" );
            }
            function onError( error )
            {
                scmobile.console.log( '[onError] testTwitter.' )
                resultCallback( error.error );
            }


            try
            {
                scmobile.console.log( 'Creating twitter instance...' );
                var twitter = new scmobile.share.Tweet();
                twitter.text = 'Mobile SDK test tweet';
                scmobile.console.log( 'Done.' );
                
                scmobile.console.log( 'Sending a tweet...' );
                twitter.send( onSuccess, onError );
                scmobile.console.log( 'Done.' );
            }
            catch (twitterException)
            {
                scmobile.console.log( 'twitterException   : ' );
                scmobile.console.log( 'twitterException   : ' + twitterException );
            }
        }
        document.addEventListener('scmobileReady', onDeviceReady, false);
        return 'testTwitter - JS';
    }
    catch( exception )
    {
        // scmobile.console.log( '[EXCEPTION] testTwitter.' )
        resultCallback( "EXCEPTION" );
    }
}


function testFacebook()
{
    try
    {
        function onDeviceReady()
        {
            scmobile.console.log( '[BEGIN] testFacebook... ' );
            
            function onSuccess()
            {
                scmobile.console.log( '[onSuccess] testFacebook.' )
                resultCallback( "OK" );
            }
            function onError( error )
            {
                scmobile.console.log( '[onError] testFacebook.' )
                resultCallback( error.error );
            }
            
            
            try
            {
                scmobile.console.log( 'Creating twitter instance...' );
                var twitter = new scmobile.share.Facebook();
                twitter.text = 'Mobile SDK test post';
                scmobile.console.log( 'Done.' );
                
                scmobile.console.log( 'Sending an fb post...' );
                twitter.send( onSuccess, onError );
                scmobile.console.log( 'Done.' );
            }
            catch (twitterException)
            {
                scmobile.console.log( 'testFacebook   : ' );
                scmobile.console.log( 'testFacebook   : ' + twitterException );
            }
        }
        document.addEventListener('scmobileReady', onDeviceReady, false);
        return 'testFacebook - JS';
    }
    catch( exception )
    {
        // scmobile.console.log( '[EXCEPTION] testTwitter.' )
        resultCallback( "EXCEPTION" );
    }
}

function testSocial()
{
    try
    {
        function onDeviceReady()
        {
            scmobile.console.log( '[BEGIN] testSocial... ' );
            
            function onSuccess()
            {
                scmobile.console.log( '[onSuccess] testSocial.' )
                resultCallback( "OK" );
            }
            function onError( error )
            {
                scmobile.console.log( '[onError] testSocial.' )
                resultCallback( error.error );
            }
            
            
            try
            {
                scmobile.console.log( 'Creating social instance...' );
                var social_ = new scmobile.share.Social();
                social_.text = 'Mobile SDK test post';
                social_.engineName = 'Twitter';
                scmobile.console.log( 'Done.' );
                
                scmobile.console.log( 'Sending post...' );
                social_.send( onSuccess, onError );
                scmobile.console.log( 'Done.' );
            }
            catch (socialException)
            {
                scmobile.console.log( 'testSocial   : ' );
                scmobile.console.log( 'testSocial   : ' + socialException );
            }
        }
        document.addEventListener('scmobileReady', onDeviceReady, false);
        return 'testSocial - JS';
    }
    catch( exception )
    {
        // scmobile.console.log( '[EXCEPTION] testSocial.' )
        resultCallback( "EXCEPTION" );
    }
}

