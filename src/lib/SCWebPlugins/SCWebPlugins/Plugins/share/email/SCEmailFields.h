#import <Foundation/Foundation.h>

@interface SCEmailFields : NSObject

@property ( nonatomic, readonly ) NSArray*  toRecipients;
@property ( nonatomic, readonly ) NSArray*  ccRecipients;
@property ( nonatomic, readonly ) NSArray*  bccRecipients;
@property ( nonatomic, readonly ) NSString* subject;
@property ( nonatomic, readonly ) NSString* body;
@property ( nonatomic, readonly ) BOOL      isHTML;

+(id)emailFieldsWithComponents:( NSDictionary* )components_;

@end
