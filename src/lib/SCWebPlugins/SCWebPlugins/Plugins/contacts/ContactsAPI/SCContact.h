#import <Foundation/Foundation.h>

#include <AddressBook/ABRecord.h>
#include <AddressBook/ABAddressBook.h>

@class SCAddressBook;


@interface SCContact : NSObject

@property ( nonatomic ) NSString* firstName;
@property ( nonatomic ) NSString* lastName;
@property ( nonatomic ) NSString* company;
@property ( nonatomic ) NSDate* birthday;
@property ( nonatomic ) NSArray*  emails;
@property ( nonatomic ) NSArray*  phones;
@property ( nonatomic ) NSArray*  sites;
@property ( nonatomic ) UIImage*  photo;
@property ( nonatomic ) ABRecordID contactInternalId;

@property ( nonatomic, readonly ) ABRecordRef      person;
@property ( nonatomic, readonly ) ABAddressBookRef addressBook;
@property ( nonatomic, readonly ) BOOL newContact;

-(id)initWithPerson:( ABRecordRef )person_
        addressBook:( SCAddressBook* )addressBook_;

-(id)initWithArguments:( NSDictionary* )args_
           addressBook:( SCAddressBook* )addressBook_;

-(NSDictionary*)toDictionary;
-(void)save;

@end
