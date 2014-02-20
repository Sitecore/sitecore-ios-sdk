#import "SCItemRecord+Ownerships.h"

#import "SCItemRecord+SCItemSource.h"
#import "SCItemSourcePOD.h"

#import "SCItemInfo.h"
#import "SCApiSession.h"
#import "SCItemRecordCacheRW.h"
#import "SCExtendedApiSession.h"

@interface SCExtendedApiSession (SCItemRecordOwnerships)

@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;

@end

@implementation SCItemRecord (Ownerships)

-(id<SCItemRecordCacheRW>)itemsCache
{
    return self.apiSession.itemsCache;
}

-(SCItemRecord*)findNearestParent
{
    NSString* parentLongId_ = [ self.longID stringByDeletingLastPathComponent ];
    NSString* parentId_     = [ parentLongId_ lastPathComponent ];
    
    SCItemSourcePOD* itemSource = self.itemSource;
    
    while ( [ parentId_ length ] != 0 && ![ parentId_ isEqualToString: @"/" ] )
    {
        SCItemRecord* parent_ = [ self.itemsCache itemRecordForItemWithId: parentId_
                                                               itemSource: itemSource ];
        if ( parent_ )
        {
            return parent_;
        }
        parentLongId_ = [ parentLongId_ stringByDeletingLastPathComponent ];
        parentId_     = [ parentLongId_ lastPathComponent ];
    }
    return nil;
}

-(void)removeOwnershipRelations
{
    SCItemRecord* parent_ = [ self findNearestParent ];
    while ( parent_ )
    {
        [ parent_ removeOwnedObject: self ];
        parent_ = [ parent_ findNearestParent ];
    }
}

-(void)setOwnershipsForParent
{
    SCItemRecord* parent_ = [ self findNearestParent ];
    [ parent_ addOwnedObject: self ];
}

-(void)setOwnershipsForChildren
{
    //STODO to slow method
    SCItemSourcePOD* itemSource = self.itemSource;
    
    NSArray* allItemReceords_ = [ self.itemsCache allCachedItemsForItemSource: itemSource ];
    for ( SCItemRecord* itemRecord_ in allItemReceords_ )
    {
        if ( itemRecord_ != self
            && [ itemRecord_.language isEqualToString: self.language ]
            && [ [ itemRecord_.longID pathComponents ] containsObject: self.itemId ] )
        {
            [ self addOwnedObject: itemRecord_ ];
        }
    }
}

-(void)setOwnershipRelations
{
    [ self setOwnershipsForParent ];
    [ self setOwnershipsForChildren ];

    
    SCItemSourcePOD* itemSource = self.itemSource;
    SCItemRecord* previousItem_ = [ self.itemsCache itemRecordForItemWithId: self.itemId
                                                                 itemSource: itemSource ];

    if ( self != previousItem_ )
    {
        [ previousItem_ removeOwnershipRelations ];
    }
}

@end
