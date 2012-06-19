#import "SCItemsCache.h"

#import "SCItem.h"

#import "SCField.h"
#import "SCFieldRecord.h"

#import "SCItemInfo.h"
#import "SCItemRecord.h"

#import "SCItemsReaderRequest.h"
#import "SCItemIdPathAndLanguage.h"

#import "SCItemRecord+Ownerships.h"
#import "NSString+DefaultSitecoreLanguage.h"

@interface SCItem (SCApiContextPrivate)

@property ( nonatomic ) SCItemRecord* record;

@end

@interface SCField (SCApiContextPrivate)

@property ( nonatomic ) SCFieldRecord* fieldRecord;

@end

@interface SCItemInfo (SCApiContextPrivate)
@end

@interface NSArray (SCApiContextPrivate)
@end

@interface SCItemsCache ()

@property ( nonatomic, weak ) SCItemRecord* rootItemRecord;

@property ( nonatomic ) NSMutableDictionary* itemRecordsByPath;
@property ( nonatomic ) NSMutableDictionary* itemRecordsById;
@property ( nonatomic ) NSMutableDictionary* fieldsByItemIdAndLanguage;
@property ( nonatomic ) NSMutableSet* hasAllChildrenForItemIdAndLanguage;
@property ( nonatomic ) NSMutableSet* hasAllChildrenForItemPathAndLanguage;

-(JFFMutableAssignArray*)itemRecordsWithId:( NSString* )itemId_;
-(JFFMutableAssignArray*)itemRecordsWithPath:( NSString* )path_;

@end

@implementation SCItemInfo (SCApiContextPrivate)

-(JFFMutableAssignArray*)itemRecordsForItemsCache:( SCItemsCache* )itemsCache_
{
    return self.itemId
        ? [ itemsCache_ itemRecordsWithId: self.itemId ]
        : [ itemsCache_ itemRecordsWithPath: self.itemPath ];
}

@end

@implementation NSArray (SCApiContextPrivate)

//STODO test
-(SCItemRecord*)scItemRecordWithLanguage:( NSString* )language_
                                  strong:( BOOL )strong_
{
    if ( [ self count ] == 0 )
        return nil;

    SCItemRecord* result_ = [ self firstMatch: ^BOOL( SCItemRecord* object_ )
    {
        return [ object_.language isEqualToString: language_ ];
    } ];
    if ( !result_ && !strong_ )
    {
        if ( ![ language_ isEqualToString: [ NSString defaultSitecoreLanguage ] ] )
        {
            result_ = [ self firstMatch: ^BOOL( SCItemRecord* object_ )
            {
                return [ object_.language isEqualToString: [ NSString defaultSitecoreLanguage ] ];
            } ];
        }
        if ( !result_ )
        {
            result_ = [ self objectAtIndex: 0 ];
        }
    }
    return result_;
}

@end

@implementation SCItemsCache

@synthesize rootItemRecord = _rootItemRecord;

@synthesize itemRecordsByPath                    = _itemRecordsByPath;
@synthesize itemRecordsById                      = _itemRecordsById;
@synthesize fieldsByItemIdAndLanguage            = _fieldsByItemIdAndLanguage;
@synthesize hasAllChildrenForItemIdAndLanguage   = _hasAllChildrenForItemIdAndLanguage;
@synthesize hasAllChildrenForItemPathAndLanguage = _hasAllChildrenForItemPathAndLanguage;

-(id)init
{
    self = [ super init ];

    if ( self )
    {
        _itemRecordsByPath                    = [ NSMutableDictionary new ];
        _itemRecordsById                      = [ NSMutableDictionary new ];
        _fieldsByItemIdAndLanguage            = [ NSMutableDictionary new ];
        _hasAllChildrenForItemIdAndLanguage   = [ NSMutableSet new ];
        _hasAllChildrenForItemPathAndLanguage = [ NSMutableSet new ];
    }

    return self;
}

-(SCItemRecord*)rootItemRecord
{
    SCItemRecord* result_ = _rootItemRecord;
    if ( !result_ )
    {
        result_ = [ SCItemRecord rootRecord ];
        [ self registerItemRecord: result_
                        allFields: YES ];
        _rootItemRecord = result_;
    }
    return result_;
}

