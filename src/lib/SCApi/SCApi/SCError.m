#import "SCError.h"
#import "SCTriggeringImplRequest.h"

@implementation SCError

@synthesize underlyingError = _underlyingError;

+(NSString*)errorDomain
{
    static NSString* errorDomain_ = nil;

    if ( !errorDomain_ )
    {
        static NSString* const appName_ = @"net.sitecore.mobileSDK";
        errorDomain_ = [ appName_ stringByAppendingString: @".ErrorDomain" ];
    }

    return errorDomain_;
}

-(id)initWithDescription:( NSString* )description_ code:( NSInteger )code_
{
    NSDictionary* userInfo_ = @{ NSLocalizedDescriptionKey : description_ };
    return [ super initWithDomain: [ [ self class ] errorDomain ] code: code_
                         userInfo: userInfo_ ];
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

@end

@implementation SCNoItemError

-(id)init
{
    return [ super initWithDescription: NSLocalizedString( @"ITEM_WAS_NOT_FOUND", nil ) ];
}

@end

@implementation SCCreateItemError
@end


@implementation SCNoFieldError
@end

@implementation SCInvalidPathError

-(id)init
{
    return [ super initWithDescription: NSLocalizedString( @"ITEM_PATH_IS_INVALID", nil ) ];
}

@end

@implementation SCInvalidItemIdError

-(id)initWithItemId:( NSString* )itemId_
{
    NSString* description_ = [ [ NSString alloc ] initWithFormat: @"Item id: \"%@\" has invalid format", itemId_ ];
    self = [ super initWithDescription: description_ ];
    if ( self )
    {
        self->_itemId = itemId_;
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

    if ( result_ )
    {
        result_->_itemId = [ self->_itemId copyWithZone: zone_ ];
    }

    return result_;
}

@end

@implementation SCNetworkError
@end

@implementation SCBackendError
@end

@implementation SCResponseError

-(id)copyWithZone:( NSZone* )zone_
{
    SCResponseError* result_ = [ super copyWithZone: zone_ ];

    if ( result_ )
    {
        result_.statusCode = self.statusCode;
        result_->_message    = [ self->_message copyWithZone: zone_ ];
        result_->_type       = [ self->_type    copyWithZone: zone_ ];
        result_->_method     = [ self->_method  copyWithZone: zone_ ];
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

@implementation SCEncryptionError
@end

@interface SCTriggeringError()

@property (nonatomic) NSString *itemPath;
@property (nonatomic) NSString *actionType;
@property (nonatomic) NSString *actionValue;
@property (nonatomic) NSError* underlyingError;

@end

@implementation SCTriggeringError
@end
