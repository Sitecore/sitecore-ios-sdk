//
//  SCApiContext.h
//  SCApiContext
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#include <SitecoreMobileSDK/SCItemReaderScopeType.h>
#include <SitecoreMobileSDK/SCItemReaderRequestType.h>
#include <SitecoreMobileSDK/SCAsyncOpDefinitions.h>
#include <SitecoreMobileSDK/SCWebApiVersion.h>

#import <Foundation/Foundation.h>

@class SCItem;
@class SCField;
@class SCEditItemsRequest;
@class SCCreateItemRequest;
@class SCItemsReaderRequest;
@class SCCreateMediaItemRequest;
@class SCTriggeringRequest;
@class SCFieldImageParams;
@class SCHTMLReaderRequest;

@class SCRemoteApi;
@class SCItemsReaderRequest;
@class SCExtendedApiContext;

@protocol SCItemSource;


/**
 The SCApiContext object provides support to perform the loading of system Items and their Fields from the backend.
 
 All methods of this class can be divided into two general types.
 
 First type  - Asynchronous methods which used to load data from the backend. All such methods returns a block with SCAsyncOp type as a result.
 
 Second type - synchronous "getters" methods, which can be used for accessing loaded Items and Fields which are still in the memory.
 
 SCApiContext object does not owns loaded items and fields, so they will be immediately released if you does not owns them.
 
 Items ( SCItem objects ) owns their descendant items and fields ( SCField objects ).
 
 All methods of this class is not thread safe and they should be called exceptionally from one thread (main thread suggested)
 */
@interface SCApiContext : NSObject


+ (id)contextWithHost:(NSString*)host;

+ (id)contextWithHost:(NSString *)host
                login:(NSString *)login
             password:(NSString *)password;

/**
 Returns SCApiContext's instance with a Sitecore Item Web Api host.
 Used to read items and fields as anonimous user from Sitecore site.
 
 You can create the only one SCApiContext object for the one set of options host, login and password, it means that if you try to create another SCApiContext object with the same host, login and password, just previous created SCApiContext object for this host will be returned.
 
 It can be expressed this an example: [SCApiContext contextWithHost: someHost] == [SCApiContext contextWithHost: someHost] returns TRUE.
 
 But SCApiContext object is not a "singleton", if you have no any SCItem, SCField and SCReader object in memory and any other entity does not retain SCApiContext object - it will be released.
 
 @param host the host of Sitecore Item Web Api, example: "http://mobilesdk.sc-demo.net:80"
 @return existing SCApiContext object for the given host or new created one if it doesn't exist
 */
+ (id)contextWithHost:(NSString*)host
              version:(SCWebApiVersion)webApiVersion;

/**
 Returns SCApiContext's instance with a Sitecore Item Web Api host, login and password.
 Used to read items and fields as authenticated user with given login and password from Sitecore site.
 
 You can create the only one SCApiContext object for the one set of options: host, login and password, it means that if you try to create another SCApiContext object with the same host, login and passwor, just previous created SCApiContext object for this host will be returned.
 
 It can be expressed this an example: [SCApiContext contextWithHost: someHost] == [SCApiContext contextWithHost: someHost] returns TRUE.
 
 But SCApiContext object is not a "singleton", if you have no any SCItem, SCField and SCReader object in memory and any other entity does not retain SCApiContext object - it will be released.
 
 @param host the host of Sitecore Item Web Api. For example: "http://mobilesdk.sc-demo.net:80"
 @param login the login of user to the Sitecore site
 @param password the password of user to the Sitecore site
 @param website one of websites specified in the "web.config". It must start with slash. For example, "/sitecore/shell".
 */
+ (id)contextWithHost:(NSString *)host  //mobilesdk.sc-demo.net/
                login:(NSString *)login
             password:(NSString *)password
              version:(SCWebApiVersion)webApiVersion;

@property(nonatomic, readonly) SCExtendedApiContext *extendedApiContext;

/**
 The site used to request Sitecore items, default is "nil".
 */
@property(nonatomic) NSString *defaultSite;

/**
 The language used to request Sitecore items, default is "en".
 */
@property(nonatomic) NSString *defaultLanguage;

/**
 The database used to request Sitecore items, default is "web".
 */
@property(nonatomic) NSString *defaultDatabase;

/**
 The version used to request Sitecore items, default is "nil" which means the latest version will be retrieved.
 */
@property(nonatomic) NSString *defaultItemVersion;

/**
 The default life time in cache after which object in cache becames old. Default value is ten minutes
 */
@property(nonatomic) NSTimeInterval defaultLifeTimeInCache;

/**
 The default life time in cache after which object in cache becames old. Default value is one monce
 */
@property(nonatomic) NSTimeInterval defaultImagesLifeTimeInCache;

/**
 The Sitecore system languages, by default is nil.
 To read Sitecore system languages call -[SCApiContext systemLanguagesReader] method.
 */
