
#import <SCApi/Data/SCFieldRecord.h>
#import <SCApi/Api/Parsers/SCFieldRecord+Parser.h>

@implementation NSDictionary (SCFieldRecordCreateFieldTest)

+(id)fieldJSONWithFieldName:( NSString* )fieldName_
                  fieldType:( NSString* )fieldType_
              fieldRawValue:( NSString* )fieldRawValue_
{
    return [ NSDictionary dictionaryWithObjectsAndKeys:
            fieldName_, @"Name"
            , fieldType_, @"Type"
            , fieldRawValue_, @"Value"
            , nil ];
}

@end

@interface SCFieldRecordCreateFieldTest : GHTestCase
@end

@implementation SCFieldRecordCreateFieldTest

//"{02D852A5-CB04-4B05-9987-CD9A4DD320E5}" = {
//    Name = Title;
//    Type = "Single-Line Text";
//    Value = "";
//};
-(void)testSingleLineTextField
{
    NSString* fieldId_       = @"{02D852A5-CB04-4B05-9987-CD9A4DD320E5}";
    NSString* fieldName_     = @"Title";
    NSString* fieldType_     = @"Single-Line Text";
    NSString* fieldRawValue_ = @"Test";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];

    SCField* field_ = record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId    ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type       ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name       ], @"OK" );

    fieldRawValue_ = [ fieldRawValue_ stringByTrimmingWhitespaces ];
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue   ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.fieldValue ], @"OK" );

    __block NSString* result_ = nil;

    [ field_ fieldValueReader ]( ^( NSString* fieldValue_, NSError* error_ )
    {
        result_ = fieldValue_;
    } );

    GHAssertTrue( [ result_ isEqualToString: fieldRawValue_ ], @"OK" );
}

//"{0340485C-2484-43FC-AF0E-E14667B30655}" =     {
//    Name = DropLinkFieldInvalid;
//    Type = Droplink;
//    Value = "{02C6B148-BC77-4FD6-A13C-03B410E80003}!test";
//};
-(void)testDropLinkFieldInvalid
{
    NSString* fieldId_       = @"{0340485C-2484-43FC-AF0E-E14667B30655}";
    NSString* fieldName_     = @"DropLinkFieldInvalid";
    NSString* fieldType_     = @"Droplink";
    NSString* fieldRawValue_ = @"{02C6B148-BC77-4FD6-A13C-03B410E80003}!test";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];

    SCDroplinkField* field_ = (SCDroplinkField*)record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCDroplinkField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId  ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type     ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name     ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue ], @"OK" );
    GHAssertTrue( field_.fieldValue == nil, @"OK" );
}

//"{13ED6F19-0174-4F7E-9992-2E9E56C16256}" =     {
//    Name = GeneralLinkFieldLinkNormal;
//    Type = "General Link";
//    Value = "<link text=\"Description\" linktype=\"internal\" url=\"/Nicam/Products/Digital_SLR/Tweets.aspx\" anchor=\"Anchor\" querystring=\"/*\" title=\"Alternate Text\" target=\"_blank\" id=\"{02C6B148-BC77-4FD6-A13C-03B410E84103}\" />";
//};
-(void)testGeneralLinkFieldLinkNormalInternal
{
    NSString* fieldId_       = @"{13ED6F19-0174-4F7E-9992-2E9E56C16256}";
    NSString* fieldName_     = @"GeneralLinkFieldLinkNormal";
    NSString* fieldType_     = @"General Link";
    NSString* fieldRawValue_ = @"<link text=\"Description\" linktype=\"internal\" url=\"/Nicam/Products/Digital_SLR/Tweets.aspx\" anchor=\"Anchor\" querystring=\"/*\" title=\"Alternate Text\" target=\"_blank\" id=\"{02C6B148-BC77-4FD6-A13C-03B410E84103}\" />";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];

    SCGeneralLinkField* field_ = (SCGeneralLinkField*)record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCGeneralLinkField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId  ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type     ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name     ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue ], @"OK" );
    GHAssertTrue( field_.fieldValue == field_.linkData, @"OK" );

    SCInternalFieldLinkData* linkData_ = (SCInternalFieldLinkData*)field_.linkData;

    GHAssertTrue( [ linkData_ isMemberOfClass: [ SCInternalFieldLinkData class ] ], @"OK" );

    GHAssertTrue( [ @"Description"                             isEqualToString: linkData_.linkDescription ], @"OK" );
    GHAssertTrue( [ @"internal"                                isEqualToString: linkData_.linkType        ], @"OK" );
    GHAssertTrue( [ @"/Nicam/Products/Digital_SLR/Tweets.aspx" isEqualToString: linkData_.url             ], @"OK" );
    GHAssertTrue( [ @"Alternate Text"                          isEqualToString: linkData_.alternateText   ], @"OK" );
    GHAssertTrue( [ @"Anchor"                                  isEqualToString: linkData_.anchor          ], @"OK" );
    GHAssertTrue( [ @"/*"                                      isEqualToString: linkData_.queryString     ], @"OK" );
    GHAssertTrue( [ @"{02C6B148-BC77-4FD6-A13C-03B410E84103}" isEqualToString: linkData_.itemId          ], @"OK" );
}

