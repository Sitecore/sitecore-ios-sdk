//
//  SCBaseItemRequest.h
//  SCApi
//
//  Created by Igor on 10/3/13.
//
//

#import <Foundation/Foundation.h>


/**
 The SCBaseItemRequest class is a base for all web api request objects
 
 * SCReadItemsRequest
 * SCEditItemsRequest
 * SCCreateItemRequest
 * SCUploadMediaItemRequest
 * SCGetRenderingHtmlRequest
 
 It stores the information about the source of item or items being operated on. It conforms the SCItemSource protocol informally.
 
 See the reference of SCItemSourcePOD class and SCItemSource protocol for more details.
 */
@interface SCBaseItemRequest : NSObject

/**
 The source params used to request Sitecore items, if not set the session defaults will be used.
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
