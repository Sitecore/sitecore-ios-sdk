#import "SCAsyncTestCase.h"

@interface GetFieldsFromItemReaderTestExtended : SCAsyncTestCase
@end

@implementation GetFieldsFromItemReaderTestExtended

-(void)testMultilistCheckboxImageStringFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* result_items_           = nil;
    __block SCField* checklist_field_        = nil;
    __block SCField* multilist_field_        = nil;
    __block SCField* checkbox_field_         = nil;
    __block SCField* image_field_            = nil;
    __block SCField* sinlgeline_field_       = nil;

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = SCTestFieldsItemPath;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"CheckListField"
                                    , @"MultiListField"
                                    , @"CheckBoxField"
                                    , @"Image"
                                    , @"Normal Text", nil ];

            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_     = items_;
                checklist_field_  = [ items_[ 0 ] fieldWithName: @"CheckListField" ];
                multilist_field_  = [ items_[ 0 ] fieldWithName: @"MultiListField" ];
                checkbox_field_   = [ items_[ 0 ] fieldWithName: @"CheckBoxField"  ];
                image_field_      = [ items_[ 0 ] fieldWithName: @"Image"    ];
                sinlgeline_field_ = [ items_[ 0 ] fieldWithName: @"Normal Text"     ];
                
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = result_items_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    // Checklist test
    GHAssertTrue( checklist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ checklist_field_ rawValue ] isEqualToString: SCAllowedParentID ], @"OK" );
    GHAssertTrue( [ [ checklist_field_ type ] isEqualToString: @"Checklist" ], @"OK" );
    GHAssertTrue( [ checklist_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"CheckListField" ] == checklist_field_, @"OK" );
    NSArray* values_ = [ checklist_field_ fieldValue ];
    GHAssertTrue( [ values_ count ] == 0, @"OK" );
    //Multilist test
    GHAssertTrue( multilist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ multilist_field_ rawValue ] isEqualToString: SCAllowedParentID ], @"OK" );
    GHAssertTrue( [ [ multilist_field_ type ] isEqualToString: @"Multilist" ], @"OK" );
    GHAssertTrue( [ multilist_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"MultiListField" ] == multilist_field_, @"OK" );
    values_ = [ multilist_field_ fieldValue ];
    GHAssertTrue( [ values_ count ] == 0, @"OK" );
    // Checkbox test
    GHAssertTrue( checkbox_field_ != nil, @"OK" );
    GHAssertTrue( [ [ checkbox_field_ rawValue ] isEqualToString: @"1" ], @"OK" );
    GHAssertTrue( [ [ checkbox_field_ type ] isEqualToString: @"Checkbox" ], @"OK" );
    GHAssertTrue( [ checkbox_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"CheckBoxField" ] == checkbox_field_, @"OK" );
    id value_ = [ checkbox_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ boolValue ] == TRUE, @"OK" );
    // Image test
    GHAssertTrue( image_field_ != nil, @"OK" );
    GHAssertTrue( [ image_field_ rawValue ] != nil , @"OK" );
    GHAssertTrue( [ [ image_field_ type ] isEqualToString: @"Image" ], @"OK" );
    GHAssertTrue( [ image_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"Image" ] == image_field_, @"OK" );
    value_ = [ image_field_ fieldValue ];
    GHAssertTrue( value_ == nil, @"OK" );
    // Single-Line test
    GHAssertTrue( sinlgeline_field_ != nil, @"OK" );
    GHAssertTrue( [ [ sinlgeline_field_ rawValue ] isEqualToString: @"Normal Text" ], @"OK" );
    GHAssertTrue( [ [ sinlgeline_field_ type ] isEqualToString: @"Single-Line Text" ], @"OK" );
    GHAssertTrue( [ sinlgeline_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"Normal Text" ] == sinlgeline_field_, @"OK" );
    value_ = [ sinlgeline_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ isEqualToString: @"Normal Text" ] == TRUE, @"OK" );
}