-(JFFMutableAssignArray*)itemRecordsWithId:( NSString* )itemId_
{
    if ( [ itemId_ isEqualToString: [ SCItemRecord rootItemId ] ] )
        return [ JFFMutableAssignArray arrayWithObject: self.rootItemRecord ];
    return [ _itemRecordsById objectForKey: itemId_ ];
}

-(JFFMutableAssignArray*)itemRecordsWithPath:( NSString* )path_
{
    path_ = [ path_ lowercaseString ];
    if ( [ path_ isEqualToString: [ SCItemRecord rootItemPath ] ] )
        return [ JFFMutableAssignArray arrayWithObject: self.rootItemRecord ];
    return [ self.itemRecordsByPath objectForKey: path_ ];
}

-(SCItemRecord*)existedItemRecordWithItemInfo:( SCItemInfo* )itemInfo_
{
    JFFMutableAssignArray* itemsArray_ = itemInfo_.itemId
        ? [ _itemRecordsById   objectForKey: itemInfo_.itemId ]
        : [ _itemRecordsByPath objectForKey: itemInfo_.itemPath ];

    NSArray* items_ = [ itemsArray_ array ];
    return [ items_ scItemRecordWithLanguage: itemInfo_.language
                                      strong: YES ];
}

-(SCItemRecord*)itemRecordWithItemInfo:( SCItemInfo* )itemInfo_
{
    JFFMutableAssignArray* items_ = [ itemInfo_ itemRecordsForItemsCache: self ];
    return [ items_.array scItemRecordWithLanguage: itemInfo_.language
                                            strong: NO ];
}

-(JFFMutableAssignArray*)itemRecordsWithItemId:( NSString* )itemId_
{
    SCItemInfo* itemInfo_ = [ SCItemInfo new ];
    itemInfo_.itemId = itemId_;
    return [ itemInfo_ itemRecordsForItemsCache: self ];
}

-(JFFMutableAssignDictionary*)readFieldsByNameForItemId:( NSString* )itemId_
                                               language:( NSString* )language_
{
    SCItemIdPathAndLanguage* itemIdAndLang_ = [ SCItemIdPathAndLanguage new ];
    itemIdAndLang_.itemIdPath = itemId_;
    itemIdAndLang_.language   = language_;
    return [ _fieldsByItemIdAndLanguage objectForKey: itemIdAndLang_ ];
}

-(SCField*)fieldWithName:( NSString* )fieldName_
                  itemId:( NSString* )itemId_
                language:( NSString* )language_
{
    JFFMutableAssignDictionary* fields_ = [ self readFieldsByNameForItemId: itemId_
                                                                  language: language_ ];
    return [ fields_ objectForKey: fieldName_ ];
}

-(NSArray*)cachedChildrenWithPredicate:( JFFPredicateBlock )predicate_
{
    NSArray* arrayOfArrays_ = [ _itemRecordsById allValues ];
    NSArray* result_ = [ arrayOfArrays_ flatten: ^NSArray*(JFFMutableAssignArray* object_)
    {
        return [ object_ array ];
    } ];
    result_ = [ result_ select: predicate_ ];

    return [ result_ count ] == 0
        ? nil
        : result_;
}

-(NSArray*)cachedChildrenForItemWithId:( NSString* )itemId_
                              language:( NSString* )language_
{
    return [ self cachedChildrenWithPredicate: ^BOOL( SCItemRecord* record_ )
    {
        return [ record_.parentId isEqualToString: itemId_ ]
            && [ record_.language isEqualToString: language_ ];
    } ];
}

-(NSArray*)cachedChildrenForItemWithPath:( NSString* )itemPath_
                                language:( NSString* )language_
{
    return [ self cachedChildrenWithPredicate: ^BOOL( SCItemRecord* record_ )
    {
        return [ record_.parentPath isEqualToString: itemPath_ ]
            && [ record_.language isEqualToString: language_ ];
    } ];
}

-(NSArray*)allChildrenForItemWithItemInfo:( SCItemInfo* )info_
{
    SCItemIdPathAndLanguage* keyWithId_ = [ SCItemIdPathAndLanguage new ];
    keyWithId_.itemIdPath = info_.itemId;
    keyWithId_.language   = info_.language;

    SCItemIdPathAndLanguage* keyWithPath_ = [ SCItemIdPathAndLanguage new ];
    keyWithPath_.itemIdPath = info_.itemPath;
    keyWithPath_.language   = info_.language;

    if ( ![ _hasAllChildrenForItemIdAndLanguage containsObject: keyWithId_ ]
        && ![ _hasAllChildrenForItemPathAndLanguage containsObject: keyWithPath_ ] )
        return nil;

    NSArray* result_;

    if ( [ info_.itemId length ] != 0 )
        result_ = [ self cachedChildrenForItemWithId: info_.itemId
                                            language: info_.language ];
    else
        result_ = [ self cachedChildrenForItemWithPath: info_.itemPath
                                              language: info_.language ];

    return result_ ? result_ : [ NSArray new ];
}

