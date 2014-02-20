#import "SCAsyncTestCase.h"

@interface ReadFieldsWithAuthExtended : SCAsyncTestCase
@end

@implementation ReadFieldsWithAuthExtended

-(void)testReadItemSWithSomeFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_         = nil;

    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        
        NSSet* field_names_ = [ NSSet setWithObjects: @"Normal Text", nil];
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: SCTestFieldsItemPath
                                                                        fieldsNames: field_names_ ];
        request_.flags = SCItemReaderRequestReadFieldsValues;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            didFinishCallback_();
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_fields_: %@", [ items_[ 0 ] readFieldsByName ]);
    GHAssertTrue( apiContext_ != nil, @"OK" );

    //test get item with auth
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 1, @"OK" );
    SCItem* item_ = nil;
    //test product item
    {
        item_ = items_[ 0 ];
        GHAssertTrue( item_.parent == nil, @"OK" );
        GHAssertTrue( [ item_.displayName isEqualToString: @"Test Fields" ], @"OK" );
        NSLog( @"item_children: %@", [ item_ allChildren ] );
        GHAssertTrue( [ item_.allChildren count ]      == 0, @"OK" );
        GHAssertTrue( [ item_.readChildren count ]     == 0, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == 1, @"OK" );
        GHAssertTrue( [ [ item_ fieldWithName: @"Normal Text" ] rawValue ] != nil, @"OK" );
    }
}


@end