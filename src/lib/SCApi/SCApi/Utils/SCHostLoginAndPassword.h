#import <Foundation/Foundation.h>

@interface SCHostLoginAndPassword : NSObject< NSCopying >

@property ( nonatomic, readonly ) NSString* host;
@property ( nonatomic, readonly ) NSString* login;
@property ( nonatomic, readonly ) NSString* password;

-(id)initWithHost:( NSString* )host
            login:( NSString* )login
         password:( NSString* )password;

@end
