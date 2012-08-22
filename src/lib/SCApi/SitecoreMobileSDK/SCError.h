#import <Foundation/Foundation.h>

/**
 Any SitecoreMobileSDK error has a type inherited from SCError class, see SCError inheritors for details.
 If Sitecore Mobile SDK error type is SCError ( [ error isMemberOfClass: [ SCError class ] ] == YES ), this is invalid behaviour, please contact Sitecore support team in such case to fix problem.
 */
@interface SCError : NSError
@end

/**
 The SCNoItemError error may happens with calling such method as [SCApiContext itemReaderForItemId:] when Sitecore Item Web Api does not return any item
 */
@interface SCNoItemError : SCError
@end

/**
 The SCNoFieldError error may happens when some field does not exist, see [SCItem fieldsValuesReaderForFieldsNames:] method for details
 */
@interface SCNoFieldError : SCError
@end

/**
 The SCInvalidPathError error may happens at passing an invalid path argument to the method like: [SCApiContext itemReaderForItemPath:]
 */
@interface SCInvalidPathError : SCError
@end

/**
 The SCInvalidItemIdError error may happens at passing an invalid item it argument to the method like: [SCApiContext itemReaderForItemId:]
 */
@interface SCInvalidItemIdError : SCError

@property(nonatomic) NSString *itemId;

@end

/**
 The SCNetworkError error may happens if network errors occurs while a data loading
 */
@interface SCNetworkError : SCError
@end

/**
 Any Backend error ( invalid response format or Sitecore Item Web Api error ) has type like SCBackendError, see SCBackendError inheritors for details.
 */
@interface SCBackendError : SCError
@end

/**
 The SCResponseError error may happens if Sitecore Item Web Api returns error on request instead of expected data, see SCResponseError properties for details
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
 The SCNotImageFound error may happens if SCApi can not process the server response as image, you can inspect response using -[SCNotImageFound responseData] property
 */
@interface SCNotImageFound : SCInvalidResponseFormatError
@end
