//
//  SCUploadMediaItemRequest.h
//  SCUploadMediaItemRequest
//
//  Created on 04/02/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCBaseItemRequest.h"

/**
 The SCUploadMediaItemRequest contains the set of params of the creating media item.
 It used for [SCApiSession uploadMediaOperationWithRequest:] method.
 */
@interface SCUploadMediaItemRequest : SCBaseItemRequest < NSCopying >

/**
 The display name of creating media item ( obligatory parameter ).
 */
@property(nonatomic) NSString *itemName;

/**
 The template of creating media item ( obligatory parameter ).
 */
@property(nonatomic) NSString *itemTemplate;

/**
 The content media item data ( obligatory parameter ).
 */
@property(nonatomic) NSData *mediaItemData;

/**
 The media item's file name ( obligatory parameter ).
 */
@property(nonatomic) NSString *fileName;

/**
 The media item's file content type ( obligatory parameter ).
 */
@property(nonatomic) NSString *contentType;

/**
 The media item's folder where item will be created.
 */
@property(nonatomic) NSString *folder;

/**
 The set of the field's names which will be read when item created. Each field's name in the set should be a string.
 For reading all fields - pass nil or pass empty set if you don't need to read any field
 */
@property(nonatomic,strong) NSSet *fieldNames;

@end
