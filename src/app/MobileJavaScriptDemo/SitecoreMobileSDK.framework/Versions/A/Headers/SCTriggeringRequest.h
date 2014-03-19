//
//  SCTriggeringRequest.h
//  SCTriggeringRequest
//
//  Created on 4/1/2013.
//  Copyright 2013. Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Base request for triggering DMS events.
* @warning *Caution:* Do not instantiate this class directly. Please use SCTrafficTriggeringRequest or SCCampaignTriggeringRequest 
 */
@interface SCTriggeringRequest : NSObject


/**
 The item's path in the content tree
 @"/sitecore/content/Home/Sample Item"
 */
@property(nonatomic, readonly) NSString *itemPath;

/**
* -Action name for traffic
* -Action id for campaign
*/
@property(nonatomic, readonly) NSString *actionValue;


/**
* This is a legacy initializer inherited from NSObject.
* @warning *Caution:* The application will crash if you try to invoke it. Do not use it.
 */
-(id)init;

@end
