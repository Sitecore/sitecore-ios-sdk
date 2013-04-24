#import "SCTriggeringRequest+PrivateConstructor.h"

#import "SCItem.h"

@implementation SCTriggeringRequest (PrivateConstructor)

@dynamic itemPath;
@dynamic actionValue;

-(id)initWithItemPath:(NSString*)itemPath
              eventId:(NSString *)eventId
{
    self = [ super init ];
    
    if ( nil == self )
    {
        return nil;
    }
    
    self.itemPath = itemPath ?: @"";
    self.actionValue = eventId;
    
    return self;
}


-(id)initWithItem:(SCItem *)item
          eventId:(NSString *)eventId
{
    return [ self initWithItemPath: item.path
                           eventId: eventId ];
}


@end
