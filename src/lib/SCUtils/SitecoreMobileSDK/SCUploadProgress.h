#import <Foundation/Foundation.h>

@protocol SCUploadProgress <NSObject>

-(NSNumber*)progress;
-(NSURL*)url;
-(NSDictionary*)headers;

@end
