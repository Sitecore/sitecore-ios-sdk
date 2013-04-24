#import "SCBaseSocialPoster.h"

#import "SCSocialNetworkPluginError.h"

@implementation SCBaseSocialPoster

-(void)postWithCompletion:( SCAsyncOpResult )handler
{
    NSParameterAssert( nil != self->_viewControllerForDialog );
    
    if ( ![ self isIosSupportsPoster ] )
    {
        SCSocialNetworkPluginError* error = [ SCSocialNetworkPluginError tooOldIosError ];
        handler( nil, error );
        return;
    }
    if ( ![ self canPost ] )
    {
        SCSocialNetworkPluginError* error = [ SCSocialNetworkPluginError noSocialAccountError ];
        handler( nil, error );
        return;
    }
    
    [ self postImplWithCompletion: handler ];
}

-(BOOL)isIosSupportsPoster
{
    [ self doesNotRecognizeSelector: _cmd ];
    return NO;
}

-(BOOL)canPost
{
    [ self doesNotRecognizeSelector: _cmd ];
    return NO;
}

-(void)postImplWithCompletion:( SCAsyncOpResult )handler
{
    [ self doesNotRecognizeSelector: _cmd ];
}

@end
