#import "SCTwitterPoster.h"
#import "SCSocialNetworkPluginError.h"

@implementation SCTwitterPoster

-(void)postImplWithCompletion:( SCAsyncOpResult )handler
{

    TWTweetComposeViewController* controller_ = [ TWTweetComposeViewController new ];
    __weak UIViewController* weak_controller_ = controller_;
    
    [ controller_ setInitialText: self.text ];
    
    NSArray* images_ = self.images;
    for ( UIImage* image_ in images_ )
    {
        NSParameterAssert( [ image_ isKindOfClass: [ UIImage class ] ] );
        [ controller_ addImage: image_ ];
    }
    
    
    NSArray* links_ = self.links;
    for ( NSURL* link_ in links_ )
    {
        NSParameterAssert( [ link_ isKindOfClass: [ NSURL class ] ] );
        [ controller_ addURL: link_ ];
    }

    controller_.completionHandler = ^void( TWTweetComposeViewControllerResult result_ )
    {
        if ( TWTweetComposeViewControllerResultCancelled == result_ )
        {
            SCSocialNetworkPluginError* error = [ SCSocialNetworkPluginError postCancelledError ];
            handler( nil, error );
        }
        else if ( TWTweetComposeViewControllerResultDone == result_ )
        {
            handler( [ NSNull null ], nil );
        }
        
        [ weak_controller_ dismissViewControllerAnimated: NO
                                              completion: nil ];
    };
    
    [ self.viewControllerForDialog presentTopViewController: controller_ ];
    
}

-(BOOL)canPost
{
    return [ TWTweetComposeViewController canSendTweet ];
}

-(BOOL)isIosSupportsPoster
{
    // because deployment target is iOS 5.0
    return YES;
}

-(NSString*)serviceType
{
    return @"twitter";
}

@end
