#import <Foundation/Foundation.h>

@interface NSArray (ContactFieldsWithComponents)

+(NSArray*)scAddressesDictionariesWithJSON:( NSString* )addressesJSON_;

+(NSArray*)contactAddressesDictionariesWithJSON:( NSString* )addressesJSON_;

@end
