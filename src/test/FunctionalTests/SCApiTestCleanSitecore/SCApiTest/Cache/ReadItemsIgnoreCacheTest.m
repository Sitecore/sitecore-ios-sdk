#import "SCAsyncTestCase.h"

@interface ReadItemsIgnoreCacheTest : SCAsyncTestCase
{
    JNConnectionMock* _mock;
}

@property ( nonatomic ) NSInteger connectionOpenCounter;

@end



@implementation ReadItemsIgnoreCacheTest

-(void)setUp
{
    __weak ReadItemsIgnoreCacheTest* weakSelf = self;
    
    
    JFFSimpleBlock action = ^void()
    {
        ++weakSelf.connectionOpenCounter;
    };
    
    self->_mock =
    [ [ JNConnectionMock alloc ] initWithConnectionClass: [ JNNsUrlConnection class ]
                                                  action: action
                                     executeOriginalImpl: YES ];
    
    self.connectionOpenCounter = 0;
}

-(void)tearDown
{
    [ self->_mock disableMock ];
    self->_mock = nil;
    self.connectionOpenCounter = 0;
}

-(void)testReadItemsWithCache
{
    __weak ReadItemsIgnoreCacheTest* weakSelf = self;
    JNConnectionMock* mock_ = self->_mock;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiSession* context = [ TestingRequestFactory getNewAdminContextWithShell ];
        
        SCReadItemsRequest* request = [ SCReadItemsRequest new ];
        request.request = SCHomePath;
        request.requestType = SCReadItemRequestItemPath;
        request.fieldNames = [ NSSet new ];
        
        [ context readItemsOperationWithRequest: request ]( ^( id result, NSError* error )
        {
            if ( [ result count ] == 0 )
            {
                didFinishCallback_();
                return;
            }
            SCItem* item = result[ 0 ];
            SCAsyncOp childrenReader = [ item childrenReader ];
            

            
            //load children here
            childrenReader( ^( id result, NSError *error )
           {
               if ( error )
               {
                   weakSelf.connectionOpenCounter = -1; // fail the test
                   didFinishCallback_();
                   return;
               }

               [ mock_ enableMock ];
               weakSelf.connectionOpenCounter = 0;
               childrenReader( ^( id result, NSError *error )
               {
                   didFinishCallback_();
               } );
           });
        } );
    };
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( 0 == self.connectionOpenCounter, @"Only one connection must be opened with cache " );
}

-(void)testReadItemsIgnoreCache
{
    __weak ReadItemsIgnoreCacheTest* weakSelf = self;
    JNConnectionMock* mock_ = self->_mock;
    
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiSession* context = [ TestingRequestFactory getNewAdminContextWithShell ];
        
        SCReadItemsRequest* request = [ SCReadItemsRequest new ];
        request.request = @"/sitecore/content/home/child::*";
        request.requestType = SCReadItemRequestQuery;
        request.fieldNames  = [ NSSet new ];
        request.flags = SCReadItemRequestIngnoreCache;
        
        [ context readItemsOperationWithRequest: request ]( ^( NSArray* result, NSError* error )
        {
            if ( error )
            {
                weakSelf.connectionOpenCounter = -1; // fail the test
                didFinishCallback_();
                
                return;
            }

            [ mock_ enableMock ];
            [ context readItemsOperationWithRequest: request ]( ^( NSArray* result, NSError* error )
            {
                didFinishCallback_();
            } );
        } );
    };
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    GHAssertTrue( 1 == self.connectionOpenCounter, @"When cache is ignored data must come from network" );
}

@end