@property(nonatomic) NSSet *systemLanguages;


/**
 This method wipes out all cached items. Cached requests won't be affected though.
 Use this method if you need to perform a memory intensive operation efficiently. It should help you avoiding unwanted memory warning interrupts.
 */
-(void)cleanupItemsCache;

/**
 Used to check if a user with given name and password exists on the instance.
 The callback gets NSNull on success and nil on error.
 
 @param - name of the site, set up on the instance. Site name must start with a slash. For example, @"/sitecore/shell". Pass "nil" for the default site.
 
 @return SCAsyncOp block. Call it to get the expected result.
 */
- (SCAsyncOp)credentialsCheckerForSite:( NSString* )site;

/**
 Used to load Sitecore system languages from the backend.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is NSSet of strings or nil if error happens.
 */
- (SCAsyncOp)systemLanguagesReader;

/**
 Used to load items from the backend according to the properties of SCItemsReaderRequest object
 @param request SCItemsReaderRequest object which provides a bunch of options to load items from the backend or getting already loaded items
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is NSArray of SCItem objects or nil if error happens.
 */
- (SCAsyncOp)itemsReaderWithRequest:(SCItemsReaderRequest *)request;

/**
 Returns SCItem object with a given items's path if such system item was loaded and still exists in the memory
 @param path system item's path, -[SCItem path] or string (for example "/sitecore/content").
 @return SCItem object or nil if such item does not exists.
 */
- (SCItem *)itemWithPath:(NSString *)path;

- (SCItem *)itemWithPath:(NSString *)path
                  source:( id<SCItemSource> )itemSource;



/**
 Returns SCItem object with a given items's ID if such system item was loaded and still exists in the memory
 @param itemId system item's id, -[SCItem itemId] can be used.
 @return SCItem object or nil if such item does not exists.
 */
- (SCItem *)itemWithId:(NSString *)itemId;

- (SCItem *)itemWithId:(NSString *)itemId
                source:( id<SCItemSource> )itemSource;

/**
 Used to load item from the backend with a given system item ID
 @param itemId system item's id, -[SCItem itemId] can be used.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is SCItem object or nil if error happens.
 
 If Sitecore Item Web Api(backend) does not return any item, SCNoItemError error will be returned by SCAsyncOpResult handler.
 */
- (SCAsyncOp)itemReaderForItemId:(NSString *)itemId;

/**
 Used for the reading item from a backend with a given system item path
 @param path system item's path, -[SCItem path] or string (for example "/sitecore/content").
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is SCItem object or nil if error happens.
 
 SCAsyncOpResult handler may return such errors:
 
 - SCNoItemError                - if Sitecore Item Web Api(backend) does not return any item.
 
 - SCInvalidPathError           - invalid path argument was passed.
 
 - SCNetworkError               - network error happens.
 
 - SCInvalidResponseFormatError - response can not be processed
 */
- (SCAsyncOp)itemReaderForItemPath:(NSString *)path;

/**
 Returns SCField object for the given items's ID and field's name if such field was loaded and the item has a field with such name
 @param fieldName the name of item's field name, see [SCField name]
 @param itemId system item's id, -[SCItem itemId] can be used.
 @return SCField object or nil if such field does not exists.
 */
- (SCField*)fieldWithName:(NSString *)fieldName
                   itemId:(NSString *)itemId;

- (SCField*)fieldWithName:(NSString *)fieldName
                   itemId:(NSString *)itemId
                   source:( id<SCItemSource> )itemSource;

/**
 Returns loaded fields for the given item.
 @param itemId system item's id, -[SCItem itemId] can be used.
 @return loaded fields for the given item. It is a NSDictionary of SCField objects by field's names.
 */
- (NSDictionary*)readFieldsByNameForItemId:(NSString *)itemId;

- (NSDictionary*)readFieldsByNameForItemId:(NSString *)itemId
                                    source:( id<SCItemSource> )itemSource;

/**
 Used to load item with fields by the system item id.
 @param fieldNames the set of field's names which will be read with the item. Each field's name in set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @param itemId system item's id, -[SCItem itemId] can be used.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is SCItem object or nil if error happens.
 
 SCAsyncOpResult handler may return such errors:
 
 - SCNoItemError                - if Sitecore Item Web Api(backend) does not return any item.
 
 - SCNetworkError               - if network error happens.
 
 - SCInvalidResponseFormatError - response can not be processed
 */
- (SCAsyncOp)itemReaderWithFieldsNames:(NSSet *)fieldNames
                                itemId:(NSString *)itemId;

- (SCAsyncOp)itemReaderWithFieldsNames:(NSSet *)fieldNames
                            itemSource:( id<SCItemSource> )itemSource
                                itemId:(NSString *)itemId;
