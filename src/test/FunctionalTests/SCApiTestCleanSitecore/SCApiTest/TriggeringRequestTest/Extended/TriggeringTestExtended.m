#import "SCAsyncTestCase.h"

@interface TriggeringTestExtended : SCAsyncTestCase
@end

@implementation TriggeringTestExtended

-(void)testPageEventTriggeringWithNillItemPath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiAnalyticsHostName
                                                                     login: nil
                                                                  password: nil
                                                                   version: SCWebApiV1 ];
            apiContext_ = strongContext_;
            
            SCPageEventTriggeringRequest *request_ =
            [ [ SCPageEventTriggeringRequest alloc ] initWithPath: nil
                                                      eventName: @"Print" ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                requestResult_ = result_;
                
                didFinishCallback_();
            } ;
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext triggerLoaderForRequest:request_ ];
            
            loader (nil, nil, doneHandler);
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
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiAnalyticsHostName ];
                apiContext_ = strongContext_;
                
                SCPageEventTriggeringRequest *request_ =
                [ [ SCPageEventTriggeringRequest alloc ] initWithPath: SCTriggeringPath
                                                            eventName: @"Logout" ];
                
                SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    requestResult_ = result_;
                    
                    didFinishCallback_();
                } ;

                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext triggerLoaderForRequest:request_ ];
                loader (nil, nil, doneHandler);
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
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiAnalyticsHostName
                                                             login: nil
                                                          password: nil
                                                           version: SCWebApiV1 ];
            apiContext_ = strongContext_;
            
            SCCampaignTriggeringRequest *request_ =
            [ [ SCCampaignTriggeringRequest alloc ] initWithPath: nil
                                                      campaignId: @"7F6E2AF1A0FC4CF3A4678080BBF440AD" ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                requestResult_ = result_;
                
                didFinishCallback_();
            } ;
            
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext triggerLoaderForRequest:request_ ];
            loader (nil, nil, doneHandler);
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
