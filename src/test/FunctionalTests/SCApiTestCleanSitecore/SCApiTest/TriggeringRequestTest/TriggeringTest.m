#import "SCAsyncTestCase.h"

@interface TriggeringTest : SCAsyncTestCase
@end

@implementation TriggeringTest

-(void)testPageEventTriggeringWithNillItemPath
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    
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
            [ [ SCPageEventTriggeringRequest alloc ] initWithPath: nil
                                                      eventName: @"Print" ];
            
            [ apiContext_ triggerOperationWithRequest:request_ ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
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
    GHAssertTrue( requestResult_ != nil, @"requestResult  shouldn't be nil" );
    
    NSRange contentRange_ = [ requestResult_ rangeOfString:@"Welcome to Sitecore" ];
    GHAssertTrue(contentRange_.location != NSNotFound, @"'Welcome to Sitecore' should be present in responce");
}

-(void)testPageEventTriggeringWithHomePath
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiAnalyticsHostName ];
                apiContext_ = strongContext_;
                
                SCPageEventTriggeringRequest *request_ =
                [ [ SCPageEventTriggeringRequest alloc ] initWithPath: SCTriggeringPath
                                                            eventName: @"Logout" ];
                
                [ apiContext_ triggerOperationWithRequest:request_ ]( ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
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
    GHAssertTrue( requestResult_ != nil, @"requestResult  shouldn't be nil" );
    
    NSRange contentRange_ = [ requestResult_ rangeOfString:@"Welcome to Sitecore" ];
    GHAssertTrue(contentRange_.location != NSNotFound, @"'Welcome to Sitecore' should be present in responce");
}

-(void)testCampaignTriggeringWithNillItemPath
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    
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
            
            SCCampaignTriggeringRequest *request_ =
            [ [ SCCampaignTriggeringRequest alloc ] initWithPath: nil
                                                      campaignId: @"7F6E2AF1A0FC4CF3A4678080BBF440AD" ];
            
            [ apiContext_ triggerOperationWithRequest:request_ ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
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
    GHAssertTrue( requestResult_ != nil, @"requestResult  shouldn't be nil" );
    
    NSRange contentRange_ = [ requestResult_ rangeOfString:@"Welcome to Sitecore" ];
    GHAssertTrue(contentRange_.location != NSNotFound, @"'Welcome to Sitecore' should be present in responce");
}

@end
