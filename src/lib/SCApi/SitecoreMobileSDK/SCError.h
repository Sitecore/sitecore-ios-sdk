#import <Foundation/Foundation.h>

/**
 Any SitecoreMobileSDK error has a type inherited from SCApiError class, see SCApiError inheritors for details.
 If Sitecore Mobile SDK error type is SCApiError ( [ error isMemberOfClass: [ SCApiError class ] ] == YES ), this is invalid behaviour, please contact Sitecore support team in such case to fix problem.
 */
@interface SCApiError : NSError

/**
 Constructs an error object with the sitecore SDK domain and default code.
 
 @param description A string to be stored in NSLocalizedDescriptionKey of -[NSError userInfo]
 */
-(instancetype)initWithDescription:( NSString* )description;


/**
 Constructs an error object with the sitecore SDK domain.
 
 @param description A string to be stored in NSLocalizedDescriptionKey of -[NSError userInfo]
 @param code The error code for the error.
 */
-(instancetype)initWithDescription:( NSString* )description
                              code:( NSInteger )code;


/**
 A lower level error for more precise diagnostics
 */
@property (nonatomic) NSError* underlyingError;


@end

/**
 The SCNoItemError error may happens with calling such method as [SCApiSession readItemOperationForItemId:] when Sitecore Item Web Api does not return any item
 */
@interface SCNoItemError : SCApiError
@end


/**
 The SCCreateItemError error is returned by [SCApiSession createItemsOperationWithRequest:] method in case of insufficient permissions or connectivity issues. Sitecore Item Web Api does not return any item
 */
@interface SCCreateItemError : SCApiError
@end

/**
 The SCNoFieldError error may happens when some field does not exist, see [SCItem readFieldsValuesOperationForFieldsNames:] method for details
 */
@interface SCNoFieldError : SCApiError
@end

/**
 The SCInvalidPathError error may happens at passing an invalid path argument to the method like: [SCApiSession readItemOperationForItemPath:]
 */
@interface SCInvalidPathError : SCApiError
@end

/**
 The SCInvalidItemIdError error may happens at passing an invalid item it argument to the method like: [SCApiSession readItemOperationForItemId:]
 */
@interface SCInvalidItemIdError : SCApiError

@property(nonatomic) NSString *itemId;

@end

/**
 The SCNetworkError error may happens if network errors occurs while a data loading
 */
@interface SCNetworkError : SCApiError
@end


/**
 The SCEncryptionError error occurs if the encryption data provider is not properly configured on the server side. See "Sitecore Item Web API 1.0 Developer's Guide" document for details
*/
@interface SCEncryptionError : SCApiError
@end

/**
 Any Backend error ( invalid response format or Sitecore Item Web Api error ) has type like SCBackendError, see SCBackendError inheritors for details.
 */
@interface SCBackendError : SCApiError
@end

/**
 The SCResponseError error may happen if Sitecore Item Web Api returns error on request instead of expected data, see SCResponseError properties for details
 */
@interface SCResponseError : SCBackendError

/**
 The statusCode code of Sitecore Item Web Api error, see Sitecore Item Web Api documentation for details
 */
@property(nonatomic) NSUInteger statusCode;
/**
 The error's message of Sitecore Item Web Api error, see Sitecore Item Web Api documentation for details
 */
@property(nonatomic) NSString *message;
/**
 The error's type of Sitecore Item Web Api error, see Sitecore Item Web Api documentation for details
 */
@property(nonatomic) NSString *type;
/**
 The Sitecore Item Web Api method which cause an error, see Sitecore Item Web Api documentation for details
 */
@property(nonatomic) NSString *method;

@end

/**
 The SCInvalidResponseFormatError error may happens if SCApi can not process the server response, you can inspect response using -[SCInvalidResponseFormatError responseData] property
 */
@interface SCInvalidResponseFormatError : SCBackendError

/**
 The invalid backend response SCApi can not process
 */
@property(nonatomic) NSData *responseData;

@end

/**
 The SCNotImageFound error may happens if SCApi can not process the server response as image, you can inspect response using -[SCInvalidResponseFormatError responseData] property
 */
@interface SCNotImageFound : SCInvalidResponseFormatError
@end


/**
 The SCTriggeringError occurs if a triggering request is not processed by the instance. This may happen when an item has no rendering available or due to connectivity issues.
 */
@interface SCTriggeringError : SCBackendError

/**
 Item's path in the content tree
 */
@property(nonatomic, readonly) NSString *itemPath;

/**
 The triggering action.
 - @"sc_trk" for goal triggering
 - @"sc_camp" for campaign triggering
 */
@property(nonatomic, readonly) NSString *actionType;


/**
 The trigger identifier.
 - Goal name for goal triggering
 - Campaign id for campaign triggering
 */
@property(nonatomic, readonly) NSString *actionValue;

@end
