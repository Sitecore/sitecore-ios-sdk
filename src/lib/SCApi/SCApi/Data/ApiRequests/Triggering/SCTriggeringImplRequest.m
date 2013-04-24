#import "SCTriggeringImplRequest.h"
#import "SCTriggeringRequest+PrivateConstructor.h"

@implementation SCTriggeringImplRequest

-(id)initWithItemPath:( NSString* )itemPath
              eventId:( NSString* )eventId
           actionType:( NSString* )action
{
    self = [ super initWithItemPath: itemPath
                            eventId: eventId ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_actionType = action;
    
    return self;
}

-(id)initWithItemPath:(NSString*)itemPath
              eventId:(NSString *)eventId
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(id)initWithItem:(SCItem *)item
          eventId:(NSString *)eventId
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(SCTriggeringImplRequest *)getImplRequestWithHost:( NSString * )host_
{
    return self;
}

#pragma mark -
#pragma mark Constants
+(NSString*)goalAction
{
    return @"sc_trk";
}

+(NSString*)campaignAction
{
    return @"sc_camp";
}

@end
