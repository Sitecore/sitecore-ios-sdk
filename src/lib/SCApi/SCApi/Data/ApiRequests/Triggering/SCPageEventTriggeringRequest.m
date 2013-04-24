#import "SCPageEventTriggeringRequest.h"
#import "SCTriggeringImplRequest.h"
#import "NSString+TriggeringPathLogic.h"
#import "SCTriggeringRequest+PrivateConstructor.h"

@implementation SCPageEventTriggeringRequest

@dynamic eventName;

-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(SCTriggeringImplRequest *)getImplRequestWithHost:( NSString * )host_
{
    SCTriggeringImplRequest *request_ =
    [ [ SCTriggeringImplRequest alloc ] initWithItemPath: [ self.itemPath triggeringPathWithHost:host_ ]
                                                 eventId: self.actionValue
                                              actionType: [ SCTriggeringImplRequest goalAction ] ];

    return request_;
}

-(id)initWithPath:( NSString* )itemPath
        eventName:( NSString* )eventName
{
    return [ super initWithItemPath: itemPath
                            eventId: eventName ];
}


-(id)initWithItem:( SCItem* )item
        eventName:( NSString* )eventName
{
    return [ super initWithItem: item
                        eventId: eventName ];
}

-(NSString*)eventName
{
    return self.actionValue;
}

@end
