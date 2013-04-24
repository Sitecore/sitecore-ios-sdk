#import "SCCampaignTriggeringRequest.h"
#import "SCTriggeringImplRequest.h"
#import "NSString+TriggeringPathLogic.h"

#import "SCTriggeringRequest+PrivateConstructor.h"

@implementation SCCampaignTriggeringRequest

@dynamic campaignId;

-(SCTriggeringImplRequest *)getImplRequestWithHost:( NSString * )host_
{
    NSString* renderingPath = [ self.itemPath triggeringPathWithHost:host_ ];

    return [ [ SCTriggeringImplRequest alloc ] initWithItemPath: renderingPath
                                                        eventId: self.actionValue
                                                     actionType: [ SCTriggeringImplRequest campaignAction ] ];
}

-(id)initWithPath:( NSString* )itemPath
       campaignId:( NSString* )campaignId
{
    return [ super initWithItemPath: itemPath
                            eventId: campaignId ];
}

-(id)initWithItem:( SCItem* )item
       campaignId:( NSString* )campaignId
{
    return [ super initWithItem: item
                        eventId: campaignId ];
}

-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(NSString*)campaignId
{
    return self.actionValue;
}

@end
