#import "SCAsyncTestCase.h"

@interface GetFieldFromItemTest : SCAsyncTestCase
@end

@implementation GetFieldFromItemTest

-(void)testAfterValueReadImage
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_  = nil;
    __block id fieldValue_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath: SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    item_ = result_;
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    apiContext_.defaultSite = nil;
                    [ item_ readFieldValueOperationForFieldName: @"Image" ]( ^( id result_, NSError* error_ )
                    {
                        fieldValue_ = [ item_ fieldValueWithName: @"Image" ];
                        didFinishCallback_();
                    } );
                } );
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( fieldValue_ != nil, @"OK" );
    GHAssertTrue( [ fieldValue_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
}

-(void)testAfterFieldReadCheckbox
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id field_value_ = nil;
    __block SCField* field_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath:  SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    item_ = result_;
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    NSSet* fields_ = [ NSSet setWithObject: @"CheckBoxField" ];
                    [ item_ readFieldsOperationForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                    {
                        field_ = [ item_ fieldWithName: @"CheckBoxField" ];
                        field_value_ = [ item_ fieldValueWithName: @"CheckBoxField" ];
                        didFinishCallback_();
                    } );
                } );
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    GHAssertTrue( apiContext_ != nil, @"api context is nil" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    
    GHAssertEqualStrings( [ field_ rawValue ], @"1", @"raw value mismatch %@", [ field_ rawValue ] );

    GHAssertEqualStrings( [ field_ type ], @"Checkbox", @"checkbox field type expected %@", [ field_ type ] );

    
    // item from SQL is now not equal to item from DB
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    GHAssertTrue( field_value_ != nil, @"OK" );
    GHAssertTrue( [ (NSNumber*)field_value_ intValue ] == 1, @"OK" );
    GHAssertTrue( [ [ field_ fieldValue ] boolValue ] == TRUE, @"OK" );
}

-(void)testAfterFieldReadDateTimeAndDate
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id dateValue_ = nil;
    __block SCField* dateField_ = nil;
    __block id datetimeValue_ = nil;
    __block SCField* datetimeField_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath: SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    item_ = result_;
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    NSSet* fields_ = [ NSSet setWithObjects: @"DateField", @"DateTimeField", nil ];
                    apiContext_.defaultSite = nil;
                    
                    [ item_ readFieldsOperationForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                    {
                        dateField_     = [ item_ fieldWithName: @"DateField" ];
                        dateValue_     = [ item_ fieldValueWithName: @"DateField" ];
                        datetimeField_ = [ item_ fieldWithName: @"DateTimeField" ];
                        datetimeValue_ = [ item_ fieldValueWithName: @"DateTimeField" ];
                        didFinishCallback_();
                    } );
                } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //Date field
    GHAssertTrue( dateField_ != nil, @"OK" );
    GHAssertTrue( [ [ dateField_ rawValue ] isEqualToString: @"20120201T000000" ], @"OK" );
    GHAssertTrue( [ [ dateField_ type ] isEqualToString: @"Date" ], @"OK" );
    GHAssertTrue( [ dateField_ item ] == item_, @"OK" );
    GHAssertTrue( dateValue_ != nil, @"OK" );
    GHAssertTrue( [ dateValue_ isKindOfClass: [ NSDate class ] ] == TRUE, @"OK" );
    NSDateFormatter *dateFormatter = [ NSDateFormatter new ];
    [ dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss ZZ" ];
    [ dateFormatter setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US" ] ];
    NSDate* dateToCompare = [ dateFormatter dateFromString: @"01 Feb 2012 00:00:00 -0000" ];
    GHAssertTrue( [ dateValue_ isEqualToDate: dateToCompare ] == TRUE, @"OK" );
    //Datetime field
    GHAssertTrue( datetimeField_ != nil, @"OK" );
    GHAssertTrue( [ [ datetimeField_ rawValue ] isEqualToString: @"20120201T120000" ], @"OK" );
    GHAssertTrue( [ [ datetimeField_ type ] isEqualToString: @"Datetime" ], @"OK" );
    GHAssertTrue( [ datetimeField_ item ] == item_, @"OK" );
    GHAssertTrue( datetimeValue_ != nil, @"OK" );
    GHAssertTrue( [ datetimeValue_ isKindOfClass: [ NSDate class ] ] == TRUE, @"OK" );
    [ dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss ZZ" ];
    dateToCompare = [ dateFormatter dateFromString: @"01 Feb 2012 12:00:00 -0000" ];
    GHAssertTrue( [ datetimeValue_ isEqualToDate: dateToCompare ] == TRUE, @"OK" );

}

-(void)testAfterFieldReadMultilist
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id field_value_ = nil;
    __block SCField* field_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath: SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    item_ = result_;
                    
                    apiContext_.defaultSite = nil;
                    [ item_ readFieldsOperationForFieldsNames: [ NSSet setWithObject: @"MultiListField" ] ]( ^( id result_, NSError* error_ )
                    {
                        field_ = [ item_ fieldWithName: @"MultiListField" ];
                        field_value_ = [ item_ fieldValueWithName: @"MultiListField" ];
                        didFinishCallback_();
                    } );
                } );
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: SCAllowedParentID ], @"OK" );
    
    GHAssertEqualStrings( [ field_ type ], @"Multilist", @"Multilist field type expected %@", [ field_ type ] );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    GHAssertTrue( field_value_ == nil, @"OK" );
    GHAssertTrue( [ field_ fieldValue ] == nil, @"OK" );
}

