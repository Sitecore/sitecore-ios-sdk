#import <SitecoreMobileSDK/SCItemSource.h>
#import <Foundation/Foundation.h>

@class SCReadItemsRequest;

@interface SCItemSourcePOD : NSObject<NSCopying, SCItemSource>

+(SCItemSourcePOD*)newPlainSourceFromItemSource:( id<SCItemSource> )itemSource;
-(BOOL)isEqualToItemSource:( id<SCItemSource> )other;

-(void)fillRequestParameters:( SCReadItemsRequest * )request;

@property( nonatomic, strong ) NSString* language   ;
@property( nonatomic, strong ) NSString* database   ;
@property( nonatomic, strong ) NSString* site       ;
@property( nonatomic, strong ) NSString* itemVersion;

@end
