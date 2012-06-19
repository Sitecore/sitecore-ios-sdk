#import "SCItemsReaderRequest.h"

//add connection network latency options

@interface SCItemsReaderRequest ()

@property ( nonatomic ) NSString* database;

@end

@implementation SCItemsReaderRequest

@synthesize scope           = _scope;
@synthesize request         = _request;
@synthesize requestType     = _requestType;
@synthesize fieldNames      = _fieldNames;
@synthesize flags           = _flags;
@synthesize page            = _page;
@synthesize pageSize        = _pageSize;
@synthesize language        = _language;
@synthesize database        = _database;
@synthesize lifeTimeInCache = _lifeTimeInCache;

-(id)initWithRequest:( NSString* )request_
         requestType:( SCItemReaderRequestType )requestType_
         fieldsNames:( NSSet* )fieldNames
               scope:( SCItemReaderScopeType )scope
{
    self = [ super init ];

    if ( self )
    {
        self.request     = request_;
        self.requestType = requestType_;
        self.fieldNames  = fieldNames;
        self.scope       = scope;
    }

    return self;
}

-(NSString*)request
{
    NSString* request_ = _request ?: @"";
    return self.requestType == SCItemReaderRequestItemPath
        ? [ request_ lowercaseString ]
        : request_;
}

+(id)requestWithItemId:( NSString* )itemId
           fieldsNames:( NSSet* )fieldNames
{
    return [ [ self alloc ] initWithRequest: itemId
                                requestType: SCItemReaderRequestItemId
                                fieldsNames: fieldNames
                                      scope: SCItemReaderSelfScope ];
}

+(id)requestWithItemId:( NSString* )itemId
           fieldsNames:( NSSet* )fieldNames
                 scope:( SCItemReaderScopeType )scope
{
    return [ [ self alloc ] initWithRequest: itemId
                                requestType: SCItemReaderRequestItemId
                                fieldsNames: fieldNames
                                      scope: scope ];
}

+(id)requestWithItemPath:( NSString* )itemPath
             fieldsNames:( NSSet* )fieldNames
{
    return [ [ self alloc ] initWithRequest: itemPath
                                requestType: SCItemReaderRequestItemPath
                                fieldsNames: fieldNames
                                      scope: SCItemReaderSelfScope ];
}

+(id)requestWithItemPath:( NSString* )itemPath
             fieldsNames:( NSSet* )fieldNames
                   scope:( SCItemReaderScopeType )scope
{
    return [ [ self alloc ] initWithRequest: itemPath
                                requestType: SCItemReaderRequestItemPath
                                fieldsNames: fieldNames
                                      scope: scope ];
}

+(id)requestWithItemPath:( NSString* )itemPath_
{
    return [ self requestWithItemPath: itemPath_
                          fieldsNames: [ NSSet new ] ];
}

+(id)requestWithItemId:( NSString* )itemId_
{
    return [ self requestWithItemId: itemId_
                        fieldsNames: [ NSSet new ] ];
}

-(SCItemReaderScopeType)scope
{
    if ( 0 == _scope )
        return SCItemReaderSelfScope;
    return _scope;
}

-(id)copyWithZone:( NSZone* )zone_
{
    SCItemsReaderRequest* result_ = [ [ [ self class ] allocWithZone: zone_ ] init ];

    result_.scope       = self.scope;
    result_.request     = [ self.request copyWithZone: zone_ ];
    result_.requestType = self.requestType;
    result_.fieldNames  = [ self.fieldNames copyWithZone: zone_ ];
    result_.flags       = self.flags;
    result_.page        = self.page;
    result_.pageSize    = self.pageSize;
    result_.language    = [ self.language copyWithZone: zone_ ];

    return result_;
}

-(BOOL)isEqual:( SCItemsReaderRequest* )other_
{
    if ( other_ == self )
        return YES;

    if ( !other_ || ![ other_ isKindOfClass: [ self class ] ] )
        return NO;

    return [ self isEqualToItemsReaderRequest: other_ ];
}

-(BOOL)isEqualToItemsReaderRequest:( SCItemsReaderRequest* )other_
{
    if ( self == other_ )
        return YES;

    return self.scope       == other_.scope
        && self.requestType == other_.requestType
        && self.flags       == other_.flags
        && self.page        == other_.page
        && self.pageSize    == other_.pageSize
        && [ NSObject object: self.request    isEqualTo: other_.request    ]
        && [ NSObject object: self.fieldNames isEqualTo: other_.fieldNames ];
}

-(NSUInteger)hash
{
    return [ _request hash ];
}

@end
