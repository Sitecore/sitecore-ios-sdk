#import "SCReadItemsRequest.h"

//add connection network latency options

@implementation SCReadItemsRequest

-(id)initWithRequest:( NSString* )request_
         requestType:( SCReadItemRequestType )requestType_
         fieldsNames:( NSSet* )fieldNames
               scope:( SCReadItemScopeType )scope
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
    NSString* request_ = self->_request ?: @"";

    return self.requestType == SCReadItemRequestItemPath
        ? [ request_ lowercaseString ]
        : request_;
}

+(id)requestWithItemId:( NSString* )itemId
           fieldsNames:( NSSet* )fieldNames
{
    NSParameterAssert( nil != itemId );
    
    return [ [ self alloc ] initWithRequest: itemId
                                requestType: SCReadItemRequestItemId
                                fieldsNames: fieldNames
                                      scope: SCReadItemSelfScope ];
}

+(id)requestWithItemId:( NSString* )itemId
           fieldsNames:( NSSet* )fieldNames
                 scope:( SCReadItemScopeType )scope
{
    NSParameterAssert( nil != itemId );
    
    return [ [ self alloc ] initWithRequest: itemId
                                requestType: SCReadItemRequestItemId
                                fieldsNames: fieldNames
                                      scope: scope ];
}

+(id)requestWithItemPath:( NSString* )itemPath
             fieldsNames:( NSSet* )fieldNames
{
    return [ [ self alloc ] initWithRequest: itemPath
                                requestType: SCReadItemRequestItemPath
                                fieldsNames: fieldNames
                                      scope: SCReadItemSelfScope ];
}

+(id)requestWithItemPath:( NSString* )itemPath
             fieldsNames:( NSSet* )fieldNames
                   scope:( SCReadItemScopeType )scope
{
    return [ [ self alloc ] initWithRequest: itemPath
                                requestType: SCReadItemRequestItemPath
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
    NSParameterAssert( nil != itemId_ );
    
    return [ self requestWithItemId: itemId_
                        fieldsNames: [ NSSet new ] ];
}

-(SCReadItemScopeType)scope
{
    if ( 0 == self->_scope )
    {
        return SCReadItemSelfScope;
    }
    
    return self->_scope;
}

-(id)copyWithZone:( NSZone* )zone_
{
    SCReadItemsRequest * result_ = [ [ [ self class ] allocWithZone: zone_ ] init ];

    result_.scope       = self.scope;
    result_.request     = [ self.request copyWithZone: zone_ ];
    result_.requestType = self.requestType;
    result_.fieldNames  = [ self.fieldNames copyWithZone: zone_ ];
    result_.flags       = self.flags;
    result_.page        = self.page;
    result_.pageSize    = self.pageSize;
    result_.language    = [ self.language copyWithZone: zone_ ];
    result_.database    = [ self.database copyWithZone: zone_ ];
    result_.site        = [ self.site copyWithZone: zone_ ];
    result_.itemVersion = [ self.itemVersion copyWithZone: zone_ ];

    return result_;
}

-(BOOL)isEqual:( SCReadItemsRequest * )other_
{
    if ( other_ == self )
    {
        return YES;
    }

    if ( !other_ || ![ other_ isKindOfClass: [ self class ] ] )
    {
        return NO;
    }

    return [ self isEqualToItemsReaderRequest: other_ ];
}

-(BOOL)isEqualToItemsReaderRequest:( SCReadItemsRequest * )other_
{
    if ( self == other_ )
    {
        return YES;
    }

    return self.scope       == other_.scope
        && self.requestType == other_.requestType
        && self.flags       == other_.flags
        && self.page        == other_.page
        && self.pageSize    == other_.pageSize
        && [ NSObject object: self.request     isEqualTo: other_.request     ]
        && [ NSObject object: self.fieldNames  isEqualTo: other_.fieldNames  ]
        && [ NSObject object: self.language    isEqualTo: other_.language    ]
        && [ NSObject object: self.database    isEqualTo: other_.database    ]
        && [ NSObject object: self.site        isEqualTo: other_.site        ]
        && [ NSObject object: self.itemVersion isEqualTo: other_.itemVersion ];
}

-(NSUInteger)hash
{
    return [ self->_request hash ];
}

@end
