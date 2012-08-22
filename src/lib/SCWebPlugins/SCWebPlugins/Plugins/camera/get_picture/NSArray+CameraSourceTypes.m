#import "NSArray+CameraSourceTypes.h"

static NSString* sourceTypeToJSName( NSNumber* typeNum_ )
{
    static NSDictionary* jsTypeBySourceType_;
    if ( !jsTypeBySourceType_ )
    {
        jsTypeBySourceType_ = @{
        @( UIImagePickerControllerSourceTypePhotoLibrary     ) : @"PHOTOLIBRARY"   ,
        @( UIImagePickerControllerSourceTypeCamera           ) : @"CAMERA"         ,
        @( UIImagePickerControllerSourceTypeSavedPhotosAlbum ) : @"SAVEDPHOTOALBUM",
        };
    }
    return jsTypeBySourceType_[ typeNum_ ];
}

@implementation NSArray (CameraSourceTypes)

+(NSArray*)cameraSourceTypes
{
    NSArray* result_ = [ NSArray arrayWithSize: UIImagePickerControllerSourceTypeSavedPhotosAlbum + 1
                                      producer: ^id( NSUInteger index_ )
    {
        return @( index_ );
    } ];
    result_ = [ result_ select: ^BOOL( NSNumber* number_ )
    {
        return [ UIImagePickerController isSourceTypeAvailable: [ number_ unsignedIntValue ] ];
    } ];

    result_ = [ result_ map: ^id( NSNumber* number_ )
    {
        return [ [ NSString alloc ] initWithFormat: @"%@: '%@'", sourceTypeToJSName( number_ ), number_ ];
    } ];

    return result_;
}

@end