-(void)testTreelistDateTimeFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* result_items_           = nil;
    __block SCField* treelist_field_         = nil;
    __block SCField* date_field_             = nil;
    __block SCField* datetime_field_         = nil;

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiLogin
                                                          password: SCWebApiPassword
                                                           version: SCWebApiV1 ];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = SCTestFieldsItemPath;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"TreeListField"
                                    , @"DateField"
                                    , @"DateTimeField"
                                    , nil ];

            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_      = items_;
                treelist_field_    = [ items_[ 0 ] fieldWithName: @"TreeListField" ];
                date_field_        = [ items_[ 0 ] fieldWithName: @"DateField" ];
                datetime_field_    = [ items_[ 0 ] fieldWithName: @"DateTimeField" ];
                
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
            
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = result_items_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    // Treelist test
    GHAssertTrue( treelist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ treelist_field_ rawValue ] isEqualToString: @"{2075CBFF-C330-434D-9E1B-937782E0DE49}|{00CB2AC4-70DB-482C-85B4-B1F3A4CFE643}" ], @"OK" );
    GHAssertTrue( [ [ treelist_field_ type ] isEqualToString: @"Treelist" ], @"OK" );
    GHAssertTrue( [ treelist_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"TreeListField" ] == treelist_field_, @"OK" );
    NSArray* values_ = [ treelist_field_ fieldValue ];
    GHAssertTrue( [ values_ count ] == 0, @"OK" );
    // Date field
    GHAssertTrue( date_field_ != nil, @"OK" );
    GHAssertTrue( [ date_field_ rawValue ] != nil , @"OK" );
    GHAssertTrue( [ [ date_field_ rawValue ] isEqualToString: @"20120201T000000" ], @"OK" );
    GHAssertTrue( [ [ date_field_ type ] isEqualToString: @"Date" ], @"OK" );
    GHAssertTrue( [ date_field_ isKindOfClass: [ SCDateField class ] ] == TRUE, @"OK" );
    id date_ = [ date_field_ fieldValue ];
    GHAssertTrue( [ date_ isKindOfClass: [ NSDate class ] ] == TRUE, @"OK" );
    NSDateFormatter *dateFormatter_ = [ [ NSDateFormatter alloc ] init ];
    [ dateFormatter_ setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US" ] ];
    [ dateFormatter_ setDateFormat:@"dd MMM yyyy HH:mm:ss ZZ" ];
    NSDate* dateToCompare = [ dateFormatter_ dateFromString: @"01 Feb 2012 00:00:00 -0000" ];
    GHAssertTrue( [ date_ isEqualToDate: dateToCompare ] == TRUE, @"OK" );

    // DateTime field
    GHAssertTrue( datetime_field_ != nil, @"OK" );
    GHAssertTrue( [ datetime_field_ rawValue ] != nil , @"OK" );
    GHAssertTrue( [ [ datetime_field_ rawValue ] isEqualToString: @"20120201T120000" ], @"OK" );
    GHAssertTrue( [ [ datetime_field_ type ] isEqualToString: @"Datetime" ], @"OK" );
    GHAssertTrue( [ datetime_field_ isKindOfClass: [ SCDateField class ] ] == TRUE, @"OK" );
    date_ = [ datetime_field_ fieldValue ];
    GHAssertTrue( [ date_ isKindOfClass: [ NSDate class ] ] == TRUE, @"OK" );
    [ dateFormatter_ setDateFormat:@"dd MMM yyyy HH:mm:ss ZZ" ];
    dateToCompare = [ dateFormatter_ dateFromString: @"01 Feb 2012 12:00:00 -0000" ];
    GHAssertTrue( [ date_ isEqualToDate: dateToCompare ] == TRUE, @"OK" );
}

