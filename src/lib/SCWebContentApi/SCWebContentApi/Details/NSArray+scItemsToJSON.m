#import "NSArray+scItemsToJSON.h"

@implementation NSArray (SSSS)

-(NSArray*)scItemsToJSON
{
    return [ self map: ^id( SCItem* item_ )
    {
        return @{ @"itemId" : item_.itemId };
    } ];
}

@end
