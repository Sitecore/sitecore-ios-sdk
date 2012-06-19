#import <AddressBook/AddressBook.h>

#import <Foundation/Foundation.h>

@interface SCContactField : NSObject

@property ( nonatomic, readonly ) NSString* name;
@property ( nonatomic, readonly ) ABPropertyID propertyID;

@property ( nonatomic, strong ) id value;
@property ( nonatomic, readonly ) NSString* jsonValue;

+(id)contactFieldWithName:( NSString* )name_
               propertyID:( ABPropertyID )propertyID_;

-(void)readPropertyFromRecord:( ABRecordRef )record_;
-(void)setPropertyFromValues:( NSDictionary* )components_
                    toRecord:( ABRecordRef )record_;

@end
