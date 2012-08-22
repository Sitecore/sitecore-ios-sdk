#import "SCHostLoginAndPassword.h"

@interface SCHostLoginAndPassword ()

@property ( nonatomic ) NSString* host;
@property ( nonatomic ) NSString* login;
@property ( nonatomic ) NSString* password;

@end

@implementation SCHostLoginAndPassword

-(id)copyWithZone:( NSZone* )zone_
{
    SCHostLoginAndPassword* result_ = [ [ [ self class ] allocWithZone: zone_ ] init ];

    if ( result_ )
    {
        result_.host     = [ self->_host     copyWithZone: zone_ ];
        result_.login    = [ self->_login    copyWithZone: zone_ ];
        result_.password = [ self->_password copyWithZone: zone_ ];
    }

    return result_;
}

-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_
{
    self = [ super init ];

    if ( self )
    {
        self->_host     = host_    ?:@"";
        self->_login    = login_   ?:@"";
        self->_password = password_?:@"";
    }

    return self;
}

-(BOOL)isEqual:( SCHostLoginAndPassword* )other_
{
    if ( other_ == self )
        return YES;

    if ( !other_ || ![ other_ isKindOfClass: [ self class ] ] )
        return NO;

    return [ self isEqualToHostLoginAndPassword: other_ ];
}

-(BOOL)isEqualToHostLoginAndPassword:( SCHostLoginAndPassword* )other_
{
    if ( self == other_ )
        return YES;

    return [ self->_host     isEqualToString: other_.host     ]
        && [ self->_login    isEqualToString: other_.login    ]
        && [ self->_password isEqualToString: other_.password ];
}

-(NSUInteger)hash
{
    return [ self.host hash ];
}

@end
