#import <Foundation/Foundation.h>
#include <AddressBook/ABAddressBook.h>

@interface SCAddressBook : NSObject

-(id)initWithRawBook:( ABAddressBookRef )CF_CONSUMED rawBook_;
@property ( nonatomic, readonly ) CF_RETURNS_NOT_RETAINED ABAddressBookRef rawBook;

@end
