//
//  SCFieldLinkData.h
//  SCFieldLinkData
//
//  Created on 2/29/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//
#include <SitecoreMobileSDK/SCAsyncOpDefinitions.h>
#import <Foundation/Foundation.h>

@class SCItem;

/**
 The SCFieldLinkData object contains attributes of link xml of "General Link" field raw value.
 */
@interface SCFieldLinkData : NSObject

@property(nonatomic,readonly) NSString *linkDescription;
@property(nonatomic,readonly) NSString *linkType;
@property(nonatomic,readonly) NSString *url;
@property(nonatomic,readonly) NSString *alternateText;

@end

/**
 The SCInternalFieldLinkData object represents the Sitecore internal link.
 */
@interface SCInternalFieldLinkData : SCFieldLinkData

@property(nonatomic,readonly) NSString *anchor;
@property(nonatomic,readonly) NSString *queryString;
@property(nonatomic,readonly) NSString *itemId;

/**
 Used for loading the linked item.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is SCItem object or nil if error happens.
 */
-(SCAsyncOp)itemReader;

@end

/**
 The SCMediaFieldLinkData object represents the Sitecore media link.
 */
@interface SCMediaFieldLinkData : SCFieldLinkData

/**
 Linked media item id.
 */
@property(nonatomic,readonly) NSString *itemId;

/**
 Used to load linked image.
 @return SCAsyncOp block. Call it to get the expected result. The SCAsyncOpResult handler's result is UIImage object or nil if error happens.
 */

-(SCAsyncOp)imageReader;
-(SCExtendedAsyncOp)extendedImageReader;

@end

/**
 The SCExternalFieldLinkData object represents the Sitecore external link.
 */
@interface SCExternalFieldLinkData : SCFieldLinkData
@end

/**
 The SCAnchorFieldLinkData object represents the Sitecore anchor link.
 */
@interface SCAnchorFieldLinkData : SCFieldLinkData

@property(nonatomic,readonly) NSString *anchor;

@end

/**
 The SCEmailFieldLinkData object represents the Sitecore email link.
 */
@interface SCEmailFieldLinkData : SCFieldLinkData
@end

/**
 The SCEmailFieldLinkData object represents the Sitecore javascript link.
 */
@interface SCJavascriptFieldLinkData : SCFieldLinkData
@end
