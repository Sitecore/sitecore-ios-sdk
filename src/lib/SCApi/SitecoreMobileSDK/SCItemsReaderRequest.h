//
//  SCItemsReaderRequest.h
//  SCItemsReaderRequest
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#include <SitecoreMobileSDK/SCItemReaderScopeType.h>
#include <SitecoreMobileSDK/SCItemReaderRequestType.h>
#include <SitecoreMobileSDK/SCItemReaderRequestFlags.h>

#import <Foundation/Foundation.h>

#import "SCBaseItemRequest.h"

/**
 The SCItemsReaderRequest contains the set of params for the requested items from the backend.
 It used for [SCApiContext itemsReaderWithRequest:] method. All other loaders based on this method.
 */
@interface SCItemsReaderRequest : SCBaseItemRequest < NSCopying >

/**
 Specifies the set of the items which will be loaded.
 Possible values are: SCItemReaderSelfScope (self), SCItemReaderParentScope (parent) and SCItemReaderChildrenScope (children). By default, self is used.
 The order of the result items will be: first is the parent item, then the self item and the children items at last.
 This argument is ignored when [SCItemsReaderRequest requestType] is SCItemReaderRequestQuery
 */
@property(nonatomic) SCItemReaderScopeType scope;

/**
 Request string of the items.
 Has a different meaning depends on [SCItemsReaderRequest requestType]
 
 If [SCItemsReaderRequest requestType] is
 
 - SCItemReaderRequestItemId   - request is the item's id, example: "{C3713481-AF86-4E33-9BE9-D53EFE03E518}"
 
 - SCItemReaderRequestItemPath - request is the item's path, example: "/sitecore/content"
 
 - SCItemReaderRequestQuery    - request is the Sitecore query, example: "/sitecore/content/nicam/child::*[@@templatename='Site Section']"
 */
@property(nonatomic,strong) NSString *request;

/**
 Specifies the type of [SCItemsReaderRequest request] option, see [SCItemsReaderRequest request] for details.
 If [SCItemsReaderRequest requestType] is a SCItemReaderRequestQuery, it is a similar to [SCItemsReaderRequest flags] is setted to SCItemReaderRequestIngnoreCache.
 */
@property(nonatomic) SCItemReaderRequestType requestType;

/**
 The set of the field's names which will be read with each item. Each field's name in the set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 */
@property(nonatomic,strong) NSSet *fieldNames;

/**
 Additional request flags:
 
 - SCItemReaderRequestIngnoreCache - means that the request will ignore loaded items, and the request to backend will be performed.
 
 - SCItemReaderRequestReadFieldsValues - for each field specified in fieldNames set - [SCField fieldValue] will be loaded before you've got a result with the items.
 */
@property(nonatomic) SCItemReaderRequestFlags flags;

/**
 The number of paged, used only if [SCItemsReaderRequest pageSize] is specified. Indexing starts from zero.
 */
@property(nonatomic) NSUInteger page;

/**
 The page size of items, used for paged items loading. For example if you need to read only a second item for the given request, specify [SCItemsReaderRequest pageSize] as 1 and [SCItemsReaderRequest page] is 1.
 */
@property(nonatomic) NSUInteger pageSize;

/**
 The life time in cache after which object in cache becames old
 */
@property(nonatomic) NSTimeInterval lifeTimeInCache;

/**
 This method is usefull for loading one item by the item's id.
 Creates SCItemsReaderRequest object with following fields:
 
 [SCItemsReaderRequest scope]   is equal to SCItemReaderSelfScope
 
 [SCItemsReaderRequest request] is equal to itemId argument
 
 [SCItemsReaderRequest requestType] is equal to SCItemReaderRequestItemId
 
 [SCItemsReaderRequest fieldNames] is equal to empty set
 
 [SCItemsReaderRequest flags] is equal to zero
 
 [SCItemsReaderRequest page] is equal to zero
 
 [SCItemsReaderRequest pageSize] is equal to zero
 
 @param itemId system item's id, -[SCItem itemId] can be used.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @return SCItemsReaderRequest object, used for [SCApiContext itemsReaderWithRequest:] method.
 */
+ (id)requestWithItemId:(NSString *)itemId;

/**
 This method is usefull for loading one item by the item's id.
 Creates SCItemsReaderRequest object with following fields:
 
 [SCItemsReaderRequest scope]   is equal to SCItemReaderSelfScope
 
 [SCItemsReaderRequest request] is equal to itemId argument
 
 [SCItemsReaderRequest requestType] is equal to SCItemReaderRequestItemId
 
 [SCItemsReaderRequest fieldNames] is equal to fieldNames argument
 
 [SCItemsReaderRequest flags] is equal to zero
 
 [SCItemsReaderRequest page] is equal to zero
 
 [SCItemsReaderRequest pageSize] is equal to zero
 
 @param itemId system item's id, -[SCItem itemId] can be used.
 @param fieldNames The set of the field's names which will be read with each item. Each field's name in set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @return SCItemsReaderRequest object, used for [SCApiContext itemsReaderWithRequest:] method.
 */
