#import "SCAbstractTriggerPlugin.h"

@interface SCTriggerDmsCampaignPlugin : SCAbstractTriggerPlugin< SCWebPlugin >

@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end

@implementation SCTriggerDmsCampaignPlugin

+(NSString*)pluginJavascript
{
    return [ SCAbstractTriggerPlugin pluginJavascript ];
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request
{
    return [ request.URL.path isEqualToString: @"/scmobile/analytics/trigger_campaign" ];
}

-(NSString*)parseTriggerIdWithRequestArgs:( NSDictionary* )args
{
    return [ args firstValueIfExsistsForKey: @"campaignId" ];
}

-(JFFAsyncOperation)triggeringAction
{
    SCTriggeringImplRequest* request =
    [ [ SCTriggeringImplRequest alloc ] initWithItemPath: self.itemRenderingUrl
                                                 eventId: self.triggerId
                                              actionType: [ SCTriggeringImplRequest campaignAction ] ];
    
    
    return [ SCTriggerExecutor executeTriggerRequest: request ];
}

@end