//"{1856DF91-D554-43D1-B26C-66A30695DC34}" =     {
//    Name = GeneralLinkFieldExtLinkInvalid;
//    Type = "General Link";
//    Value = "<link text=\"78  78\" linktype=\"external\" url=\"//&amp;&amp;@\" anchor=\"\" class=\"  __4\" target=\"\" />";
//};
-(void)testGeneralLinkFieldExtLinkInvalidExternal
{
    NSString* fieldId_       = @"{1856DF91-D554-43D1-B26C-66A30695DC34}";
    NSString* fieldName_     = @"GeneralLinkFieldExtLinkInvalid";
    NSString* fieldType_     = @"General Link";
    NSString* fieldRawValue_ = @"<link text=\"78  78\" linktype=\"external\" url=\"//&amp;&amp;@\" anchor=\"\" class=\"  __4\" target=\"\" />";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];

    SCGeneralLinkField* field_ = (SCGeneralLinkField*)record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCGeneralLinkField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId  ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type     ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name     ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue ], @"OK" );
    GHAssertTrue( field_.fieldValue == field_.linkData, @"OK" );

    SCExternalFieldLinkData* linkData_ = (SCExternalFieldLinkData*)field_.linkData;

    GHAssertTrue( [ linkData_ isMemberOfClass: [ SCExternalFieldLinkData class ] ], @"OK" );

    GHAssertTrue( [ @"78  78" isEqualToString: linkData_.linkDescription ], @"OK" );
    GHAssertTrue( [ @"external" isEqualToString: linkData_.linkType      ], @"OK" );
    GHAssertTrue( [ @"//&&@" isEqualToString: linkData_.url      ], @"OK" );
    GHAssertTrue( linkData_.alternateText == nil                          , @"OK" );
}

//"{1B52C667-A893-4286-B9C8-9DBC59B3C1FA}" =     {
//    Name = "Short Description";
//    Type = "Rich Text";
//    Value = "
//    \n\t\t<p>Guide to Climbing Photography - high altitudes</p>
//    \n";
//};
-(void)testRichText
{
    NSString* fieldId_       = @"{1B52C667-A893-4286-B9C8-9DBC59B3C1FA}";
    NSString* fieldName_     = @"Short Description";
    NSString* fieldType_     = @"Rich Text";
    NSString* fieldRawValue_ = @"\n\\n\\t\\t<p>Guide to Climbing Photography - high altitudes</p>\n\\n";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];

    SCField* field_ = record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId    ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type       ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name       ], @"OK" );

    fieldRawValue_ = [ fieldRawValue_ stringByTrimmingWhitespaces ];
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue   ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.fieldValue ], @"OK" );
    
    __block NSString* result_ = nil;

    [ field_ fieldValueReader ]( ^( NSString* fieldValue_, NSError* error_ )
    {
        result_ = fieldValue_;
    } );

    GHAssertTrue( [ result_ isEqualToString: fieldRawValue_ ], @"OK" );
}

//"{1B86697D-60CA-4D80-83FB-7555A2E6CE1C}" =     {
//    Name = "__Source";
//    Type = "Version Link";
//    Value = "";
//};
-(void)testEmptyVersionLink
{
    NSString* fieldId_       = @"{1B86697D-60CA-4D80-83FB-7555A2E6CE1C}";
    NSString* fieldName_     = @"__Source";
    NSString* fieldType_     = @"Version Link";
    NSString* fieldRawValue_ = @"";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];

    SCField* field_ = record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId    ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type       ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name       ], @"OK" );

    fieldRawValue_ = [ fieldRawValue_ stringByTrimmingWhitespaces ];
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue   ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.fieldValue ], @"OK" );

    __block NSString* result_ = nil;

    [ field_ fieldValueReader ]( ^( NSString* fieldValue_, NSError* error_ )
    {
        result_ = fieldValue_;
    } );

    GHAssertTrue( [ result_ isEqualToString: fieldRawValue_ ], @"OK" );
}

