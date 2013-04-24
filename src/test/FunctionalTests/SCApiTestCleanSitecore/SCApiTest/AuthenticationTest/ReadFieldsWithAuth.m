#import "SCAsyncTestCase.h"

@interface ReadFieldsWithAuth : SCAsyncTestCase
@end

@implementation ReadFieldsWithAuth

-(void)testReadItemSWithSomeFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_         = nil;

    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        
        NSSet* field_names_ = [ NSSet setWithObjects: @"Title", nil];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: SCHomePath
                                                                        fieldsNames: field_names_ ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            didFinishCallback_();
        } );
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
        GHAssertTrue( [ item_.displayName isEqualToString: SCHomeDisplayName ], @"OK" );
        NSLog( @"item_children: %@", [ item_ allChildren ] );
        GHAssertTrue( [ item_.allChildren count ]      == 0, @"OK" );
        GHAssertTrue( [ item_.readChildren count ]     == 0, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == 1, @"OK" );
        GHAssertTrue( [ [ item_ fieldWithName: @"Title" ] rawValue ] != nil, @"OK" );
    }
}


@end