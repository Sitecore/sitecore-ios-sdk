
#import <SCApi/Utils/NSString+IsSCPathValid.h>

@interface IsSCPathValidTest : GHTestCase

@end

@implementation IsSCPathValidTest

// @"/sitecore"
-(void)testIsSCPathValid
{
    GHAssertFalse( [ @"" isSCPathValid ], @"OK" );
    GHAssertFalse( [ @"/" isSCPathValid ], @"OK" );
    GHAssertFalse( [ @"/s" isSCPathValid ], @"OK" );

    GHAssertTrue( [ @"/sitecore" isSCPathValid ], @"OK" );
    GHAssertTrue( [ @"/siTecore/" isSCPathValid ], @"OK" );
    GHAssertTrue( [ @"/sitecOre/ssdsd" isSCPathValid ], @"OK" );
}

@end