-(void)testFieldsValuesCheckMultilistCheckboxImageStringFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* result_items_           = nil;
    __block SCField* checklist_field_        = nil;
    __block SCField* multilist_field_        = nil;
    __block SCField* checkbox_field_         = nil;
    __block SCField* image_field_            = nil;
    __block SCField* sinlgeline_field_       = nil;
    __block SCItem* field_value_item_        = nil;

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiAdminLogin
                                                          password: SCWebApiAdminPassword
                                                           version: SCWebApiV1 ];
            apiContext_ = strongContext_;
            apiContext_.defaultSite = @"/sitecore/shell";
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];

            request_.request     = SCTestFieldsItemPath;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"CheckListField"
                                    , @"MultiListField"
                                    , @"CheckBoxField"
                                    , @"Image"
                                    , @"Normal Text"
                                    , nil ];
            request_.flags = SCItemReaderRequestReadFieldsValues;
 
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                SCItem* item_     = items_[ 0 ];
                result_items_     = items_;
                checklist_field_  = [ item_ fieldWithName: @"CheckListField" ];
                multilist_field_  = [ item_ fieldWithName: @"MultiListField" ];
                field_value_item_ = [ multilist_field_ fieldValue ][ 0 ];
                checkbox_field_   = [ item_ fieldWithName: @"CheckBoxField" ];
                image_field_      = [ item_ fieldWithName: @"Image" ];
                sinlgeline_field_ = [ item_ fieldWithName: @"Normal Text" ];
                
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = result_items_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ readFieldsByName ] count ] == 5, @"OK" );
    // Checklist test
    GHAssertTrue( checklist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ checklist_field_ rawValue ] isEqualToString: SCAllowedParentID ], @"OK" );
    GHAssertTrue( [ [ checklist_field_ type ] isEqualToString: @"Checklist" ], @"OK" );
    GHAssertTrue( [ checklist_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"CheckListField" ] == checklist_field_, @"OK" );

    //Multilist test
    GHAssertTrue( multilist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ multilist_field_ rawValue ] isEqualToString: SCAllowedParentID ], @"OK" );
    GHAssertTrue( [ [ multilist_field_ type ] isEqualToString: @"Multilist" ], @"OK" );
    GHAssertTrue( [ multilist_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"MultiListField" ] == multilist_field_, @"OK" );
    GHAssertTrue( field_value_item_ != nil, @"OK" );

    // Checkbox test
    GHAssertTrue( checkbox_field_ != nil, @"OK" );
    GHAssertTrue( [ [ checkbox_field_ rawValue ] isEqualToString: @"1" ], @"OK" );
    GHAssertTrue( [ [ checkbox_field_ type ] isEqualToString: @"Checkbox" ], @"OK" );
    GHAssertTrue( [ checkbox_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"CheckBoxField" ] == checkbox_field_, @"OK" );
    id value_ = [ checkbox_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ boolValue ] == TRUE, @"OK" );
    // Image test
    GHAssertTrue( image_field_ != nil, @"OK" );
    GHAssertTrue( [ image_field_ rawValue ] != nil , @"OK" );
    GHAssertTrue( [ [ image_field_ type ] isEqualToString: @"Image" ], @"OK" );
    GHAssertTrue( [ image_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"Image" ] == image_field_, @"OK" );
    value_ = [ image_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
    // Single-Line test
    GHAssertTrue( sinlgeline_field_ != nil, @"OK" );
    GHAssertTrue( [ [ sinlgeline_field_ rawValue ] isEqualToString: @"Normal Text" ], @"OK" );
    GHAssertTrue( [ [ sinlgeline_field_ type ] isEqualToString: @"Single-Line Text" ], @"OK" );
    GHAssertTrue( [ sinlgeline_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"Normal Text" ] == sinlgeline_field_, @"OK" );
    value_ = [ sinlgeline_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ isEqualToString: @"Normal Text" ] == TRUE, @"OK" );
}

