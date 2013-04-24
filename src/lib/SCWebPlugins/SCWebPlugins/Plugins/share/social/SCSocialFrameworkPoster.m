#import "SCSocialFrameworkPoster.h"
#import "SCSocialNetworkPluginError.h"


@implementation SCSocialFrameworkPoster

-(void)postImplWithCompletion:( SCAsyncOpResult )handler
{
    SLComposeViewController* controller_ = [ SLComposeViewController composeViewControllerForServiceType:  [ self appleServiceType ] ];
    __weak UIViewController* weakController_ = controller_;
    
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

    
    controller_.completionHandler = ^void( SLComposeViewControllerResult result_ )
    {
        if ( SLComposeViewControllerResultCancelled == result_ )
        {
            SCSocialNetworkPluginError* error = [ SCSocialNetworkPluginError postCancelledError ];
            handler( nil, error );
        }
        else if ( SLComposeViewControllerResultDone == result_ )
        {
            handler( [ NSNull null ], nil );
        }
        
        [ weakController_ dismissViewControllerAnimated: NO
                                              completion: nil ];
    };

    [ self.viewControllerForDialog presentTopViewController: controller_ ];
}


-(BOOL)isIosSupportsPoster
{
    return [ ESFeatureAvailabilityChecker isSocialFrameworkAvailable ];
}

-(BOOL)canPost
{
    if ( ![ self isIosSupportsPoster ] )
    {
        return NO;
    }

    NSString* appleService = [ self appleServiceType ];
    return [ SLComposeViewController isAvailableForServiceType: appleService ];
}

-(NSString*)appleServiceType
{
    NSString* appleService = [ [ self class ] appleServiceTypes ][self.serviceType];
    return appleService;
}


static NSDictionary* classMap = nil;
+(NSDictionary*)appleServiceTypes
{
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken,
    ^{
      classMap =
      @{
        @"twitter"  : SLServiceTypeTwitter  ,
        @"facebook" : SLServiceTypeFacebook ,
        @"weibo"    : SLServiceTypeSinaWeibo
        };
    });
    
    return classMap;
}


@end
