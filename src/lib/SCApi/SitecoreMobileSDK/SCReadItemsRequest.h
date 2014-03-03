//
//  SCReadItemsRequest.h
//  SCReadItemsRequest
//
//  Created on 1/31/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#include "SCReadItemsScopeType.h"
#include "SCReadItemsRequestType.h"
#include "SCReadItemsRequestFlags.h"

#import <Foundation/Foundation.h>

#import "SCBaseItemRequest.h"

/**
 The SCReadItemsRequest contains the set of params for the requested items from the backend.
 It used for [SCApiSession readItemsOperationWithRequest:] method. All other loaders based on this method.
 */
@interface SCReadItemsRequest : SCBaseItemRequest < NSCopying >

/**
 Specifies the set of the items which will be loaded.
 Possible values are: SCReadItemSelfScope (self), SCReadItemParentScope (parent) and SCReadItemChildrenScope (children). By default, self is used.
 The order of the result items will be: first is the parent item, then the self item and the children items at last.
 This argument is ignored when [SCReadItemsRequest requestType] is SCReadItemRequestQuery
 */
@property(nonatomic) SCReadItemScopeType scope;

/**
 Request string of the items.
 Has a different meaning depends on [SCReadItemsRequest requestType]
 
 If [SCReadItemsRequest requestType] is
 
 - SCReadItemRequestItemId   - request is the item's id, example: "{C3713481-AF86-4E33-9BE9-D53EFE03E518}"
 
 - SCReadItemRequestItemPath - request is the item's path, example: "/sitecore/content"
 
 - SCReadItemRequestQuery    - request is the Sitecore query, example: "/sitecore/content/nicam/child::*[@@templatename='Site Section']"
 */
@property(nonatomic,strong) NSString *request;

/**
 Specifies the type of [SCReadItemsRequest request] option, see [SCReadItemsRequest request] for details.
 If [SCReadItemsRequest requestType] is a SCReadItemRequestQuery, it is a similar to [SCReadItemsRequest flags] is setted to SCReadItemRequestIngnoreCache.
 */
@property(nonatomic) SCReadItemRequestType requestType;

/**
 The set of the field's names which will be read with each item. Each field's name in the set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 */
@property(nonatomic,strong) NSSet *fieldNames;

/**
 Additional request flags:
 
 - SCReadItemRequestIngnoreCache - means that the request will ignore loaded items, and the request to backend will be performed.
 
 - SCReadItemRequestReadFieldsValues - for each field specified in fieldNames set - [SCField fieldValue] will be loaded before you've got a result with the items.
 */
@property(nonatomic) SCReadItemRequestFlags flags;

/**
 The number of paged, used only if [SCReadItemsRequest pageSize] is specified. Indexing starts from zero.
 */
@property(nonatomic) NSUInteger page;

/**
 The page size of items, used for paged items loading. For example if you need to read only a second item for the given request, specify [SCReadItemsRequest pageSize] as 1 and [SCReadItemsRequest page] is 1.
 */
@property(nonatomic) NSUInteger pageSize;

/**
 The life time in cache after which object in cache becames old
 */
@property(nonatomic) NSTimeInterval lifeTimeInCache;

/**
 This method is usefull for loading one item by the item's id.
 Creates SCReadItemsRequest object with following fields:
 
 [SCReadItemsRequest scope]   is equal to SCReadItemSelfScope
 
 [SCReadItemsRequest request] is equal to itemId argument
 
 [SCReadItemsRequest requestType] is equal to SCReadItemRequestItemId
 
 [SCReadItemsRequest fieldNames] is equal to empty set
 
 [SCReadItemsRequest flags] is equal to zero
 
 [SCReadItemsRequest page] is equal to zero
 
 [SCReadItemsRequest pageSize] is equal to zero
 
 @param itemId system item's id, -[SCItem itemId] can be used.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @return SCReadItemsRequest object, used for [SCApiSession readItemsOperationWithRequest:] method.
 */
+ (id)requestWithItemId:(NSString *)itemId;

/**
 This method is usefull for loading one item by the item's id.
 Creates SCReadItemsRequest object with following fields:
 
 [SCReadItemsRequest scope]   is equal to SCReadItemSelfScope
 
 [SCReadItemsRequest request] is equal to itemId argument
 
 [SCReadItemsRequest requestType] is equal to SCReadItemRequestItemId
 
 [SCReadItemsRequest fieldNames] is equal to fieldNames argument
 
 [SCReadItemsRequest flags] is equal to zero
 
 [SCReadItemsRequest page] is equal to zero
 
 [SCReadItemsRequest pageSize] is equal to zero
 
 @param itemId system item's id, -[SCItem itemId] can be used.
 @param fieldNames The set of the field's names which will be read with each item. Each field's name in set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @return SCReadItemsRequest object, used for [SCApiSession readItemsOperationWithRequest:] method.
 */
