//
//  SCTrafficTriggeringRequest.h
//  SCTrafficTriggeringRequest
//
//  Created on 4/1/2013.
//  Copyright 2013. Sitecore. All rights reserved.
//

#import <SitecoreMobileSDK/SCTriggeringRequest.h>

@class SCItem;

/**
 Request for triggering DMS events
 */
@interface SCPageEventTriggeringRequest : SCTriggeringRequest

/**
A name of the goal to trigger. For example, @"Page Visited"
 */
@property(nonatomic, readonly) NSString *eventName;

/**
 * This is a designated initializer that takes properties described above
 * @param itemPath The item's path in the content tree. See property [SCTriggeringRequest itemPath] for details.
 * @param eventName A name of the goal to trigger. For example, @"Page Visited"
 */
-(id)initWithPath:( NSString* )itemPath
        eventName:( NSString* )eventName;


/**
 * This is an initializer provided for convenience
 * @param item The item to trigger.
 * @param eventName A name of the goal to trigger. For example, @"Page Visited"
 */
-(id)initWithItem:( SCItem* )item
        eventName:( NSString* )eventName;

/**
 * This is a legacy initializer inherited from NSObject.
 * @warning *Caution:* The application will crash if you try to invoke it. Do not use it.
 */
-(id)init;

@end
