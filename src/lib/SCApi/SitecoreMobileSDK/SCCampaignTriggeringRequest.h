//
//  SCCampaignTriggeringRequest.h
//  SCCampaignTriggeringRequest
//
//  Created on 4/1/2013.
//  Copyright 2013. Sitecore. All rights reserved.
//

#import <SitecoreMobileSDK/SCTriggeringRequest.h>

@class SCItem;

/**
 A Request for triggering campaigns
 */
@interface SCCampaignTriggeringRequest : SCTriggeringRequest

/**
The id of the campaign to trigger. For example, @"7F6E2AF1A0FC4CF3A4678080BBF440AD"
*/
@property(nonatomic, readonly) NSString *campaignId;

/**
 * This is a designated initializer that takes properties described above
 * @param itemPath The item's path in the content tree. See property [SCTriggeringRequest itemPath] for details.
 * @param campaignId The id of the campaign to trigger. For example, @"7F6E2AF1A0FC4CF3A4678080BBF440AD"
 */
-(id)initWithPath:( NSString* )itemPath
       campaignId:( NSString* )campaignId;


/**
 * This is an initializer provided for convenience
 * @param item The item to trigger.
 * @param campaignId The id of the campaign to trigger. For example, @"7F6E2AF1A0FC4CF3A4678080BBF440AD"
 */
-(id)initWithItem:( SCItem* )item
       campaignId:( NSString* )campaignId;

/**
This is a legacy initializer inherited from NSObject.
@warning *Caution!* The application will crash if you try to invoke it. Do not use it.
 */
-(id)init;

@end
