#import <SitecoreMobileSDK/SCItemSource.h>
#import <Foundation/Foundation.h>

@class SCItemsReaderRequest;

@interface SCItemSourcePOD : NSObject<NSCopying, SCItemSource>

+(SCItemSourcePOD*)newPlainSourceFromItemSource:( id<SCItemSource> )itemSource;
-(BOOL)isEqualToItemSource:( id<SCItemSource> )other;

-(void)fillRequestParameters:( SCItemsReaderRequest * )request;

@property( nonatomic, strong ) NSString* language   ;
@property( nonatomic, strong ) NSString* database   ;
@property( nonatomic, strong ) NSString* site       ;
@property( nonatomic, strong ) NSString* itemVersion;

@end
