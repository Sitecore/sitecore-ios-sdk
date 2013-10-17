#import <Foundation/Foundation.h>
#import <SitecoreMobileSDK/SCParams.h>

@interface SCFieldImageParams : SCParams

@property(nonatomic) float      width;
@property(nonatomic) float      height;
@property(nonatomic) float      maxWidth;
@property(nonatomic) float      maxHeight;
@property(nonatomic) NSString   *language;
@property(nonatomic) NSString   *version;
@property(nonatomic) NSString   *database;
@property(nonatomic) NSString   *backgroundColor;
@property(nonatomic) BOOL       disableMediaCache;
@property(nonatomic) BOOL       allowStrech;
@property(nonatomic) float      scale;
@property(nonatomic) BOOL       displayAsThumbnail;

@end
