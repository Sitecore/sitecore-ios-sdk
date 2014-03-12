//
//  SCPagedItems.h
//  SCPagedItems
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#include <SitecoreMobileSDK/SCAsyncOpDefinitions.h>

#import <Foundation/Foundation.h>

@class SCItem;
@class SCApiSession;
@class SCReadItemsRequest;

/**
 The SCPagedItems object provides methods for paged loading of the items, it is very usefull if it is expected a lot of items for the given request and the application try to safe the memory and time for reading them.
 SCPagedItems object owns all the loaded items.

 SCPagedItems instance has three general methods: first to get already loaded items, second - to load an expected count of the items and third - to load an item by the item's position index.

 All methods of this class is not thread safe and they should be called exceptionally from one thread (main thread suggested)
 */
@interface SCPagedItems : NSObject

/**
 The SCApiSession object used in creating SCPagedItems object.
 */
@property(nonatomic,readonly) SCApiSession *apiSession;
/**
 The size of the page used to load of items with paging, you can select any positive reasonable and convenient page size for your application.
 */
@property(nonatomic,readonly) NSUInteger pageSize;

/**
 Creates SCPagedItems object.
 @param apiSession SCApiSession object which will be used to load items, should not be nil.
 @param pageSize The size of the page used to load of items, you can select any positive reasonable and convenient page size for your application. Used at constructing SCReadItemsRequest object, see [SCReadItemsRequest pageSize].
 @param query Query string used at constructing SCReadItemsRequest object, see [SCReadItemsRequest request] and [SCReadItemsRequest requestType] for details.
 @return SCPagedItems instance.
 */
+ (id)pagedItemsWithApiSession:(SCApiSession *)apiSession
                      pageSize:(NSUInteger)pageSize
                         query:(NSString *)query;

/**
 Creates SCPagedItems object.
 @param apiSession SCApiSession object which will be used to load items, should not be nil.
 @param request Request used to load items by pages. Please, do not forget to set up the pageSize for request.
 @return SCPagedItems instance.
 */
+ (id)pagedItemsWithApiSession:(SCApiSession *)apiSession
                       request:(SCReadItemsRequest *)request;

/**
 Returns the SCItem object for the given index.
 @param index item's position index.
 @return SCItem object or nil if item was not loaded for the given index.
 */
- (SCItem*)itemForIndex:(NSUInteger)index;

/**
 Used to load expected item count for the given request.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is NSNumber object or nil if error happens.

 SCAsyncOpResult handler may return such errors:

 - SCNetworkError               - if network errors happens.

 - SCInvalidResponseFormatError - response can not be processed
 */
- (SCAsyncOp)readItemsTotalCountOperation;
- (SCExtendedAsyncOp)readItemsTotalCountExtendedOperation;

/**
 Used to load item for the given index.
 @param index item's position index.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is SCItem object or nil if error happens.

 SCAsyncOpResult handler may return such errors:

 - SCNetworkError               - if network errors happens.

 - SCInvalidResponseFormatError - response can not be processed
 */
- (SCAsyncOp)readItemOperationForIndex:(NSUInteger)index;
- (SCExtendedAsyncOp)readItemExtendedOperationForIndex:(NSUInteger)index;

@end
