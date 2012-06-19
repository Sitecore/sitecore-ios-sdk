#import "NSArray+CameraSourceTypes.h"

static NSString* sourceTypeToJSName( NSNumber* typeNum_ )
{
    static NSDictionary* jsTypeBySourceType_;
    if ( !jsTypeBySourceType_ )
    {
        jsTypeBySourceType_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys:
                               @"PHOTOLIBRARY"
                               , [ NSNumber numberWithUnsignedInt: UIImagePickerControllerSourceTypePhotoLibrary ]
                               , @"CAMERA"
                               , [ NSNumber numberWithUnsignedInt: UIImagePickerControllerSourceTypeCamera ]
                               , @"SAVEDPHOTOALBUM"
                               , [ NSNumber numberWithUnsignedInt: UIImagePickerControllerSourceTypeSavedPhotosAlbum ]
                               , nil ];
    }
    return [ jsTypeBySourceType_ objectForKey: typeNum_ ];
}

@implementation NSArray (CameraSourceTypes)

+(NSArray*)cameraSourceTypes
{
    NSArray* result_ = [ NSArray arrayWithSize: UIImagePickerControllerSourceTypeSavedPhotosAlbum + 1
                                      producer: ^id( NSUInteger index_ )
    {
        return [ NSNumber numberWithUnsignedInt: index_ ];
    } ];
    result_ = [ result_ select: ^BOOL( NSNumber* number_ )
    {
        return [ UIImagePickerController isSourceTypeAvailable: [ number_ unsignedIntValue ] ];
    } ];

    result_ = [ result_ map: ^id( NSNumber* number_ )
    {
        return [ NSString stringWithFormat: @"%@: '%@'", sourceTypeToJSName( number_ ), number_ ];
    } ];

    return result_;
}

@end
