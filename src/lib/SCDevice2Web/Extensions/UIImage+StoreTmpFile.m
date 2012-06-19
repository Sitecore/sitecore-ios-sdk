#import "UIImage+StoreTmpFile.h"

@implementation UIImage (StoreTmpFile)

-(NSString*)tmpPathToPNGImage
{
    NSData* data_ = UIImagePNGRepresentation( self );
    NSFileManager* fileManager_ = [ NSFileManager defaultManager ];

    NSString* fileName_ = [ [ NSString alloc ] initWithFormat: @"%@.png", [ NSString createUuid ] ];

    NSString* fullPath_ = [ NSTemporaryDirectory() stringByAppendingPathComponent: fileName_ ];
    [ fileManager_ createFileAtPath: fullPath_ contents: data_ attributes: nil ];

    return fullPath_;
}

@end