//"{2269D9A3-80A8-42ED-905C-A79E6D505489}" =     {
//    Name = Number;
//    Type = Number;
//    Value = 234342;
//};
-(void)testNumberField
{
    NSString* fieldId_       = @"{2269D9A3-80A8-42ED-905C-A79E6D505489}";
    NSString* fieldName_     = @"Number";
    NSString* fieldType_     = @"Number";
    NSString* fieldRawValue_ = @"234342";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];

    SCField* field_ = record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId    ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type       ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name       ], @"OK" );

    fieldRawValue_ = [ fieldRawValue_ stringByTrimmingWhitespaces ];
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue   ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.fieldValue ], @"OK" );

    __block NSString* result_ = nil;

    [ field_ fieldValueReader ]( ^( NSString* fieldValue_, NSError* error_ )
    {
        result_ = fieldValue_;
    } );

    GHAssertTrue( [ result_ isEqualToString: fieldRawValue_ ], @"OK" );
}

//"{2F32FD49-8AD7-48EF-A652-900CC9D89AED}" =     {
//    Name = TreeListField;
//    Type = Treelist;
//    Value = "{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}|{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}";
//};
-(void)testTreelistFieldNormal
{
    NSString* fieldId_       = @"{2F32FD49-8AD7-48EF-A652-900CC9D89AED}";
    NSString* fieldName_     = @"TreeListField";
    NSString* fieldType_     = @"Treelist";
    NSString* fieldRawValue_ = @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}|{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];

    SCTreelistField* field_ = (SCTreelistField*)record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCTreelistField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId  ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type     ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name     ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue ], @"OK" );
    GHAssertTrue( field_.fieldValue == nil, @"OK" );
}

//"{320E139D-89AA-4E0D-A1F1-0A5B5899C175}" =     {
//    Name = CheckListField;
//    Type = Checklist;
//    Value = "{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}|{F27FCB87-0CE6-4455-815F-F25310A51D0B}";
//};
-(void)testChecklistFieldNormal
{
    NSString* fieldId_       = @"{320E139D-89AA-4E0D-A1F1-0A5B5899C175}";
    NSString* fieldName_     = @"CheckListField";
    NSString* fieldType_     = @"Checklist";
    NSString* fieldRawValue_ = @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}|{F27FCB87-0CE6-4455-815F-F25310A51D0B}";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];

    SCChecklistField* field_ = (SCChecklistField*)record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCChecklistField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId  ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type     ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name     ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue ], @"OK" );
    GHAssertTrue( field_.fieldValue == nil, @"OK" );
}

//"{4BD9C203-A155-4707-BAB7-0DC4D654A6D8}" =     {
//    Name = DropTreeFieldEmpty;
//    Type = Droptree;
//    Value = "";
//};
-(void)testDropTreeFieldEmpty
{
    NSString* fieldId_       = @"{4BD9C203-A155-4707-BAB7-0DC4D654A6D8}";
    NSString* fieldName_     = @"DropTreeFieldEmpty";
    NSString* fieldType_     = @"Droptree";
    NSString* fieldRawValue_ = @"";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];

    SCDroptreeField* field_ = (SCDroptreeField*)record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCDroptreeField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId  ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type     ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name     ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue ], @"OK" );
    GHAssertTrue( field_.fieldValue == nil, @"OK" );
}