-(void)testAfterFieldReadTreelist
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_   = nil;
    __block id fieldValue_  = nil;
    __block SCField* field_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath:  SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    item_ = result_;
                    
                    apiContext_.defaultSite = nil;
                    [ item_ readFieldsOperationForFieldsNames: [ NSSet setWithObject: @"TreeListField" ] ]( ^( id result_, NSError* error_ )
                    {
                        field_ = [ item_ fieldWithName: @"TreeListField" ];
                        fieldValue_ = [ item_ fieldValueWithName: @"TreeListField" ];
                        didFinishCallback_();
                    } );
                } );
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    
    GHAssertEqualStrings( [ field_ rawValue ], @"{2075CBFF-C330-434D-9E1B-937782E0DE49}|{00CB2AC4-70DB-482C-85B4-B1F3A4CFE643}", @"raw value mismatch %@", [ field_ rawValue ] );
    GHAssertEqualStrings( [ field_ type ], @"Treelist", @"Treelist field type expected %@", [ field_ type ] );

    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    GHAssertTrue( fieldValue_ == nil, @"OK" );
    GHAssertTrue( [ field_ fieldValue ] == nil, @"OK" );
}

-(void)testNoReadFieldString
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id field_value_ = nil;
    __block SCField* field_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath: SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    item_ = result_;
                    field_ = [ item_ fieldWithName: @"Text" ];
                    field_value_ = [ item_ fieldValueWithName: @"Text" ];
                    didFinishCallback_();
                } );
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ == nil, @"OK" );
    GHAssertTrue( field_value_ == nil, @"OK" );
}

-(void)testCheckAndMultiList
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id checklistValue_ = nil;
    __block id multilistValue_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath:  SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    item_ = result_;
                    //TODO: @igk fix uppercase
                    NSSet* fieldNames_ = [ NSSet setWithObjects: @"MULTILISTFIELD", @"CHECKLISTFIELD", nil ];
                    apiContext_.defaultSite = nil;

                    [ item_ readFieldsValuesOperationForFieldsNames: fieldNames_ ]( ^( id result_, NSError* error_ )
                    {
                        checklistValue_ = [ result_ objectForKey: @"CHECKLISTFIELD" ];
                        multilistValue_ = [ result_ objectForKey: @"MULTILISTFIELD" ];
                        didFinishCallback_();
                    } );
                } );
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    NSLog( @"item_: %@", item_ );
    NSLog( @"checklistValue_: %@", checklistValue_ );
    //Checklist test
    GHAssertTrue( checklistValue_ != nil, @"OK" );
    GHAssertTrue( [ checklistValue_ count ] == 1, @"OK" );
    SCItem* valueItem_ = checklistValue_[ 0 ];
    GHAssertTrue( valueItem_ != nil, @"OK" );
    GHAssertTrue( [ valueItem_.itemId isEqualToString: SCAllowedParentID ] == TRUE, @"OK" );

    //Multilist test
    GHAssertTrue( multilistValue_ != nil, @"OK" );
    GHAssertTrue( [ multilistValue_ count ] == 1, @"OK" );
    valueItem_ = multilistValue_[ 0 ];
    GHAssertTrue( valueItem_ != nil, @"OK" );
    GHAssertTrue( [ valueItem_.itemId isEqualToString: SCAllowedParentID ] == TRUE, @"OK" );
}

