#import <Foundation/Foundation.h>

@interface SCSitecoreCredentials : NSObject

@property ( nonatomic ) NSString* login;
@property ( nonatomic ) NSString* password;
@property ( nonatomic ) NSString* modulus;
@property ( nonatomic ) NSString* exponent;

@property ( nonatomic, readonly ) NSString* encryptedPassword;

@end
