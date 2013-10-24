#import <Foundation/Foundation.h>

@interface SCWebApiConfig : NSObject

@property ( nonatomic ) NSString* webApiEndpoint       ; // -/item
@property ( nonatomic ) NSString* actionEndpoint       ; // -/action
@property ( nonatomic ) NSString* renderingHtmlAction  ; // GetRenderingHtml
@property ( nonatomic ) NSString* publicKeyAction      ; // GetPublicKey
@property ( nonatomic ) NSString* checkPasswordAction  ; // GetPublicKey

@property ( nonatomic ) NSString* pathSeparator; // "/"
@property ( nonatomic ) NSString* restArgsStart; // "?"
@property ( nonatomic ) NSString* restArgSeparator; // "&"
@property ( nonatomic ) NSString* restKeyValueSeparator; // "="

+(instancetype)webApiV1Config;

@end
