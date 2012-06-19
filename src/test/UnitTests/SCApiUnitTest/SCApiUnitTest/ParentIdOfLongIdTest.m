
#import <SCApi/PathLogic/NSString+ItemPathLogic.h>

@interface ParentIdOfLongIdTest : GHTestCase
@end

@implementation ParentIdOfLongIdTest

-(void)testParentIdOfLongID
{
    {
        NSString* longId_ = [ @"/1/2/3/4" parentIdOfLongId ];
        GHAssertTrue( [ longId_ isEqualToString: @"3" ], @"OK" );
    }

    {
        NSString* longId_ = [ @"/1/2/" parentIdOfLongId ];
        GHAssertTrue( [ longId_ isEqualToString: @"1" ], @"OK" );
    }

    {
        NSString* longId_ = [ @"1/2/" parentIdOfLongId ];
        GHAssertTrue( [ longId_ isEqualToString: @"1" ], @"OK" );
    }

    {
        NSString* longId_ = [ @"/2/" parentIdOfLongId ];
        NSLog( @"longId: %@", longId_ );
        GHAssertTrue( [ longId_ isEqualToString: @"/" ], @"OK" );
    }

    {
        NSString* longId_ = [ @"2/" parentIdOfLongId ];
        NSLog( @"longId: %@", longId_ );
        GHAssertTrue( [ longId_ isEqualToString: @"" ], @"OK" );
    }
}

@end