-(void)testFieldsValuesDroplinkDroptreeFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* resultItems_           = nil;
    
    __block SCField* droplinkEmptyField_   = nil;
    __block SCField* droptree_normal_field_  = nil;
   
    __block SCItem* droplink_empty_value_    = nil;
    __block SCItem* droptree_normal_value_   = nil;

    NSSet* fields_ = [ NSSet setWithObjects: @"DropLinkFieldEmpty"
                      , @"DropTreeFieldNormal"
                      , nil ];

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = SCTestFieldsItemPath;
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                             login: SCWebApiLogin 
                                                          password: SCWebApiPassword
                                                           version: SCWebApiV1 ];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = path_;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = fields_;
            request_.flags       = SCItemReaderRequestReadFieldsValues;

            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                NSLog( @"error:%@", error_ );
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                }
                else
                {
                    SCItem* item_ = items_[ 0 ];
                    resultItems_ = items_;
                    
                    droplinkEmptyField_    = [ item_ fieldWithName: @"DropLinkFieldEmpty"   ];
                    droptree_normal_field_ = [ item_ fieldWithName: @"DropTreeFieldNormal" ];
                    droplink_empty_value_  = [ droplinkEmptyField_   fieldValue ];
                    droptree_normal_value_ = [ droptree_normal_field_  fieldValue ];
                    
                    didFinishCallback_();
                }
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ resultItems_ count ] == 1, @"OK" );
    SCItem* item_ = resultItems_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ readFieldsByName ] count ] == [ fields_ count ], @"OK" );
    // droplink_empty test
    GHAssertTrue( droplinkEmptyField_ != nil, @"OK" );
    GHAssertTrue( [ [ droplinkEmptyField_ rawValue ] isEqualToString: @"" ], @"OK" );
    GHAssertTrue( [ [ droplinkEmptyField_ type ] isEqualToString: @"Droplink" ], @"OK" );
    GHAssertTrue( [ droplinkEmptyField_ isKindOfClass: [ SCDroplinkField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droplinkEmptyField_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"DropLinkFieldEmpty" ] == droplinkEmptyField_, @"OK" );
    //test value
    GHAssertTrue( droplink_empty_value_ == nil, @"OK" );
    
    // droptree_normal test
    GHAssertTrue( droptree_normal_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droptree_normal_field_ rawValue ] isEqualToString: SCAllowedParentID ], @"OK" );
    GHAssertTrue( [ [ droptree_normal_field_ type ] isEqualToString: @"Droptree" ], @"OK" );
    GHAssertTrue( [ droptree_normal_field_ isKindOfClass: [ SCDroptreeField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droptree_normal_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"DropTreeFieldNormal" ] == droptree_normal_field_, @"OK" );
    //test value
    GHAssertTrue( droptree_normal_value_ != nil, @"OK" );
    GHAssertTrue( [ droptree_normal_field_ fieldValue ] == droptree_normal_value_, @"OK" );
    GHAssertTrue( [ [ droptree_normal_value_ itemId ] isEqualToString: SCAllowedParentID ], @"OK" );
}