//STODO refactor - now SCFieldRecord and SCField are placed to ownerships
//STODO test
-(void)mergeOldFields:( NSDictionary* )fieldsByName_
    cachedFeldsByName:( JFFMutableAssignDictionary* )cachedFeldsByName_
           itemRecord:( SCItemRecord* )itemRecord_
{
    [ cachedFeldsByName_ enumerateKeysAndObjectsUsingBlock: ^(id cachedFieldName_
                                                              , SCFieldRecord* prevFieldRecord_
                                                              , BOOL *stop)
    {
        SCFieldRecord* newFieldRecord_  = [ fieldsByName_ objectForKey: cachedFieldName_ ];

        if ( [ newFieldRecord_.type isEqualToString: prevFieldRecord_.type ]
            && prevFieldRecord_.fieldRef )
        {
            prevFieldRecord_.fieldRef.fieldRecord = newFieldRecord_;
        }

        SCItemRecord* prevItemRecord_ = prevFieldRecord_.itemRecord;

        if ( prevFieldRecord_ && !newFieldRecord_ )
        {
            prevFieldRecord_.itemRecord = itemRecord_;
            [ itemRecord_.ownerships addObject: prevFieldRecord_ ];
        }

        [ prevItemRecord_.ownerships removeObject: prevFieldRecord_ ];
    } ];
}

-(void)registerFields:( NSDictionary* )fieldsByName_
        forItemRecord:( SCItemRecord* )itemRecord_
{
    SCItemIdPathAndLanguage* itemIdAndLang_ = [ SCItemIdPathAndLanguage new ];
    itemIdAndLang_.itemIdPath = itemRecord_.itemId;
    itemIdAndLang_.language   = itemRecord_.language;
    JFFMutableAssignDictionary* cachedFeldsByName_ = [ self.fieldsByItemIdAndLanguage objectForKey: itemIdAndLang_ ];

    if ( !cachedFeldsByName_ )
    {
        cachedFeldsByName_ = [ JFFMutableAssignDictionary new ];
        [ self.fieldsByItemIdAndLanguage setObject: cachedFeldsByName_ forKey: itemIdAndLang_ ];
    }

    [ self mergeOldFields: fieldsByName_
        cachedFeldsByName: cachedFeldsByName_
               itemRecord: itemRecord_ ];

    [ fieldsByName_ enumerateKeysAndObjectsUsingBlock: ^( id key, SCFieldRecord* fieldRecord_, BOOL* stop )
    {
        [ itemRecord_.ownerships addObject: fieldRecord_ ];
        [ cachedFeldsByName_ setObject: fieldRecord_ forKey: fieldRecord_.name ];
        fieldRecord_.itemRecord = itemRecord_;
    } ];
}

-(void)storeItemRecord:( SCItemRecord* )itemRecord_
        previosItemRec:( SCItemRecord* )previosItemRec_
                  dict:( NSMutableDictionary* )dict_
                   key:( NSString* )key_
{
    JFFMutableAssignArray* items_ = [ dict_ objectForKey: key_ ];
    if ( [ items_ count ] == 0 )
    {
        items_ = [ JFFMutableAssignArray new ];
        [ dict_ setObject: items_ forKey: key_ ];
    }

    if ( previosItemRec_ )
    {
        [ items_ removeObject: previosItemRec_ ];
    }
    [ items_ addObject: itemRecord_ ];
}

-(void)storeItemRecord:( SCItemRecord* )itemRecord_
        previosItemRec:( SCItemRecord* )previosItemRec_
{
    [ self storeItemRecord: itemRecord_
            previosItemRec: previosItemRec_
                      dict: _itemRecordsById
                       key: itemRecord_.itemId ];

    [ self storeItemRecord: itemRecord_
            previosItemRec: previosItemRec_
                      dict: _itemRecordsByPath
                       key: itemRecord_.path ];
}

