#import "SCError.h"

@implementation SCError

+(NSString*)errorDomain
{
    static NSString* errorDomain_ = nil;

    if ( !errorDomain_ )
    {
        NSString* appName_ = @"net.sitecore.mobileSDK";
        errorDomain_ = [ appName_ stringByAppendingString: @".ErrorDomain" ];
    }

    return errorDomain_;
}

-(id)initWithDescription:( NSString* )description_ code:( NSInteger )code_
{
    NSDictionary* user_info_ = [ NSDictionary dictionaryWithObject: description_
                                                            forKey: NSLocalizedDescriptionKey ];
    return [ super initWithDomain: [ [ self class ] errorDomain ] code: code_ userInfo: user_info_ ];
}

-(id)initWithDescription:( NSString* )description_
{
    return [ self initWithDescription: description_ code: 0 ];
}

-(id)init
{
    NSString* description_ = [ [ NSString alloc ] initWithFormat: @"%@", [ self class ] ];
    return [ self initWithDescription: description_ ];
}

+(id)errorWithDescription:( NSString* )description_ code:( NSInteger )code_
{
    return [ [ self alloc ] initWithDescription: description_ code: code_ ];
}

+(id)errorWithDescription:( NSString* )description_
{
    return [ [ self alloc ] initWithDescription: description_ ];
}

+(id)error
{
    return [ self new ];
}

@end

@implementation SCNoItemError

-(id)init
{
    return [ super initWithDescription: @"Item was not found" ];
}

@end

@implementation SCNoFieldError
@end

@implementation SCInvalidPathError

-(id)init
{
    return [ super initWithDescription: @"Item path is invalid" ];
}

@end

@implementation SCInvalidItemIdError

@synthesize itemId = _itemId;

-(id)initWithItemId:( NSString* )itemId_
{
    NSString* description_ = [ [ NSString alloc ] initWithFormat: @"Item id: \"%@\" has invalid format", itemId_ ];
    self = [ super initWithDescription: description_ ];
    if ( self )
    {
        self.itemId = itemId_;
    }
    return self;
}

+(id)errorWithItemId:( NSString* )itemId_
{
    return [ [ self alloc ] initWithItemId: itemId_ ];
}

-(id)copyWithZone:( NSZone* )zone_
{
    SCInvalidItemIdError* result_ = [ super copyWithZone: zone_ ];

    result_->_itemId = [ self.itemId copyWithZone: zone_ ];

    return result_;
}

@end

@implementation SCNetworkError
@end

@implementation SCBackendError
@end

@implementation SCResponseError

@synthesize statusCode
, message
, type
, method;

-(id)copyWithZone:( NSZone* )zone_
{
    SCResponseError* result_ = [ super copyWithZone: zone_ ];

    if ( result_ )
    {
        result_.statusCode = self.statusCode;
        result_->message    = [ self.message copyWithZone: zone_ ];
        result_->type       = [ self.type    copyWithZone: zone_ ];
        result_->method     = [ self.method  copyWithZone: zone_ ];
    }

    return result_;
}

@end

@implementation SCInvalidResponseFormatError

@synthesize responseData;

-(id)copyWithZone:( NSZone* )zone_
{
    SCInvalidResponseFormatError* result_ = [ super copyWithZone: zone_ ];

    if ( result_ )
    {
        result_->responseData = [ self.responseData copyWithZone: zone_ ];
    }

    return result_;
}

@end

@implementation SCNotImageFound
@end
