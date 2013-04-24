#import "SCTriggeringRequest.h"

@class SCItem;

@interface SCTriggeringRequest (PrivateConstructor)

@property (nonatomic) NSString *itemPath;
@property (nonatomic) NSString *actionValue;


-(id)initWithItemPath:( NSString* )itemPath
              eventId:( NSString* )eventId;

-(id)initWithItem:(SCItem *)item
          eventId:(NSString *)eventId;


@end
