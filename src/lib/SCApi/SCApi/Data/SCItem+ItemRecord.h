#ifndef SCApi_SCItem_ItemRecord_h
#define SCApi_SCItem_ItemRecord_h

#import <SitecoreMobileSDK/SCItem.h>

@class SCItemRecord;
@class SCExtendedApiSession;

@interface SCItem(ItemRecord)

-(id)initWithRecord:( SCItemRecord* )record_
         apiSession:( SCExtendedApiSession* )apiSession_;
-(void)setRecord:( SCItemRecord* )itemRecord;

@end

#endif
