#import <SitecoreMobileSDK/SCTriggeringRequest.h>

@class SCItem;

/**
Extended request for triggering DMS events, with full item path and action type
 */
@interface SCTriggeringImplRequest : SCTriggeringRequest

/**
 action type, by default it's:
 -"sc_camp" for the campaign triggering request
 -"sc_trk" for the traffic triggering request
 */
@property (nonatomic, readonly) NSString *actionType;


/**
* This is a designated initializer
* @param itemPath A path to the item's rendering
* @param eventId The event to trigger. See property [ SCTriggeringRequest actionValue ] for details.
* @param actionType The 
*/
-(id)initWithItemPath:( NSString* )itemPath
              eventId:( NSString* )eventId
           actionType:( NSString* )action;



/**
 * This is a legacy initializer inherited from NSObject.
 * @warning *Caution:* The application will crash if you try to invoke it. Do not use it.
 */
-(id)init;


/**
* An action constant to trigger some goal - @"sc_trk"
*/
+(NSString*)goalAction;


/**
 * An action constant to trigger some campaign - @"sc_camp"
 */
+(NSString*)campaignAction;

@end
