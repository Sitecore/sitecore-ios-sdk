#import "SCItemRecord.h"

#import "SCItem.h"
#import "SCItemInfo.h"
#import "SCExtendedApiSession.h"

#import "NSString+ItemPathLogic.h"
#import "SCItemRecord+Ownerships.h"

#import "SCItemRecordCacheRW.h"
#import "SCItemRecord+SCItemSource.h"
#import "SCItemRecordCacheRW.h"
#import "SCItemSourcePOD.h"

@interface SCExtendedApiSession (SCItemRecord)

@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;

@end

@interface SCItem (SCApiSessionPrivate)

+(id)itemWithRecord:( SCItemRecord* )record_
         apiSession:( SCExtendedApiSession* )apiSession_;

@end


@interface SCItemRecord ()

@property ( nonatomic ) SCItemSourcePOD* itemSource;

@end

@implementation SCItemRecord

@dynamic parentId;
@dynamic parentLongId;
@dynamic parentPath;
@dynamic allChildrenRecords;
@dynamic readChildrenRecords;
@dynamic parent;
@dynamic item;

-(void)dealloc
{
    // @adk - uncomment this if cache does not retain stored items
    // Otherwise this code will be either unreachable or unwanted.
    
    // [ self unregisterFromCacheItemAndChildren: NO ];
}

+(instancetype)rootRecord
{
    SCItemRecord* result_ = [ self new ];

    result_.path        = [ [ self class ] rootItemPath ];
    result_.itemId      = [ [ self class ] rootItemId ];
    result_.hasChildren = YES;
    result_.displayName = @"sitecore";

    return result_;
}

-(NSString*)description
{
    return [ [ NSString alloc ] initWithFormat: @"<SCItemRecord displayName:\"%@\" template:\"%@\" hasChildren:\"%d\" >"
            , self.displayName
            , self.itemTemplate
            , self.hasChildren ];
}

+(instancetype)itemRecord
{
    return [ self new ];
}

+(NSString*)rootItemId
{
    return @"{11111111-1111-1111-1111-111111111111}";
}

+(NSString*)rootItemPath
{
    return @"/sitecore";
}

-(NSString*)parentId
{    
    return [ self.parentLongId lastPathComponent ];
}

-(NSString*)parentPath
{
    return [ self.path stringByDeletingLastPathComponent ];
}

-(NSString*)parentLongId
{
    return [ self.longID stringByDeletingLastPathComponent ];
}

-(NSArray*)allChildrenRecords
{
    if ( !self.hasChildren )
    {
        return [ NSArray new ];
    }

    return [ self->_apiSession.itemsCache allChildrenForItemWithItemWithId: self.itemId     itemSource: self.itemSource ];
}

-(NSArray*)readChildrenRecords
{
    return [ self->_apiSession.itemsCache cachedChildrenForItemWithId: self.itemId
                                                           itemSource: self.itemSource ];
}

-(SCItem*)item
{
    SCItem* result_ = self->_itemRef;
    if ( !result_ )
    {
        result_ = [ SCItem itemWithRecord: self
                               apiSession: self->_apiSession ];
        self->_itemRef = result_;
    }
    return result_;
}

-(SCItem*)parent
{
    SCItemRecord* record_ = [ self->_apiSession.itemsCache itemRecordForItemWithId: self.parentId
                                                                        itemSource: self.itemSource ];
    return record_.item;
}

-(void)unregisterFromCacheItemAndChildren:( BOOL )childrenAlso_
{
    if ( childrenAlso_ )
    {
        for ( SCItemRecord* itemRecord_ in self.readChildrenRecords )
        {
            [ itemRecord_ unregisterFromCacheItemAndChildren: YES ];
        }
    }
    if ( [ self.itemId length ] != 0 )
    {
        [ self removeOwnershipRelations ];
        [ self->_apiSession.itemsCache didRemovedItemRecord: self ];
        self.itemId = nil;
    }
}

-(void)setApiSession:(SCExtendedApiSession *)apiSession
{
    self->_apiSession = apiSession;
    self->_mainApiSession = apiSession.mainSession;
}

@end
