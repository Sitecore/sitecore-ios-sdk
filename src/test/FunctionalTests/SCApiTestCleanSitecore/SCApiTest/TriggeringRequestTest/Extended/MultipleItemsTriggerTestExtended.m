#import <SitecoreMobileSDK/SCUtils.h>


@interface MultipleItemsTriggerTestExtended : SCAsyncTestCase
@end


@implementation MultipleItemsTriggerTestExtended

-(SCPageEventTriggeringRequest*)homeLogout
{
    SCPageEventTriggeringRequest *request_ =
    [ [ SCPageEventTriggeringRequest alloc ] initWithPath: SCTriggeringPath
                                                eventName: @"Logout" ];
    
    return request_;
}

-(SCPageEventTriggeringRequest*)kodLogout:( NSInteger )itemNameIndex
{
    NSString* itemPath = [ NSString stringWithFormat: @"/sitecore/content/Triggering Events/Copy%ld", (long)itemNameIndex ];
    
    SCPageEventTriggeringRequest *request_ =
    [ [ SCPageEventTriggeringRequest alloc ] initWithPath: itemPath
                                                eventName: @"Logout" ];
    
    return request_;
}

-(SCExtendedAsyncOp)asyncTrigger12WithContext:( SCApiSession* )apiContext_
{
    SCPageEventTriggeringRequest* first  = [ self kodLogout: 1 ];
    SCPageEventTriggeringRequest* second = [ self kodLogout: 2 ];

    SCExtendedAsyncOp triggerFirst  = [ apiContext_.extendedApiSession triggerOperationWithRequest: first ];
    SCExtendedAsyncOp triggerSecond = [ apiContext_.extendedApiSession triggerOperationWithRequest: second ];

    NSArray* sequence = @[ triggerFirst, triggerSecond ];
    SCExtendedAsyncOp trigger = [ SCExtendedAsyncOpRelationsBuilder sequence: sequence ];

    return trigger;
}

-(SCExtendedAsyncOp)asyncTrigger34WithContext:( SCApiSession* )apiContext_
{
    SCPageEventTriggeringRequest* first  = [ self kodLogout: 3 ];
    SCPageEventTriggeringRequest* second = [ self kodLogout: 4 ];
    
    SCExtendedAsyncOp triggerFirst  = [ apiContext_.extendedApiSession triggerOperationWithRequest: first ];
    SCExtendedAsyncOp triggerSecond = [ apiContext_.extendedApiSession triggerOperationWithRequest: second ];
    
    NSArray* sequence = @[ triggerFirst, triggerSecond ];
    SCExtendedAsyncOp trigger = [ SCExtendedAsyncOpRelationsBuilder sequence: sequence ];
    
    return trigger;
}

-(SCExtendedAsyncOp)asyncTriggerAllWithContext:( SCApiSession* )apiContext_
{
    SCExtendedAsyncOp triggerFirst  = [ self asyncTrigger12WithContext: apiContext_ ];
    SCExtendedAsyncOp triggerSecond = [ self asyncTrigger34WithContext: apiContext_ ];
    
    NSArray* sequence = @[ triggerFirst, triggerSecond ];
    SCExtendedAsyncOp trigger = [ SCExtendedAsyncOpRelationsBuilder sequence: sequence ];
    
    return trigger;
}

-(void)testTrigger12
{
    __weak MultipleItemsTriggerTestExtended* weakSelf = self;
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
                
                SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    requestResult_ = result_;
                    
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ weakSelf asyncTrigger12WithContext: apiContext_ ];
                loader( nil, nil, doneHandler );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
//    GHAssertTrue( requestResult_ != nil, @"requestResult  shouldn't be nil" );
}

-(void)testTrigger34
{
    __weak MultipleItemsTriggerTestExtended* weakSelf = self;
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
                
                SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    requestResult_ = result_;
                    
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ weakSelf asyncTrigger34WithContext: apiContext_ ];
               
                loader (nil, nil, doneHandler);
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
//    GHAssertTrue( requestResult_ != nil, @"requestResult  shouldn't be nil" );
}

-(void)testTrigger1234
{
    __weak MultipleItemsTriggerTestExtended* weakSelf = self;
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
                
                SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    requestResult_ = result_;
                    
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ weakSelf asyncTriggerAllWithContext: apiContext_ ];
                
                loader(nil, nil, doneHandler);
               
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
//    GHAssertTrue( requestResult_ != nil, @"requestResult  shouldn't be nil" );
}

@end
