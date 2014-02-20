#import "SCItemSourcePOD.h"
#import "SCReadItemsRequest.h"

@implementation SCItemSourcePOD
{
    NSLocale* _posixLocale;
}


+(SCItemSourcePOD*)newPlainSourceFromItemSource:( id<SCItemSource> )itemSource
{
    SCItemSourcePOD* result = [ SCItemSourcePOD new ];
    
    result.database    = itemSource.database;
    result.site        = itemSource.site    ;
    result.language    = itemSource.language;
    result.itemVersion = itemSource.itemVersion;
    
    return result;
}

-(SCItemSourcePOD*)toPlainStructure
{
    return self;
}

-(instancetype)init
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_posixLocale = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    
    return self;
}

-(BOOL)isEqual:( id )other
{
    if ( other == self )
    {
        return YES;
    }
    else if ( ![ self isMemberOfClass: [ other class ] ] )
    {
        return NO;
    }
    
    return [ self isEqualToItemSource: other ];
}

-(BOOL)isEqualToItemSource:( id<SCItemSource> )other
{
    // @adk - version is ignored by cache
    
    BOOL result =
    [ NSObject object: self.database    isEqualTo: other.database    ] &&
    [ NSObject object: self.language    isEqualTo: other.language    ] &&
    [ NSObject object: self.site        isEqualTo: other.site        ]
//    && [ NSObject object: self.itemVersion isEqualTo: other.itemVersion ]
    ;
    
    return result;
}

-(NSUInteger)hash
{
    // @adk - version is ignored by cache    
    
    return
        self.database.hash +
        self.language.hash +
        self.site.hash
//    + self.itemVersion.hash
    ;
}

-(instancetype)copyWithZone:(NSZone *)zone
{
    SCItemSourcePOD* result = [ [ SCItemSourcePOD allocWithZone: zone ] init ];
    
    result.database     = self.database   ;
    result.language     = self.language   ;
    result.site         = self.site       ;
    result.itemVersion  = self.itemVersion;

    return result;
}

-(void)fillRequestParameters:( SCReadItemsRequest * )request
{
    request.language = self->_language;
    request.database = self->_database;
    request.itemVersion = self->_itemVersion;
    request.site = self->_site;
}

#pragma mark -
#pragma mark lowercase
-(void)setLanguage:( NSString* )value
{
    self->_language = [ value lowercaseStringWithLocale: self->_posixLocale ];
}

-(void)setDatabase:( NSString* )value
{
    self->_database = [ value lowercaseStringWithLocale: self->_posixLocale ];
}

-(void)setSite:( NSString* )value
{
    self->_site = [ value lowercaseStringWithLocale: self->_posixLocale ];
}

-(void)setItemVersion:( NSString* )value
{
    self->_itemVersion = [ value lowercaseStringWithLocale: self->_posixLocale ];
}

@end