-(void)registerItemRecord:( SCItemRecord* )itemRecord_
                allFields:( BOOL )allFields_
{
    SCItemInfo* itemInfo_ = [ SCItemInfo new ];
    itemInfo_.itemId   = itemRecord_.itemId;
    itemInfo_.language = itemRecord_.language;
    SCItemRecord* previosItemRec_ = [ self existedItemRecordWithItemInfo: itemInfo_ ];

    itemRecord_.itemRef = previosItemRec_.itemRef;

    [ self registerFields: itemRecord_.fieldsByName
            forItemRecord: itemRecord_ ];

    [ itemRecord_ setOwnershipRelations ];
    [ self storeItemRecord: itemRecord_
            previosItemRec: previosItemRec_ ];

    itemRecord_.hasAllFields = previosItemRec_.hasAllFields || allFields_;

    //notify previous item with new record
    previosItemRec_.itemRef.record = itemRecord_;
}

-(void)cacheResponseItems:( NSArray* )items_
               forRequest:( SCItemsReaderRequest* )request_
               apiContext:( SCApiContext* )apiContext_
{
    NSUInteger firstChildIndex_ = ( SCItemReaderSelfScope & request_.scope ? 1 : 0 ) +
                                  ( SCItemReaderParentScope & request_.scope  ? 1 : 0 );
    NSUInteger index_ = 0;
    SCItemRecord* someChildRecord_ = nil;
    for ( SCItemRecord* record_ in items_ )
    {
        if ( !someChildRecord_ && firstChildIndex_ == index_ )
        {
            someChildRecord_ = record_;
        }
        record_.apiContext = apiContext_;
        [ self registerItemRecord: record_
                        allFields: request_.fieldNames == nil ];

        ++index_;
    }

    if ( ( SCItemReaderChildrenScope & request_.scope )
        && request_.requestType != SCItemReaderRequestQuery
        && someChildRecord_ )
    {
        SCItemIdPathAndLanguage* keyWithId_ = [ SCItemIdPathAndLanguage new ];
        keyWithId_.itemIdPath = someChildRecord_.parentId;
        keyWithId_.language   = someChildRecord_.language;
        [ _hasAllChildrenForItemIdAndLanguage addObject: keyWithId_ ];

        SCItemIdPathAndLanguage* keyWithPath_ = [ SCItemIdPathAndLanguage new ];
        keyWithPath_.itemIdPath = someChildRecord_.parentPath;
        keyWithPath_.language   = someChildRecord_.language;
        //STODO remove _hasAllChildrenForItemPathAndLanguage ????
        [ _hasAllChildrenForItemPathAndLanguage addObject: keyWithPath_ ];
    }
}

-(BOOL)removeSCItemRecord:( SCItemRecord* )record_
              itemRecords:( JFFMutableAssignArray* )itemRecords_
                 fromDict:( NSMutableDictionary* )dict_
                      key:( NSString* )key_
{
    if ( [ itemRecords_ containsObject: record_ ] )
    {
        [ itemRecords_ removeObject: record_ ];
        if ( [ itemRecords_ count ] )
            [ dict_ removeObjectForKey: key_ ];
        return YES;
    }
    return NO;
}

-(void)didRemovedItemRecord:( SCItemRecord* )record_
{
    BOOL removed_ = NO;

    removed_ = [ self removeSCItemRecord: record_
                             itemRecords: [ self itemRecordsWithId: record_.itemId ]
                                fromDict: _itemRecordsById
                                     key: record_.itemId ];
    removed_ = [ self removeSCItemRecord: record_
                             itemRecords: [ self itemRecordsWithPath: record_.path ]
                                fromDict: _itemRecordsByPath
                                     key: record_.path ];

    if ( removed_ )
    {
        SCItemIdPathAndLanguage* keyWithId_ = [ SCItemIdPathAndLanguage new ];
        keyWithId_.itemIdPath = record_.parentId;
        keyWithId_.language   = record_.language;

        [ self.hasAllChildrenForItemIdAndLanguage removeObject: keyWithId_ ];

        SCItemIdPathAndLanguage* keyWithPath_ = [ SCItemIdPathAndLanguage new ];
        keyWithPath_.itemIdPath = record_.parentPath;
        keyWithPath_.language   = record_.language;

        [ self.hasAllChildrenForItemPathAndLanguage removeObject: keyWithPath_ ];
    }
}

@end
