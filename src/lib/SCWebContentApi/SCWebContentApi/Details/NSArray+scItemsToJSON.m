#import "NSArray+scItemsToJSON.h"

@implementation NSArray (SSSS)

-(NSArray*)scItemsToJSON
{
    return [ self map: ^id( SCItem* item_ )
    {
        return [ [ NSDictionary alloc ] initWithObjectsAndKeys:
                item_.itemId, @"itemId"
                , nil ];
    } ];
}

@end
