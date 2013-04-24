#import "SCAbstractTriggerPlugin.h"

@interface SCTriggerDmsGoalPlugin : SCAbstractTriggerPlugin< SCWebPlugin >
@end


@implementation SCTriggerDmsGoalPlugin

+(NSString*)pluginJavascript
{
    return [ SCAbstractTriggerPlugin pluginJavascript ];
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request
{
    return [ request.URL.path isEqualToString: @"/scmobile/analytics/trigger_page_event" ];
}

-(NSString*)parseTriggerIdWithRequestArgs:( NSDictionary* )args
{
    return [ args firstValueIfExsistsForKey: @"pageEventName" ];
}

-(JFFAsyncOperation)triggeringAction
{
    SCTriggeringImplRequest* request =
    [ [ SCTriggeringImplRequest alloc ] initWithItemPath: self.itemRenderingUrl
                                                 eventId: self.triggerId
                                              actionType: [ SCTriggeringImplRequest goalAction ] ];

    return [ SCTriggerExecutor executeTriggerRequest: request ];
}

@end
