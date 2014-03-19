//
//  SCBaseItemRequest.h
//  SCApi
//
//  Created by Igor on 10/3/13.
//
//

#import <Foundation/Foundation.h>

@interface SCBaseItemRequest : NSObject

/**
 The source params used to request Sitecore items, if not set -[SCApiSession defaultLanguage] will be used.
 */
@property( nonatomic, strong) SCItemSourcePOD* itemSource;

/**
 The language used to request Sitecore items, if not set -[SCApiSession defaultLanguage] will be used.
 */
@property( nonatomic, strong) NSString* language;


/**
 The database used to request Sitecore items, if not set -[SCApiSession defaultDatabase] will be used.
 */
@property( nonatomic, strong) NSString* database;


/**
 The site used to request Sitecore items, if not set -[SCApiSession defaultSite] will be used.
 */
@property( nonatomic, strong) NSString* site;

/**
 The version used to request Sitecore items, if not set -[SCApiSession defaultItemVersion] will be used.
 */
@property( nonatomic, strong) NSString* itemVersion;

@end
