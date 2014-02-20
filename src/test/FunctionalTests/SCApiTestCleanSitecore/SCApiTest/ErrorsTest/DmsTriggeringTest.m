
#import "SCAsyncTestCase.h"

@interface DmsTriggeringTest : SCAsyncTestCase
@end

@implementation DmsTriggeringTest

-(void)testPageEventTriggeringWithNotExistedEvent
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    __block NSError *requestError_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiAnalyticsHostName
                                                                 login: nil
                                                              password: nil
                                                               version: SCWebApiV1 ];
                apiContext_ = strongContext_;
                
                SCPageEventTriggeringRequest *request_ =
                [ [ SCPageEventTriggeringRequest alloc ] initWithPath: SCHomePath
                                                            eventName: @"Not existed event" ];
                
                [ apiContext_ triggerOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        requestError_ = error_;
                        didFinishCallback_();
                        return;
                    }
                    requestResult_ = result_;

                    didFinishCallback_();
                } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    //NSLog( @"result: %@", requestResult_ );
    //NSLog( @"error: %@", requestError_ );
    GHAssertTrue( requestError_ == nil, @"requestError  should be nil" );
    GHAssertTrue( requestResult_ != nil, @"requestResult shouldn't be nil" );
    NSRange contentRange_ = [ requestResult_ rangeOfString:@"Welcome to Sitecore" ];
    GHAssertTrue(contentRange_.location != NSNotFound, @"'Welcome to Sitecore' should be present in responce");
}

-(void)testCampaignTriggeringWithInvalidCampaignID
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    __block NSError *requestError_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiAnalyticsHostName ];
                apiContext_ = strongContext_;
                
                SCCampaignTriggeringRequest *request_ =
                [ [ SCCampaignTriggeringRequest alloc ] initWithPath: nil
                                                          campaignId: @"7F6000F1A0000CF3A46__78080000440AD" ];
                
                [ apiContext_ triggerOperationWithRequest:request_ ]( ^( id result_, NSError* error_ )
                                                                 {
                                                                     if ( error_ )
                                                                     {
                                                                         requestError_ = error_;
                                                                         didFinishCallback_();
                                                                         return;
                                                                     }
                                                                     requestResult_ = result_;
                                                                     
                                                                     didFinishCallback_();
                                                                 } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    //NSLog( @"result: %@", requestResult_ );
    //NSLog( @"error: %@", requestError_ );
    GHAssertTrue( requestError_ == nil, @"requestError  should be nil" );
    GHAssertTrue( requestResult_ != nil, @"requestResult shouldn't be nil" );
    NSRange contentRange_ = [ requestResult_ rangeOfString:@"Welcome to Sitecore" ];
    GHAssertTrue(contentRange_.location != NSNotFound, @"'Welcome to Sitecore' should be present in responce");
}

-(void)testCampaignTriggeringWithNilItem
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    __block NSError *requestError_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiAnalyticsHostName ];
                apiContext_ = strongContext_;
                
                SCCampaignTriggeringRequest *request_ =
                [ [ SCCampaignTriggeringRequest alloc ] initWithItem: nil
                                                          campaignId: @"ID" ];
                
                [ apiContext_ triggerOperationWithRequest:request_ ]( ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        requestError_ = error_;
                        didFinishCallback_();
                        return;
                    }
                    requestResult_ = result_;

                    didFinishCallback_();
                } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    //NSLog( @"result: %@", requestResult_ );
    //NSLog( @"error: %@", requestError_ );
    GHAssertTrue( requestError_ == nil, @"requestError  should be nil" );
    GHAssertTrue( requestResult_ != nil, @"requestResult shouldn't be nil" );
    NSRange contentRange_ = [ requestResult_ rangeOfString:@"Welcome to Sitecore" ];
    GHAssertTrue(contentRange_.location != NSNotFound, @"'Welcome to Sitecore' should be present in responce");
}

-(void)testPageEventTriggeringWithNotExistedItemPath
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    __block NSError *requestError_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiAnalyticsHostName
                                                                 login: nil
                                                              password: nil
                                                               version: SCWebApiV1 ];
                apiContext_ = strongContext_;
                
                SCPageEventTriggeringRequest *request_ =
                [ [ SCPageEventTriggeringRequest alloc ] initWithPath: @"sitecore/content/not_existed_item"
                                                            eventName: @"Logout" ];
                
                [ apiContext_ triggerOperationWithRequest: request_ ]( ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        requestError_ = error_;
                        didFinishCallback_();
                        return;
                    }
                    requestResult_ = result_;

                    didFinishCallback_();
                } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    NSLog( @"result: %@", requestResult_ );
    NSLog( @"error: %@", requestError_ );
    GHAssertTrue( requestError_ != nil, @"requestError  shouldn't be nil" );
    GHAssertTrue( requestResult_ == nil, @"requestResult should be nil" );
    GHAssertTrue( [ requestError_ isKindOfClass: [ SCTriggeringError class ] ], @"Error should be of SCTriggeringError class" );
}


@end
