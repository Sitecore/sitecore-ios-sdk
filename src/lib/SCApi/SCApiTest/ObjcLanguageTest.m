
@interface ObjcLanguageTest : SenTestCase
@end


@implementation ObjcLanguageTest

-(void)testWeakRefZeroing
{
    SCItemRecord* record = [ SCItemRecord new ];
    {
        record.itemId = @"{1111-222-333}";
        record.path = @"/sitecore/content/home";
        record.fieldsByName = @{ @"1" : @"1", @"2" : @"2", @"3" : @"3" };
    }
    
    __weak SCItemRecord* weakRecord = record;
    record = nil;
    
    STAssertNil( weakRecord, @"weakRef must be nil now" );
}

@end
