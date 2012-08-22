#import <Foundation/Foundation.h>
#include <AddressBook/ABAddressBook.h>


#ifndef __IPHONE_6_0
    enum ABAuthorizationStatusEnum
    {
        kABAuthorizationStatusNotDetermined = 0,
        kABAuthorizationStatusRestricted,
        kABAuthorizationStatusDenied,
        kABAuthorizationStatusAuthorized
    };
    typedef CFIndex ABAuthorizationStatus;
#endif //__IPHONE_6_


@protocol SCAddressBookOwner;
@class SCAddressBook;

typedef void(^SCAddressBookOnCreated)(SCAddressBook* book_, ABAuthorizationStatus status_, NSError* error_);
typedef void(^SCAddressBookSuccessCallback)( SCAddressBook* book_ );
typedef void(^SCAddressBookErrorCallback)(ABAuthorizationStatus status_, NSError* error_);

@interface SCAddressBookFactory : NSObject

+(void)asyncAddressBookWithOnCreatedBlock:( SCAddressBookOnCreated )callback_;
+(void)asyncAddressBookWithSuccessBlock:( SCAddressBookSuccessCallback )onSuccess_
                          errorCallback:( SCAddressBookErrorCallback )onFailure_;


+(NSString*)bookStatusToString:( ABAuthorizationStatus) status_;


@end
