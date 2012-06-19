#import <Foundation/Foundation.h>

@interface SCContactAddress : NSObject

@property ( nonatomic ) NSString* street;
@property ( nonatomic ) NSString* city;
@property ( nonatomic ) NSString* state;
@property ( nonatomic ) NSString* ZIP;
@property ( nonatomic ) NSString* country;

+(id)contactAddressWithComponents:( NSDictionary* )fields_;
+(id)contactAddressWithContactValueDict:( NSDictionary* )dict_;

-(NSDictionary*)contactApiDict;
-(NSDictionary*)toJSONDict;

@end