+ (id)requestWithItemId:(NSString *)itemId
            fieldsNames:(NSSet *)fieldNames;

/**
 This method is usefull for loading items with [SCReadItemsRequest scope] by the item's id.
 Creates SCReadItemsRequest object with following fields:
 
 [SCReadItemsRequest scope]   is equal to scope argument
 
 [SCReadItemsRequest request] is equal to itemId argument
 
 [SCReadItemsRequest requestType] is equal to SCReadItemRequestItemId
 
 [SCReadItemsRequest fieldNames] is equal to fieldNames argument
 
 [SCReadItemsRequest flags] is equal to zero
 
 [SCReadItemsRequest page] is equal to zero
 
 [SCReadItemsRequest pageSize] is equal to zero
 
 @param itemId system item's id, -[SCItem itemId] can be used.
 @param fieldNames The set of the field's names which will be read with each item. Each field's name in set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @param scope Specifies the set of the items which will be loaded. See [SCReadItemsRequest scope] for details
 @return SCReadItemsRequest object, used for [SCApiSession readItemsOperationWithRequest:] method.
 */
+ (id)requestWithItemId:(NSString *)itemId
            fieldsNames:(NSSet *)fieldNames
                  scope:(SCReadItemScopeType)scope;

/**
 This method is usefull for loading one item by the item's id.
 Creates SCReadItemsRequest object with following fields:
 
 [SCReadItemsRequest scope]   is equal to SCReadItemSelfScope
 
 [SCReadItemsRequest request] is equal to itemPath argument
 
 [SCReadItemsRequest requestType] is equal to SCReadItemRequestItemId
 
 [SCReadItemsRequest fieldNames] is equal to empty set
 
 [SCReadItemsRequest flags] is equal to zero
 
 [SCReadItemsRequest page] is equal to zero
 
 [SCReadItemsRequest pageSize] is equal to zero
 
 @param itemPath system item's path, -[SCItem path] or string like "/sitecore/content" for example can be used.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @return SCReadItemsRequest object, used for [SCApiSession readItemsOperationWithRequest:] method.
 */
+ (id)requestWithItemPath:(NSString *)itemPath;

/**
 This method is usefull for loading one item by the item's path.
 Creates SCReadItemsRequest object with following fields:
 
 [SCReadItemsRequest scope]   is equal to SCReadItemSelfScope
 
 [SCReadItemsRequest request] is equal to itemPath argument
 
 [SCReadItemsRequest requestType] is equal to SCReadItemRequestItemPath
 
 [SCReadItemsRequest fieldNames] is equal to fieldNames argument
 
 [SCReadItemsRequest flags] is equal to zero
 
 [SCReadItemsRequest page] is equal to zero
 
 [SCReadItemsRequest pageSize] is equal to zero
 
 @param itemPath system item's path, -[SCItem path] or string like "/sitecore/content" for example can be used.
 @param fieldNames The set of the field's names which will be read with each item. Each field's name in set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @return SCReadItemsRequest object, used for [SCApiSession readItemsOperationWithRequest:] method.
 */
+ (id)requestWithItemPath:(NSString *)itemPath
              fieldsNames:(NSSet *)fieldNames;

/**
 This method is usefull for loading items with [SCReadItemsRequest scope] by the item's path.
 Creates SCReadItemsRequest object with following fields:
 
 [SCReadItemsRequest scope]   is equal to scope argument
 
 [SCReadItemsRequest request] is equal to itemPath argument
 
 [SCReadItemsRequest requestType] is equal to SCReadItemRequestItemPath
 
 [SCReadItemsRequest fieldNames] is equal to fieldNames argument
 
 [SCReadItemsRequest flags] is equal to zero
 
 [SCReadItemsRequest page] is equal to zero
 
 [SCReadItemsRequest pageSize] is equal to zero
 
 @param itemPath system item's path, -[SCItem path] or string like "/sitecore/content" for example can be used.
 @param fieldNames The set of the field's names which will be read with each item. Each field's name in set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 @param scope Specifies the set of the items which will be loaded. See [SCReadItemsRequest scope] for details
 @return SCReadItemsRequest object, used for [SCApiSession readItemsOperationWithRequest:] method.
 */
+ (id)requestWithItemPath:(NSString *)itemPath
              fieldsNames:(NSSet *)fieldNames
                    scope:(SCReadItemScopeType)scope;

@end