-(void)testDroplinkAndDroptree
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id droplink_value_ = nil;
    __block id droptree_value_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath: SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    item_ = result_;
                    NSSet* fieldNames_ = [ NSSet setWithObjects: @"DropLinkFieldEmpty", @"DropTreeFieldNormal", nil ];
                    apiContext_.defaultSite = nil;
                    
                    [ item_ readFieldsValuesOperationForFieldsNames: fieldNames_ ]( ^( id result_, NSError* error_ )
                    {
                        droplink_value_ = [ item_ fieldValueWithName: @"DropLinkFieldEmpty" ];
                        droptree_value_ = [ item_ fieldValueWithName: @"DropTreeFieldNormal" ];

                        didFinishCallback_();
                    } );
                } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //droplink test
    GHAssertTrue( droplink_value_ == nil, @"OK" );

    //droptree test
    GHAssertTrue( droptree_value_ != nil, @"OK" );
    SCItem* value_item_ = droptree_value_;
    GHAssertTrue( value_item_ != nil, @"OK" );
    GHAssertTrue( [ value_item_.itemId isEqualToString: SCAllowedParentID ] == TRUE, @"OK" );
}

-(void)testImageLoaderForSCMediaPath
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block id value_ = nil;
    __block NSError* receivedError = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ downloadResourceOperationForMediaPath:  @"~/media/Images/test image" ]( ^( id result_, NSError* error_ )
                {
                    value_ = result_;
                    receivedError = error_;
                    
                    didFinishCallback_();
                } );
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    //GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertNotNil( value_, @"OK" );
    GHAssertTrue( [ value_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
    
    GHAssertNil( receivedError, @"media download error" );
}

-(void)testGeneralLinkMediaNormal
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id mediaValue_ = nil;
    __block SCGeneralLinkField* field_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath:  SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    NSLog( @"item: %@", item_ );
                    item_ = result_;
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    NSSet* fields_ = [ NSSet setWithObject: @"GeneralLinkFieldMediaNormal" ] ;
                    apiContext_.defaultSite = nil;
                    [ item_ readFieldsOperationForFieldsNames: fields_ ]( ^( id field_result_, NSError* error_ )
                    {
                        field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldMediaNormal" ];
                        if ( ![ field_ linkData ] )
                        {
                            didFinishCallback_();
                            return;
                        }

                        SCMediaFieldLinkData* linkData_ = (SCMediaFieldLinkData*)[ field_ linkData ];
                        [ linkData_ readImageOperation ]( ^( id result_, NSError* error_ )
                        {
                            mediaValue_ = result_;
                            didFinishCallback_();
                        } );
                    } );
                } );
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
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCMediaFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCMediaFieldLinkData* link_data_ = (SCMediaFieldLinkData*)[ field_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"media" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"/Images/test image" ], @"OK" );
    GHAssertTrue( [ [ link_data_ itemId ] isEqualToString: @"{4F20B519-D565-4472-B018-91CB6103C667}" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
    //test image reader
    GHAssertTrue( mediaValue_ != nil, @"OK" );
    GHAssertTrue( [ mediaValue_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
}

-(void)testGeneralLinkLinkEmpty
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath:  SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    item_ = result_;
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    apiContext_.defaultSite = nil;
                    [ item_ readFieldsOperationForFieldsNames: [ NSSet setWithObject: @"GeneralLinkFieldLinkEmpty" ] ]( ^( id field_result_, NSError* error_ )
                    {
                        field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldLinkEmpty" ];
                        didFinishCallback_();
                    } );
                } );
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

    GHAssertEqualStrings( [ field_ type ], @"General Link", @"General Link field type expected %@", [ field_ type ] );
    
     GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCFieldLinkData class ] ] == TRUE, @"OK" );
     SCFieldLinkData* link_data_ = (SCInternalFieldLinkData*)[ field_ linkData ];
     GHAssertTrue( [ link_data_ linkDescription ] == nil, @"OK" );
     GHAssertTrue( [ link_data_ alternateText ] == nil, @"OK" );
     GHAssertTrue( [ link_data_ url ] == nil, @"OK" );
     //test field value
     GHAssertTrue( [ field_ fieldValue ] == link_data_, @"OK" );

    GHAssertTrue( [ field_ item ] == item_, @"OK" );
}

