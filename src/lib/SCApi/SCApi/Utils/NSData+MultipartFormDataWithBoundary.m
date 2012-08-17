#import "NSData+MultipartFormDataWithBoundary.h"

@implementation NSData (MultipartFormDataWithBoundary)

-(NSData*)multipartFormDataWithBoundary:( NSString* )boundary_
                               fileName:( NSString* )fileName_
                            contentType:( NSString* )contentType_
{
    NSMutableData* result_ = [ NSMutableData new ];

    NSString* boundaryPost_ = [ [ NSString alloc ] initWithFormat: @"\r\n--%@\r\n", boundary_ ];
    NSData* boundaryData_ = [ boundaryPost_ dataUsingEncoding: NSUTF8StringEncoding ];
    [ result_ appendData: boundaryData_ ];

    static NSString* const contentDespFormat_ =
        @"Content-Disposition: form-data; name=\"datafile\"; filename=\"%@\"";
    NSString* contentDesp_ = [ [ NSString alloc ] initWithFormat: contentDespFormat_, fileName_ ];

    [ result_ appendData: [ contentDesp_ dataUsingEncoding: NSUTF8StringEncoding ] ];

    static NSString* const contentTypeFormat_ =
        @"Content-Type: %@\r\n\r\n";
    NSString* contentTypeStr_ = [ [ NSString alloc ] initWithFormat: contentTypeFormat_, contentType_ ];

    [ result_ appendData: [ contentTypeStr_ dataUsingEncoding: NSUTF8StringEncoding ] ];
    [ result_ appendData: self ];
    [ result_ appendData: boundaryData_ ];

    return [ [ [ self class ] alloc ] initWithData: result_ ];
}

@end
