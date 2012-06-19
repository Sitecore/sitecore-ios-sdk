#import "SCContactEmailsField.h"

//STODO remove
@interface NSArray (ArrayWithEmailOnlyPrivate2)

-(id)scSelectWithEmailOnly;

@end

@implementation SCContactEmailsField

-(NSArray*)filteredValues:( NSArray* )values_
{
    return [ values_ scSelectWithEmailOnly ];
}

@end
