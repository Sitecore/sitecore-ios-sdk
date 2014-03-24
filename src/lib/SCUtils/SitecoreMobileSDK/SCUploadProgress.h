#import <Foundation/Foundation.h>


/**
 This protocol describes the structure that informs about the upload progress.
 */
@protocol SCUploadProgress <NSObject>

/**
 Progress value. Ususally it is a floating point value from the [0..100] range.
 */
-(NSNumber*)progress;



/**
 A target URL for upload.
 */
-(NSURL*)url;




/**
 Headers of the HTTP request
 */
-(NSDictionary*)headers;


@end
