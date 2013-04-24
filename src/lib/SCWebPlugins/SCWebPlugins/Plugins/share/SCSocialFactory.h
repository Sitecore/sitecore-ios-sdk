#import <Foundation/Foundation.h>
@class SCBaseSocialPoster;

@interface SCSocialFactory : NSObject

+(SCBaseSocialPoster *)newPosterNamed:(NSString *)name;

@end
