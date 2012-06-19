#import <Foundation/Foundation.h>

@interface NSDictionary (ContactAddressExtensions)

+(NSDictionary*)mapJSONToAddresses;

-(NSDictionary*)addressesDictToJSONDict;
-(NSDictionary*)JSONDictToAddressesDict;

@end
