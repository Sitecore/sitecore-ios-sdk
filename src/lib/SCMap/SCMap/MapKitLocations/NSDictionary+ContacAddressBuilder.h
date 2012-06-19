#import <Foundation/Foundation.h>

@interface NSDictionary (ContacAddressBuilder)

+(id)contactAddressWithStreet:( NSString* )street_
                         city:( NSString* )city_
                        state:( NSString* )state_
                          ZIP:( NSString* )ZIP_
                      country:( NSString* )country_;

@end
