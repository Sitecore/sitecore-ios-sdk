#import "SCAsyncTestCase.h"

@interface GetFieldValueFromFieldTestExtended : SCAsyncTestCase
@end

@implementation GetFieldValueFromFieldTestExtended

-(void)testStringField
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

            NSString* path_ = SCAllowedParentPath;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                NSSet* fields_ = [ NSSet setWithObject: @"Title" ];
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"Title" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    SCDidFinishAsyncOperationHandler doneHandler2 = ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    };

                    apiContext_.defaultSite = nil;
                    SCExtendedAsyncOp loader2 = [ field_ readFieldValueExtendedOperation ];
                    loader2(nil, nil, doneHandler2);
                    
                };
                
                apiContext_.defaultSite = nil;
                SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: fields_ ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: path_
                                                                                   itemSource: contextSource ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    NSLog( @"[ field_ type ]: %@", [ field_ type ] );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"text" ], @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"Allowed_Parent" ], @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    GHAssertTrue( [ [ field_ fieldValue ] isKindOfClass: [ NSString class ] ] == TRUE, @"OK" );
    NSLog( @"[ field_ fieldValue ]: %@", [ field_ fieldValue ] );
    GHAssertTrue( [ [ field_ fieldValue ] isEqualToString: @"Allowed_Parent" ], @"OK" );
}

-(void)testImageField
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                NSSet* fields_ = [ NSSet setWithObject: @"Image" ];

                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"Image" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    SCDidFinishAsyncOperationHandler doneHandler2 = ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    };
                    
                    apiContext_.defaultSite = nil;
                    SCExtendedAsyncOp loader2 = [ field_ readFieldValueExtendedOperation ];
                    loader2(nil, nil, doneHandler2);
                };
                
                apiContext_.defaultSite = nil;
                SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: fields_ ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: SCTestFieldsItemPath
                                        itemSource: contextSource ];
            loader(nil, nil, doneHandler);
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Image" ], @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCImageField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ [ field_ fieldValue ] isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
}

-(void)testCheckBoxField
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    __block SCItemSourcePOD* contextSource = nil;
    
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"CheckBoxField" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    SCDidFinishAsyncOperationHandler doneHandler2 = ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    };
                    
                    apiContext_.defaultSite = nil;
                    SCExtendedAsyncOp loader2 = [ field_ readFieldValueExtendedOperation ];
                    loader2(nil, nil, doneHandler2);
                };
                
                apiContext_.defaultSite = nil;
                SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: [ NSSet setWithObject: @"CheckBoxField" ] ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: SCTestFieldsItemPath
                                        itemSource: contextSource];
            loader(nil, nil, doneHandler);
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"1" ], @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Checkbox" ], @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCCheckboxField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    GHAssertTrue( [ [ field_ fieldValue ] boolValue ] == TRUE, @"OK" );
}