/**
 Used to load item with fields by the system item id.
 @param fieldNames the set of field's names which will be read with the item. Each field's name in set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @param path system item's path, -[SCItem path] or string (for example "/sitecore/content").
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is SCItem object or nil if error happens.
 
 SCAsyncOpResult handler may return such errors:
 
 - SCNoItemError                - if Sitecore Item Web Api(backend) does not return any item.
 
 - SCInvalidPathError           - invalid path argument was passed.
 
 - SCNetworkError               - if network error happens.
 
 - SCInvalidResponseFormatError - response can not be processed
 */
- (SCAsyncOp)itemReaderWithFieldsNames:(NSSet *)fieldNames
                              itemPath:(NSString *)path;

/**
 Used to create item according to the properties of SCCreateItemRequest object
 @param createItemRequest SCCreateItemRequest object which provides a bunch of options to create item
 @return SCAsyncOp block. Call it to create item. The SCAsyncOpResult handler's result is SCItem object or nil if error happens.
 */
- (SCAsyncOp)itemCreatorWithRequest:(SCCreateItemRequest *)createItemRequest;

/**
 Used to edit existing items according to the properties of SCEditItemsRequest object
 @param editItemsRequest SCEditItemsRequest object which provides a bunch of options to edit items
 @return SCAsyncOp block. Call it to edit items. The SCAsyncOpResult handler's result is NSArray of edited SCItem objects or nil if error happens.
 */
- (SCAsyncOp)editItemsWithRequest:(SCEditItemsRequest *)editItemsRequest;

/**
 Used to remove existing items found with SCItemsReaderRequest request.
 @param request SCItemsReaderRequest object which provides a bunch of options to find items to remove.
 @return SCAsyncOp block. Call it to edit items. The SCAsyncOpResult handler's result is NSArray of removed items ids or nil if error happens.
 */
- (SCAsyncOp)removeItemsWithRequest:(SCItemsReaderRequest *)request;

/**
 Used to create media item according to the properties of SCCreateMediaItemRequest object
 @param createMediaItemRequest SCCreateMediaItemRequest object which provides a bunch of options to create media item
 @return SCAsyncOp block. Call it to create media item. The SCAsyncOpResult handler's result is SCItem object or nil if error happens.
 */
- (SCAsyncOp)mediaItemCreatorWithRequest:(SCCreateMediaItemRequest *)createMediaItemRequest;

/**
 Used to load item's children by the system item id.
 @param itemId system item's id, -[SCItem itemId] can be used.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is NSArray of SCItem objects or nil if error happens.
 */
- (SCAsyncOp)childrenReaderWithItemId:(NSString *)itemId;

/**
 Used to load item's children by the system item id.
 @param path system item's path, -[SCItem path] or string (for example "/sitecore/content").
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is NSArray of SCItem objects or nil if error happens.
 
 SCAsyncOpResult handler may return such errors:
 
 - SCInvalidPathError           - invalid path argument was passed.
 
 - SCNetworkError               - if network error happens.
 
 - SCInvalidResponseFormatError - response can not be processed
 */
- (SCAsyncOp)childrenReaderWithItemPath:(NSString *)path;

/**
 Used to load image with the image path, see [SCImageField imagePath].
 @param path image's path. Image with http://{WebApiHost}/~/media{path}.ashx will be loaded.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is UIImage object or nil if error happens.
 */
- (SCAsyncOp)imageLoaderForSCMediaPath:(NSString *)path;

/**
 Used to load image with the image path, see [SCImageField imagePath] with additional parameters.
 @param path image's path. Image with http://{WebApiHost}/~/media{path}.ashx will be loaded.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is UIImage object or nil if error happens.
 */
- (SCAsyncOp)imageLoaderForSCMediaPath:(NSString *)path
                           imageParams:( SCFieldImageParams* )params;

/**
 Used to request rendering HTML for rendering with request
 */
- (SCAsyncOp)renderingHTMLReaderWithRequest:(SCHTMLReaderRequest *)request;

/**
 Used to request rendering HTML for rendering with pointed id and item id presented using rendering.
 Usd defauld language and database of SCApiContext
 @param renderingId - id of rendering which you want to request
 @param sourceId - item's id for render using rendering with renderingId
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is NSString object or nil if error happens.
 */
- (SCAsyncOp)renderingHTMLLoaderForRenderingWithId:(NSString *)renderingId
                                          sourceId:(NSString *)sourceId;

/**
 Used to trigger a goal or a campain with the given request
 
 @param request A triggering request. See SCTrafficTriggeringRequest and SCCampaignTriggeringRequest for details
 
 @return SCAsyncOp block. Call it to trigger either a goal or a campaign. The SCAsyncOpResult handler's result is an NSString that contains the rendering of the item (an HTML web page).
 */
- (SCAsyncOp)triggerLoaderForRequest:( SCTriggeringRequest* )request;

@end
