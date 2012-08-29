#import <Foundation/Foundation.h>

@interface SCSitecoreCredentials : NSObject

@property ( nonatomic ) NSString* login;
@property ( nonatomic ) NSString* password;

/**
 base64 encoded data
 */
@property ( nonatomic ) NSString* modulus;

/**
 base64 encoded data
 */
@property ( nonatomic ) NSString* exponent;


@property ( nonatomic, readonly ) NSString* encryptedLogin;
@property ( nonatomic, readonly ) NSString* encryptedPassword;


@end