-(void)testDateField
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    __block SCItemSourcePOD* contextSource = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];
            
            SCDidFinishAsyncOperationHandler doneHAndler = ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"DateField" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    SCDidFinishAsyncOperationHandler doneHandler2 = ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    };
                    
                    SCExtendedAsyncOp loader2 = [ field_ readFieldValueExtendedOperation ];
                    loader2( nil, nil, doneHandler2);
                };
                
                apiContext_.defaultSite = nil;
                SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: [ NSSet setWithObject: @"DateField" ] ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: SCTestFieldsItemPath
                                        itemSource: contextSource ];
            loader(nil, nil, doneHAndler);
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"20120201T000000" ], @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Date" ], @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCDateField class ] ] == TRUE, @"OK" );
    id date_ = [ field_ fieldValue ];
    GHAssertTrue( [ date_ isKindOfClass: [ NSDate class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
}

-(void)testDateTimeField
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

            NSString* path_ = SCTestFieldsItemPath;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"DateTimeField" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    SCDidFinishAsyncOperationHandler doneHandler2 = ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    };
                    
                    SCExtendedAsyncOp loader2 = [ field_ readFieldValueExtendedOperation ];
                    loader2(nil, nil, doneHandler2);
                };
                
                apiContext_.defaultSite = nil;
                SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: [ NSSet setWithObject: @"DateTimeField" ] ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: path_
                                                                                   itemSource: contextSource ];
            loader(nil, nil, doneHandler);
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    NSLog( @"[ field_ rawValue ]: %@", [ field_ rawValue ] );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"20120201T120000" ], @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Datetime" ], @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCDateTimeField class ] ] == TRUE, @"OK" );
    id date_ = [ field_ fieldValue ];
    GHAssertTrue( [ date_ isKindOfClass: [ NSDate class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
}

-(void)testCheckListMultiListSavedFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* checklist_field_ = nil;
    __block SCField* multilist_field_ = nil;
    __block NSArray* checklist_values_ = nil;
    __block NSArray* multilist_values_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

 
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                {
                    checklist_field_ = [ item_ fieldWithName: @"CheckListField" ];
                    multilist_field_ = [ item_ fieldWithName: @"MultiListField" ];
                    if ( !checklist_field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    SCDidFinishAsyncOperationHandler doneHandler2 = ^( id result_, NSError* error_ )
                    {
                        checklist_values_ = [ checklist_field_ fieldValue ];
                        if ( !multilist_field_ )
                        {
                            didFinishCallback_();
                            return;
                        }
                        
                        SCDidFinishAsyncOperationHandler doneHandler3 = ^( id result_, NSError* error_ )
                        {
                            multilist_values_ = [ multilist_field_ fieldValue ];
                            didFinishCallback_();
                        };
                        
                        SCExtendedAsyncOp loader3 = [ multilist_field_ readFieldValueExtendedOperation ];
                        loader3(nil, nil, doneHandler3);
                    };
                    
                    SCExtendedAsyncOp loader2 = [ checklist_field_ readFieldValueExtendedOperation ];
                    loader2(nil, nil, doneHandler2);
                };
                
                apiContext_.defaultSite = nil;
                SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: [ NSSet setWithObjects: @"CheckListField", @"MultiListField", nil ] ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: SCTestFieldsItemPath
                                        itemSource: contextSource ];
            loader(nil, nil, doneHandler);
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //Checklist test
    GHAssertTrue( checklist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ checklist_field_ rawValue ] isEqualToString: SCAllowedParentID ], @"OK" );
    GHAssertTrue( [ [ checklist_field_ type ] isEqualToString: @"Checklist" ], @"OK" );
    GHAssertTrue( [ checklist_field_ isKindOfClass: [ SCChecklistField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ checklist_field_ item ] == item_, @"OK" );
    //test saved field value
    GHAssertTrue( [ checklist_values_ count ] == 1, @"OK" );
    NSLog( @"[ values_ ]: %@", checklist_values_ );
    SCItem* value_item_ = checklist_values_[ 0 ];
    GHAssertTrue( value_item_ != nil, @"OK" );
    GHAssertTrue( [ value_item_.itemId isEqualToString: SCAllowedParentID ] == TRUE, @"OK" );
    
    //Multilist test
    GHAssertTrue( multilist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ multilist_field_ rawValue ] isEqualToString: SCAllowedParentID ], @"OK" );
    GHAssertTrue( [ [ multilist_field_ type ] isEqualToString: @"Multilist" ], @"OK" );
    GHAssertTrue( [ multilist_field_ isKindOfClass: [ SCMultilistField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ multilist_field_ item ] == item_, @"OK" );
    //test saved field value
    GHAssertTrue( [ multilist_values_ count ] == 1, @"OK" );
    NSLog( @"[ values_ ]: %@", multilist_values_ );
    value_item_ = multilist_values_[ 0 ];
    GHAssertTrue( value_item_ != nil, @"OK" );
    NSLog( @"[ value_item_.itemId ]: %@", value_item_.itemId );
    GHAssertTrue( [ value_item_.itemId isEqualToString: SCAllowedParentID ] == TRUE, @"OK" );
}

-(void)testTreeListSavedFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    __block NSArray* values_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];


            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"TreeListField" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    SCDidFinishAsyncOperationHandler doneHandler2 = ^( id result_, NSError* error_ )
                    {
                        values_ = [ field_ fieldValue ];
                        didFinishCallback_();
                    };
                    
                    SCExtendedAsyncOp loader2 = [ field_ readFieldValueExtendedOperation ];
                    loader2(nil, nil, doneHandler2);
                };
                
                apiContext_.defaultSite = nil;
                SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: [ NSSet setWithObjects: @"TreeListField", nil ] ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: SCTestFieldsItemPath
                                        itemSource: contextSource ];
            loader(nil, nil, doneHandler);
            
            
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );

    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"{2075CBFF-C330-434D-9E1B-937782E0DE49}|{00CB2AC4-70DB-482C-85B4-B1F3A4CFE643}" ], @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Treelist" ], @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCTreelistField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test saved field value
    GHAssertTrue( [ values_ count ] == 2, @"OK" );
    NSLog( @"[ values_ ]: %@", values_ );
    SCItem* value_item_ = values_[ 0 ];
    GHAssertTrue( value_item_ != nil, @"OK" );
    GHAssertTrue( [ value_item_.itemId isEqualToString: SCAllowedParentID ] == TRUE, @"OK" );
}

-(void)testCheckListMultiListUnSavedFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* checklist_field_ = nil;
    __block SCField* multilist_field_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

                

                SCDidFinishAsyncOperationHandler doneHAndler = ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    item_ = result_;
                    NSSet* fields_ = [ NSSet setWithObjects: @"CheckListField", @"MultiListField", nil ];
                    
                    SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                    {
                        checklist_field_ = [ item_ fieldWithName: @"CheckListField" ];
                        multilist_field_ = [ item_ fieldWithName: @"MultiListField" ];
                        if ( !checklist_field_ )
                        {
                            didFinishCallback_();
                            return;
                        }
                        
                        SCDidFinishAsyncOperationHandler doneHandler2 = ^( id result_, NSError* error_ )
                        {
                            if ( !multilist_field_ )
                            {
                                didFinishCallback_();
                                return;
                            }
                            
                            SCDidFinishAsyncOperationHandler doneHandler3 = ^( id result_, NSError* error_ )
                            {
                                didFinishCallback_();
                            };
                            
                            SCExtendedAsyncOp loader3 = [ multilist_field_ readFieldValueExtendedOperation ];
                            loader3(nil, nil, doneHandler3);
                        };
                        
                        SCExtendedAsyncOp loader2 = [ checklist_field_ readFieldValueExtendedOperation ];
                        loader2(nil, nil, doneHandler2);
                    };
                    
                    apiContext_.defaultSite = nil;
                    SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: fields_ ];
                    loader1(nil, nil, doneHandler1);
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: SCTestFieldsItemPath
                                            itemSource: contextSource ];
                loader(nil, nil, doneHAndler);
             }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
        
        [ [ apiContext_.extendedApiSession itemsCache ] cleanupAll ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    // Checklist test
    GHAssertTrue( checklist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ checklist_field_ rawValue ] isEqualToString: SCAllowedParentID ], @"OK" );
    GHAssertTrue( [ [ checklist_field_ type ] isEqualToString: @"Checklist" ], @"OK" );
    GHAssertTrue( [ checklist_field_ isKindOfClass: [ SCChecklistField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ checklist_field_ item ] == item_, @"OK" );
    NSArray* values_ = [ checklist_field_ fieldValue ];
    //test if field does not retain items of it's value
    GHAssertTrue( values_ == nil, @"OK" );
    //Multilist test
    GHAssertTrue( multilist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ multilist_field_ rawValue ] isEqualToString: SCAllowedParentID ], @"OK" );
    GHAssertTrue( [ [ multilist_field_ type ] isEqualToString: @"Multilist" ], @"OK" );
    GHAssertTrue( [ multilist_field_ isKindOfClass: [ SCMultilistField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ multilist_field_ item ] == item_, @"OK" );
    values_ = [ multilist_field_ fieldValue ];
    //test if field does not retain items of it's value
    GHAssertTrue( values_ == nil, @"OK" );
}


-(void)testTreeListUnSavedField
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"TreeListField" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    SCDidFinishAsyncOperationHandler doneHandler2 =  ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    };
                    
                    SCExtendedAsyncOp loader2 = [ field_ readFieldValueExtendedOperation ];
                    loader2(nil, nil, doneHandler2);
                    
                };
                
                apiContext_.defaultSite = nil;
                SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: [ NSSet setWithObjects: @"TreeListField", nil ] ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: SCTestFieldsItemPath
                                        itemSource: contextSource];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
        [ [ apiContext_.extendedApiSession itemsCache ] cleanupAll ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"{2075CBFF-C330-434D-9E1B-937782E0DE49}|{00CB2AC4-70DB-482C-85B4-B1F3A4CFE643}" ], @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Treelist" ], @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCTreelistField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    NSArray* values_ = [ field_ fieldValue ];
    //test if field does not retain items of it's value
    GHAssertTrue( values_ == nil, @"OK" );
}

-(void)testDroplinkDroptreeSavedNormalFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* droplink_field_ = nil;
    __block SCField* droptree_field_ = nil;
    __block id droplink_value_ = nil;
    __block id droptree_value_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];


            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                {
                    droplink_field_ = [ item_ fieldWithName: @"DropLinkFieldEmpty" ];
                    droptree_field_ = [ item_ fieldWithName: @"DropTreeFieldNormal" ];
                    if ( !droplink_field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    SCDidFinishAsyncOperationHandler doneHAndler2 = ^( id result_, NSError* error_ )
                    {
                        droplink_value_ = [ droplink_field_ fieldValue ];
                        if ( !droptree_field_ )
                        {
                            didFinishCallback_();
                            return;
                        }
                        
                        SCDidFinishAsyncOperationHandler doneHandler3 = ^( id result_, NSError* error_ )
                        {
                            droptree_value_ = [ droptree_field_ fieldValue ];
                            didFinishCallback_();
                        };
                        
                        SCExtendedAsyncOp loader3 = [ droptree_field_ readFieldValueExtendedOperation ];
                        loader3(nil, nil, doneHandler3);
                    };
                    
                    SCExtendedAsyncOp loader2 = [ droplink_field_ readFieldValueExtendedOperation ];
                    loader2(nil, nil, doneHAndler2);
                };
                
                apiContext_.defaultSite = nil;
                SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: [ NSSet setWithObjects: @"DropLinkFieldEmpty", @"DropTreeFieldNormal", nil ] ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: SCTestFieldsItemPath
                                        itemSource: contextSource];
            loader(nil, nil, doneHandler);
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //droplink_field_ test
    GHAssertTrue( droplink_field_ != nil, @"OK" );
    NSLog( @"[ value_ ]: %@", [ droplink_field_ rawValue ] );
    GHAssertTrue( [ [ droplink_field_ rawValue ] isEqualToString: @"" ], @"OK" );
    GHAssertTrue( [ [ droplink_field_ type ] isEqualToString: @"Droplink" ], @"OK" );
    GHAssertTrue( [ droplink_field_ isKindOfClass: [ SCDroplinkField class ] ] == TRUE, @"OK" );
    //test saved field value
    GHAssertTrue( droplink_value_ == nil, @"OK" );
    
    //droptree_field_ test
    GHAssertTrue( droptree_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droptree_field_ rawValue ] isEqualToString: SCAllowedParentID ], @"OK" );
    GHAssertTrue( [ [ droptree_field_ type ] isEqualToString: @"Droptree" ], @"OK" );
    GHAssertTrue( [ droptree_field_ isKindOfClass: [ SCDroptreeField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droptree_field_ item ] == item_, @"OK" );
    //test saved field value
    GHAssertTrue( droptree_value_ != nil, @"OK" );
    NSLog( @"[ value_ ]: %@", droptree_value_ );
    SCItem* value_item_ = droptree_value_;
    GHAssertTrue( value_item_ != nil, @"OK" );
    GHAssertTrue( [ value_item_.itemId isEqualToString: SCAllowedParentID ] == TRUE, @"OK" );
}

-(void)testGeneralLinkLinkNormal
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldLinkNormal" ];
                    didFinishCallback_();
                };
                
                apiContext_.defaultSite = nil;
                SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: [ NSSet setWithObjects: @"GeneralLinkFieldLinkNormal", nil ] ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: SCTestFieldsItemPath
                                        itemSource: contextSource];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //field_ test
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ field_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCInternalFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCInternalFieldLinkData* link_data_ = (SCInternalFieldLinkData*)[ field_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"internal" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] containsString: @"/Home/Allowed_Parent" ], @"OK" );
    GHAssertTrue( [ [ link_data_ anchor ] isEqualToString: @"Anchor" ], @"OK" );
    GHAssertTrue( [ [ link_data_ queryString ] isEqualToString: @"/*" ], @"OK" );
    GHAssertTrue( [ [ link_data_ itemId ] isEqualToString: SCAllowedParentID ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

-(void)testGeneralLinkExtLinkInvalid
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;
    __block SCItemSourcePOD* contextSource = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];


            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSSet* fields_ = [ NSSet setWithObject: @"GeneralLinkFieldExtLinkInvalid" ];
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldExtLinkInvalid" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    SCDidFinishAsyncOperationHandler doneHandler2 = ^( id field_result_, NSError* error_ )
                    {
                        field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldExtLinkInvalid" ];
                        didFinishCallback_();
                    };
                    
                    SCExtendedAsyncOp loader2 = [ field_ readFieldValueExtendedOperation ];
                    loader2(nil, nil, doneHandler2);
                };
                
                apiContext_.defaultSite = nil;
                SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: fields_ ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: SCTestFieldsItemPath
                                                                                   itemSource: contextSource ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //field_ test
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ field_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCExternalFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCExternalFieldLinkData* link_data_ = (SCExternalFieldLinkData*)[ field_ linkData ];
    NSLog( @" %@", [ link_data_ linkDescription ] );
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"external" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"http://abc!@test^_^" ], @"OK" );
}

-(void)testGeneralLinkAnchor
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;
    __block SCItemSourcePOD* contextSource = nil;

    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

            NSString* path_ = SCTestFieldsItemPath;
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSSet* fields_ = [ NSSet setWithObjects: @"GeneralLinkFieldAnchor", nil ];
                
                SCDidFinishAsyncOperationHandler doneHandler1 =  ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldAnchor" ];
                    didFinishCallback_();
                };
                
                apiContext_.defaultSite = nil;
                SCExtendedAsyncOp loader1 = [ item_ extendedFieldsReaderForFieldsNames: fields_ ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: path_
                                                                                   itemSource: contextSource ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //field_ test
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ field_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCAnchorFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCAnchorFieldLinkData* link_data_ = (SCAnchorFieldLinkData*)[ field_ linkData ];

    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"anchor" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"header1" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

@end
