#import "SCTriggeringRequest.h"
#import "SCItem.h"


@interface SCTriggeringRequest()
    @property (nonatomic) NSString *itemPath;
    @property (nonatomic) NSString *actionValue;
@end

@implementation SCTriggeringRequest

-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

@end