-(void)testGeneralLinkLinkFields
{
    __weak __block SCApiContext* apiContext_  = nil;
    __block NSArray* result_items_            = nil;
    __block SCGeneralLinkField* fieldNormal_ = nil;
    __block SCGeneralLinkField* fieldEmpty_  = nil;
    
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                             login: SCWebApiLogin 
                                                          password: SCWebApiPassword
                                                           version: SCWebApiV1 ];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = SCTestFieldsItemPath;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"GeneralLinkFieldLinkNormal", @"GeneralLinkFieldLinkEmpty", nil ];

            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_ = items_;
                fieldNormal_ = (SCGeneralLinkField*)[ items_[ 0 ] fieldWithName: @"GeneralLinkFieldLinkNormal" ];
                fieldEmpty_  = (SCGeneralLinkField*)[ items_[ 0 ] fieldWithName: @"GeneralLinkFieldLinkEmpty" ];
                
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = result_items_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );

    // normal field test
    GHAssertTrue( fieldNormal_ != nil, @"OK" );
    GHAssertTrue( [ fieldNormal_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ fieldNormal_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ fieldNormal_ linkData ] isKindOfClass: [ SCInternalFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ fieldNormal_ item ] == item_, @"OK" );
    //test link data
    SCInternalFieldLinkData* link_data_ = (SCInternalFieldLinkData*)[ fieldNormal_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"internal" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] containsString: @"/Home/Allowed_Parent" ], @"OK" );
    //GHAssertTrue( [ [ link_data_ anchor ] isEqualToString: @"Anchor" ], @"OK" );
    GHAssertTrue( [ [ link_data_ queryString ] isEqualToString: @"/*" ], @"OK" );
    GHAssertTrue( [ [ link_data_ itemId ] isEqualToString: SCAllowedParentID ], @"OK" );
    //test field value
    SCItem* value_item_ = [ fieldNormal_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
    
    // empty field test
    GHAssertTrue( fieldEmpty_ != nil, @"OK" );
    GHAssertTrue( [[ fieldEmpty_ rawValue ] isEqualToString: @""], @"OK" );
    NSLog(@"[ field_empty_ rawValue ]:%@", [ fieldEmpty_ rawValue ]);
    GHAssertTrue( [ [ fieldEmpty_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ fieldEmpty_ linkData ] isKindOfClass: [ SCFieldLinkData class ] ] == TRUE, @"OK" );
    link_data_ = (SCInternalFieldLinkData*)[ fieldEmpty_ linkData ];
    GHAssertTrue( [ link_data_ linkDescription ] == nil, @"OK" );
    GHAssertTrue( [ link_data_ alternateText ] == nil, @"OK" );
    GHAssertTrue( [ link_data_ url ] == nil, @"OK" );
    //test field value
    GHAssertTrue( [ fieldEmpty_ fieldValue ] == link_data_, @"OK" );
    GHAssertTrue( [ fieldEmpty_ item ] == item_, @"OK" );
}