-(void)testGeneralLinkExtLinkInvalid
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath:  SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    item_ = result_;
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    apiContext_.defaultSite = nil;
                    
                    
                    [ item_ readFieldsOperationForFieldsNames: [ NSSet setWithObject: @"GeneralLinkFieldExtLinkInvalid" ] ]( ^( id field_result_, NSError* error_ )
                    {
                        field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldExtLinkInvalid" ];
                        didFinishCallback_();
                    } );
                } );
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
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"external" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"http://abc!@test^_^" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

-(void)testGeneralLinkEmail
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath:  SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    item_ = result_;
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    NSSet* fields_ = [ NSSet setWithObject: @"GeneralLinkFieldEmail" ];
                    apiContext_.defaultSite = nil;
                    
                    [ item_ readFieldsOperationForFieldsNames: fields_ ]( ^( id field_result_, NSError* error_ )
                    {
                        field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldEmail" ];
                        didFinishCallback_();
                    } );
                } );
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
    GHAssertEqualStrings( [ field_ type ], @"General Link", @"General Link field type expected %@", [ field_ type ] );
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCEmailFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCEmailFieldLinkData* link_data_ = (SCEmailFieldLinkData*)[ field_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"mailto" ], @"OK" );
    NSLog( @"link_data_: %@", link_data_ );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"mailto:rundueva@gmail.com" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

-(void)testGeneralLinkJavascriptNormal
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath:  SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    item_ = result_;
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    NSSet* fields_ = [ NSSet setWithObject: @"GeneralLinkFieldJavascript" ];
                    apiContext_.defaultSite = @"/sitecore/shell";
                    
                    [ item_ readFieldsOperationForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                    {
                        field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldJavascript" ];
                        didFinishCallback_();
                    } );
                } );
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
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCJavascriptFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCJavascriptFieldLinkData* link_data_ = (SCJavascriptFieldLinkData*)[ field_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"javascript" ], @"OK" );
    NSLog( @"link_data_: %@", link_data_ );
    GHAssertTrue( [ link_data_ alternateText ] == nil, @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"javascript:document.write('Test javascript field')" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}


 //STODO: uncomment for payload testing
-(void)testGetStandardField
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext =
                [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext;
                
                [ apiContext_ readItemOperationForItemPath:  SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    item_ = result_;
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    NSSet* fields_ = [ NSSet setWithObject: @"__Display name" ];
                    apiContext_.defaultSite = nil;
                    
                    [ item_ readFieldsValuesOperationForFieldsNames:fields_]( ^( id result_, NSError* error_ )
                    {
                        field_ = [ item_ fieldWithName:  @"__Display name" ];
                        didFinishCallback_();
                    } );
                } );
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
    
    NSString* fieldValue = [ field_ rawValue ];
    GHAssertEqualObjects( fieldValue, @"Test Fields", @"OK" );

}

-(void)testFieldIsCaseInsensitive
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
                apiContext_ = strongContext_;
                
                [ apiContext_ readItemOperationForItemPath:  SCTestFieldsItemPath ]( ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    item_ = result_;
                    //TODO: @igk fix uppercase
                    NSSet* fieldNames_ = [ NSSet setWithObjects: @"MULTILISTFIELD", nil ];
                    apiContext_.defaultSite = nil;
                    
                    [ item_ readFieldsValuesOperationForFieldsNames: fieldNames_ ]( ^( id result_, NSError* error_ )
                                                                            {
                                                            
                                                                                didFinishCallback_();
                                                                            } );
                } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    id multilistValueUPCase_ = [ item_ fieldWithName: @"MULTILISTFIELD" ];
    id multilistValueLOWCase_ = [ item_ fieldWithName: @"multilistfield" ];
    id multilistValueRandomCase_ = [ item_ fieldWithName: @"MulTIlistFIeld" ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
 
    GHAssertTrue( multilistValueUPCase_ != nil, @"OK" );
    GHAssertTrue( multilistValueLOWCase_ != nil, @"OK" );
    GHAssertTrue( multilistValueRandomCase_ != nil, @"OK" );
    
    
    GHAssertTrue( multilistValueUPCase_ == multilistValueLOWCase_, @"OK" );
    GHAssertTrue( multilistValueLOWCase_ == multilistValueRandomCase_, @"OK" );
}

@end
