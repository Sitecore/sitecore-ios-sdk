#import <Foundation/Foundation.h>

@interface NSData (MultipartFormDataWithBoundary)

-(NSData*)multipartFormDataWithBoundary:( NSString* )boundary_
                               fileName:( NSString* )fileName_
                            contentType:( NSString* )contentType_;

@end