-(void)testGeneralLinkExtLinkFields
{
    __weak __block SCApiContext* apiContext_  = nil;
    __block NSArray* result_items_            = nil;
    __block SCGeneralLinkField* field_empty_  = nil;

    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                             login: SCWebApiLogin 
                                                          password: SCWebApiPassword];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = SCTestFieldsItemPath;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"GeneralLinkFieldExtLinkInvalid", nil ];

            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_ = items_;
                field_empty_  = (SCGeneralLinkField*)[ items_[ 0 ] fieldWithName: @"GeneralLinkFieldExtLinkInvalid" ];
                
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = result_items_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );

    // invalid field test
    GHAssertTrue( field_empty_ != nil, @"OK" );
    GHAssertTrue( [ field_empty_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_empty_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_empty_ linkData ] isKindOfClass: [ SCExternalFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_empty_ item ] == item_, @"OK" );
    //test link data
    SCExternalFieldLinkData* link_data_ = (SCExternalFieldLinkData*)[ field_empty_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"external" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"http://abc!@test^_^" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_empty_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

-(void)testGeneralLinkMediaField
{
    __weak __block SCApiContext* apiContext_  = nil;
    __block NSArray* resultItems_            = nil;
    __block SCGeneralLinkField* field_normal_ = nil;
    __block id media_value_normal_ = nil;
    
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                             login: SCWebApiLogin 
                                                          password: SCWebApiPassword ];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = SCTestFieldsItemPath;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"GeneralLinkFieldMediaNormal", nil ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                resultItems_ = items_;
                field_normal_ = (SCGeneralLinkField*)[ items_[ 0 ] fieldWithName: @"GeneralLinkFieldMediaNormal" ];
                if ( !field_normal_ )
                {
                    didFinishCallback_();
                    return;
                }
            
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                {
                    media_value_normal_ = result_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader1 = [ (SCMediaFieldLinkData*)[ field_normal_ linkData ] extendedImageReader ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ resultItems_ count ] == 1, @"OK" );
    SCItem* item_ = resultItems_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    
    // normal field test
    GHAssertTrue( field_normal_ != nil, @"OK" );
    GHAssertTrue( [ field_normal_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_normal_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_normal_ linkData ] isKindOfClass: [ SCMediaFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_normal_ item ] == item_, @"OK" );
    //test link data
    SCMediaFieldLinkData* link_data_ = (SCMediaFieldLinkData*)[ field_normal_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"media" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"/Images/test image" ], @"OK" );
    GHAssertTrue( [ [ link_data_ itemId ] isEqualToString: @"{4F20B519-D565-4472-B018-91CB6103C667}" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_normal_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
    //test image reader
    GHAssertTrue( media_value_normal_ != nil, @"OK" );
    GHAssertTrue( [ media_value_normal_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
}

-(void)testGeneralLinkJavascriptField
{
    __weak __block SCApiContext* apiContext_  = nil;
    __block NSArray* result_items_            = nil;
    __block SCGeneralLinkField* field_normal_ = nil;
    
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName 
                                                             login: SCWebApiLogin 
                                                          password: SCWebApiPassword ];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = SCTestFieldsItemPath;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"GeneralLinkFieldJavascript", nil ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_ = items_;
                field_normal_ = (SCGeneralLinkField*)[ items_[ 0 ] fieldWithName: @"GeneralLinkFieldJavascript" ];
                
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
            
            }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = result_items_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    
    // normal field test
    GHAssertTrue( field_normal_ != nil, @"OK" );
    GHAssertTrue( [ field_normal_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_normal_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_normal_ linkData ] isKindOfClass: [ SCJavascriptFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_normal_ item ] == item_, @"OK" );
    //test link data
    SCFieldLinkData* link_data_ = (SCJavascriptFieldLinkData*)[ field_normal_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"javascript" ], @"OK" );
    NSLog( @"link_data_: %@", link_data_ );
    GHAssertTrue( [ link_data_ alternateText ] == nil, @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"javascript:document.write('Test javascript field')" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_normal_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
    
}

-(void)testGeneralLinkAnchorField
{
    __weak __block SCApiContext* apiContext_  = nil;
    __block NSArray* result_items_            = nil;
    __block SCGeneralLinkField* field_normal_ = nil;
    
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiLogin
                                                          password: SCWebApiPassword];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = SCTestFieldsItemPath;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"GeneralLinkFieldAnchor", nil ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_ = items_;
                field_normal_ = (SCGeneralLinkField*)[ items_[ 0 ] fieldWithName: @"GeneralLinkFieldAnchor" ];
                
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = result_items_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    
    // normal field test
    GHAssertTrue( field_normal_ != nil, @"OK" );
    GHAssertTrue( [ field_normal_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_normal_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_normal_ linkData ] isKindOfClass: [ SCAnchorFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_normal_ item ] == item_, @"OK" );
    //test link data
    SCAnchorFieldLinkData* link_data_ = (SCAnchorFieldLinkData*)[ field_normal_ linkData ];
    
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"anchor" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"header1" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_normal_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );

}

-(void)testGeneralLinkEmailField
{
    __weak __block SCApiContext* apiContext_  = nil;
    __block NSArray* resultItems_            = nil;
    __block SCGeneralLinkField* field_normal_ = nil;
    
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiLogin
                                                          password: SCWebApiPassword];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = SCTestFieldsItemPath;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"GeneralLinkFieldEmail", nil ];
            
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                resultItems_ = items_;
                field_normal_ = (SCGeneralLinkField*)[ items_[ 0 ] fieldWithName: @"GeneralLinkFieldEmail" ];
                
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext itemsReaderWithRequest: request_ ];
            loader(nil, nil, doneHandler);
            
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ resultItems_ count ] == 1, @"OK" );
    SCItem* item_ = resultItems_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );

    // normal field test
    GHAssertTrue( field_normal_ != nil, @"OK" );
    GHAssertTrue( [ field_normal_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_normal_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_normal_ linkData ] isKindOfClass: [ SCEmailFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_normal_ item ] == item_, @"OK" );
    //test link data
    SCEmailFieldLinkData* link_data_ = (SCEmailFieldLinkData*)[ field_normal_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"mailto" ], @"OK" );
    NSLog( @"link_data_: %@", link_data_ );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"mailto:rundueva@gmail.com" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_normal_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

@end