//"{4FC1DBF2-DF98-438D-A8AF-555661C0C19F}" =     {
//    Name = GeneralLinkFieldMediaInvalid;
//    Type = "General Link";
//    Value = "<link linktype=\"media\" url=\"/Mobile SDK/mobile_tweet1\" target=\"\" id=\"\" />";
//};
-(void)testGeneralLinkFieldMediaInvalid
{
    NSString* fieldId_       = @"{13ED6F19-0174-4F7E-9992-2E9E56C16256}";
    NSString* fieldName_     = @"GeneralLinkFieldMediaInvalid";
    NSString* fieldType_     = @"General Link";
    NSString* fieldRawValue_ = @"<link linktype=\"media\" url=\"/Mobile SDK/mobile_tweet1\" target=\"\" id=\"\" />";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];

    SCGeneralLinkField* field_ = (SCGeneralLinkField*)record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCGeneralLinkField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId  ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type     ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name     ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue ], @"OK" );
    GHAssertTrue( field_.fieldValue == field_.linkData, @"OK" );

    SCMediaFieldLinkData* linkData_ = (SCMediaFieldLinkData*)field_.linkData;

    GHAssertTrue( [ linkData_ isMemberOfClass: [ SCMediaFieldLinkData class ] ], @"OK" );

    GHAssertTrue( linkData_.linkDescription == nil, @"OK" );
    GHAssertTrue( [ @"media"                     isEqualToString: linkData_.linkType ], @"OK" );
    GHAssertTrue( [ @"/Mobile SDK/mobile_tweet1" isEqualToString: linkData_.url      ], @"OK" );
    GHAssertTrue( linkData_.alternateText == nil, @"OK" );
    GHAssertTrue( [ @"" isEqualToString: linkData_.itemId ], @"OK" );
}

//"{AD53EF3E-C1F6-4691-93BB-D7F4F694F399}" =     {
//    Name = "Footer Logo";
//    Type = Image;
//    Value = "<image mediaid=\"{14E57FEC-F9BB-41B0-8D40-92CA698ED8A9}\" mediapath=\"/Images/Nicam/Home/footer_logo\" src=\"~/media/Images/Nicam/Home/footer_logo.ashx\" alt=\"footer logo\" height=\"\" width=\"\" hspace=\"\" vspace=\"\" />";
//};
-(void)testImageField
{
    NSString* fieldId_       = @"{AD53EF3E-C1F6-4691-93BB-D7F4F694F399}";
    NSString* fieldName_     = @"Footer Logo";
    NSString* fieldType_     = @"Image";
    NSString* fieldRawValue_ = @"<image mediaid=\"{14E57FEC-F9BB-41B0-8D40-92CA698ED8A9}\" mediapath=\"/Images/Nicam/Home/footer_logo\" src=\"~/media/Images/Nicam/Home/footer_logo.ashx\" alt=\"footer logo\" height=\"\" width=\"\" hspace=\"\" vspace=\"\" />";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];

    SCImageField* field_ = (SCImageField*)record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCImageField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId  ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type     ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name     ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue ], @"OK" );

    GHAssertTrue( [ @"/Images/Nicam/Home/footer_logo" isEqualToString: field_.imagePath ], @"OK" );
}

//"{5E440707-FDC0-4C4B-B92B-8683B6A47D57}" =     {
//    Name = TestField;
//    Type = "General Link";
//    Value = "";
//};
-(void)testGeneralLinkWithEmptyValue
{
    NSString* fieldId_       = @"{13ED6F19-0174-4F7E-9992-2E9E56C16256}";
    NSString* fieldName_     = @"TestField";
    NSString* fieldType_     = @"General Link";
    NSString* fieldRawValue_ = @"";

    NSDictionary* json_ = [ NSDictionary fieldJSONWithFieldName: fieldName_
                                                      fieldType: fieldType_
                                                  fieldRawValue: fieldRawValue_ ];

    SCFieldRecord* record_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                         fieldId: fieldId_
                                                      apiContext: nil ];
    
    SCGeneralLinkField* field_ = (SCGeneralLinkField*)record_.field;

    GHAssertTrue( [ field_ isMemberOfClass: [ SCGeneralLinkField class ] ], @"OK" );

    GHAssertTrue( [ fieldId_       isEqualToString: field_.fieldId  ], @"OK" );
    GHAssertTrue( [ fieldType_     isEqualToString: field_.type     ], @"OK" );
    GHAssertTrue( [ fieldName_     isEqualToString: field_.name     ], @"OK" );
    GHAssertTrue( [ fieldRawValue_ isEqualToString: field_.rawValue ], @"OK" );
    GHAssertTrue( field_.fieldValue == field_.linkData, @"OK" );

    SCFieldLinkData* linkData_ = (SCFieldLinkData*)field_.linkData;

    GHAssertTrue( [ linkData_ isMemberOfClass: [ SCFieldLinkData class ] ], @"OK" );
    
    GHAssertTrue( linkData_.linkDescription == nil, @"OK" );
    GHAssertTrue( linkData_.linkType        == nil, @"OK" );
    GHAssertTrue( linkData_.url             == nil, @"OK" );
    GHAssertTrue( linkData_.alternateText   == nil, @"OK" );
}

@end
