#import "SCCacheSettings.h"

@implementation SCCacheSettings

-(NSString*)userName
{
    if ( nil == self->_userName )
    {
        self->_userName = @"anonymous";
    }
    
    return self->_userName;
}

-(NSString*)getBaseNameForCacheDatabase
{
    NSParameterAssert( nil != self.host     );

    
    NSString* hostAndUser = [ self.host stringByAppendingString: self.userName ];
    NSData* hostAndUserBinary = [ hostAndUser dataUsingEncoding: NSUTF8StringEncoding ];
    
    NSString* result = [ hostAndUserBinary base16String ];
    return result;
}

-(NSString*)getFullNameForCacheDatabaseInDocumentsDir
{
    return [ NSString documentsPathByAppendingPathComponent: [ self getBaseNameForCacheDatabase ] ];
}

@end