+ (id)requestWithItemId:(NSString *)itemId
            fieldsNames:(NSSet *)fieldNames;

/**
 This method is usefull for loading items with [SCItemsReaderRequest scope] by the item's id.
 Creates SCItemsReaderRequest object with following fields:
 
 [SCItemsReaderRequest scope]   is equal to scope argument
 
 [SCItemsReaderRequest request] is equal to itemId argument
 
 [SCItemsReaderRequest requestType] is equal to SCItemReaderRequestItemId
 
 [SCItemsReaderRequest fieldNames] is equal to fieldNames argument
 
 [SCItemsReaderRequest flags] is equal to zero
 
 [SCItemsReaderRequest page] is equal to zero
 
 [SCItemsReaderRequest pageSize] is equal to zero
 
 @param itemId system item's id, -[SCItem itemId] can be used.
 @param fieldNames The set of the field's names which will be read with each item. Each field's name in set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @param scope Specifies the set of the items which will be loaded. See [SCItemsReaderRequest scope] for details
 @return SCItemsReaderRequest object, used for [SCApiContext itemsReaderWithRequest:] method.
 */
+ (id)requestWithItemId:(NSString *)itemId
            fieldsNames:(NSSet *)fieldNames
                  scope:(SCItemReaderScopeType)scope;

/**
 This method is usefull for loading one item by the item's id.
 Creates SCItemsReaderRequest object with following fields:
 
 [SCItemsReaderRequest scope]   is equal to SCItemReaderSelfScope
 
 [SCItemsReaderRequest request] is equal to itemPath argument
 
 [SCItemsReaderRequest requestType] is equal to SCItemReaderRequestItemId
 
 [SCItemsReaderRequest fieldNames] is equal to empty set
 
 [SCItemsReaderRequest flags] is equal to zero
 
 [SCItemsReaderRequest page] is equal to zero
 
 [SCItemsReaderRequest pageSize] is equal to zero
 
 @param itemPath system item's path, -[SCItem path] or string like "/sitecore/content" for example can be used.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @return SCItemsReaderRequest object, used for [SCApiContext itemsReaderWithRequest:] method.
 */
+ (id)requestWithItemPath:(NSString *)itemPath;

/**
 This method is usefull for loading one item by the item's path.
 Creates SCItemsReaderRequest object with following fields:
 
 [SCItemsReaderRequest scope]   is equal to SCItemReaderSelfScope
 
 [SCItemsReaderRequest request] is equal to itemPath argument
 
 [SCItemsReaderRequest requestType] is equal to SCItemReaderRequestItemPath
 
 [SCItemsReaderRequest fieldNames] is equal to fieldNames argument
 
 [SCItemsReaderRequest flags] is equal to zero
 
 [SCItemsReaderRequest page] is equal to zero
 
 [SCItemsReaderRequest pageSize] is equal to zero
 
 @param itemPath system item's path, -[SCItem path] or string like "/sitecore/content" for example can be used.
 @param fieldNames The set of the field's names which will be read with each item. Each field's name in set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @return SCItemsReaderRequest object, used for [SCApiContext itemsReaderWithRequest:] method.
 */
+ (id)requestWithItemPath:(NSString *)itemPath
              fieldsNames:(NSSet *)fieldNames;

/**
 This method is usefull for loading items with [SCItemsReaderRequest scope] by the item's path.
 Creates SCItemsReaderRequest object with following fields:
 
 [SCItemsReaderRequest scope]   is equal to scope argument
 
 [SCItemsReaderRequest request] is equal to itemPath argument
 
 [SCItemsReaderRequest requestType] is equal to SCItemReaderRequestItemPath
 
 [SCItemsReaderRequest fieldNames] is equal to fieldNames argument
 
 [SCItemsReaderRequest flags] is equal to zero
 
 [SCItemsReaderRequest page] is equal to zero
 
 [SCItemsReaderRequest pageSize] is equal to zero
 
 @param itemPath system item's path, -[SCItem path] or string like "/sitecore/content" for example can be used.
 @param fieldNames The set of the field's names which will be read with each item. Each field's name in set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @param scope Specifies the set of the items which will be loaded. See [SCItemsReaderRequest scope] for details
 @return SCItemsReaderRequest object, used for [SCApiContext itemsReaderWithRequest:] method.
 */
+ (id)requestWithItemPath:(NSString *)itemPath
              fieldsNames:(NSSet *)fieldNames
                    scope:(SCItemReaderScopeType)scope;

@end
