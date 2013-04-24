#import "SCSocialFactory.h"
#import "SCTwitterPoster.h"
#import "SCSocialFrameworkPoster.h"

#import "SCBaseSocialPoster+ServiceType.h"

@implementation SCSocialFactory

static NSDictionary* classMap = nil;
+(NSDictionary*)posterTypes
{
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken,
    ^{
        classMap =
        @{
            @"twitter"  : [ SCTwitterPoster         class ],
            @"facebook" : [ SCSocialFrameworkPoster class ],
            @"weibo"    : [ SCSocialFrameworkPoster class ]
        };
    });
    
    return classMap;
}


+(SCBaseSocialPoster*)newPosterNamed:( NSString* )name
{
    Class resultClass = [ self posterTypes ][name];
    if ( nil == resultClass )
    {
        return nil;
    }
  
    SCBaseSocialPoster* result = [ resultClass new ];
    result.serviceType = name;
    
    return result;
}

@end
