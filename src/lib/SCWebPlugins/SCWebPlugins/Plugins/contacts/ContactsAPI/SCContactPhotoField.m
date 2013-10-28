#import "SCContactPhotoField.h"

//STODO remove
@interface UIImage (StoreTmpFileSCContactPhotoField)

-(NSString*)tmpPathToPNGImage;

@end

//STODO remove
@interface NSString (PathToDWFileURL)

-(NSString*)dwFilePath;

@end

@implementation SCContactPhotoField
{
@private
    NSString* _pngImageFile;
}

@dynamic value;

+(id)contactFieldWithName:( NSString* )name_
{
    return [ self contactFieldWithName: name_
                            propertyID: 0 ];
}

-(NSString*)writeImageDataToDisk:( NSData* )imageData
{
    NSFileManager* fm = [ NSFileManager defaultManager ];
    
    NSString* fileName = [ NSString createUuid ];
    NSString* fullPath = [ NSTemporaryDirectory() stringByAppendingPathComponent: fileName ];
    
    // NSLog( @"---===[BEGIN]Image --> Disk" );
    {
        [ fm createFileAtPath: fullPath
                     contents: imageData
                   attributes: nil ];
    }
    // NSLog( @"---===[END]Image --> Disk" );
    
    return fullPath;
}

-(void)readPropertyFromRecord:( ABRecordRef )record_
{
    @autoreleasepool
    {
        NSLog( @"---===[retain] ABPersonCopyImageData" );
        CFDataRef dataRef_ = ABPersonCopyImageData( record_ );
        if ( dataRef_ )
        {
            NSData* data_ = (__bridge NSData*)dataRef_;

            // TODO :
            // @adk : dump image asynchronously

            self->_pngImageFile = [ self writeImageDataToDisk: data_ ];
            CFRelease( dataRef_ );
            // NSLog( @"---===[CFRelease] ABPersonCopyImageData" );
        }
    }
}

-(UIImage*)value
{
    UIImage* result = [ UIImage imageWithContentsOfFile: self->_pngImageFile ];
    return result;
}

-(void)setValue:(UIImage*)newValue
{
    [ self doesNotRecognizeSelector: _cmd ];
}

-(void)setPropertyFromValues:( NSDictionary* )components_
                    toRecord:( ABRecordRef )record_
{
    self->_pngImageFile = nil;
    
    NSString* urlString_ = [ components_ firstValueIfExsistsForKey: self.name ];
    if ( [ urlString_ length ] == 0 )
    {
        if ( ABPersonHasImageData( record_ ) )
        {
            CFErrorRef error_ = NULL;
            ABPersonRemoveImageData( record_, &error_ );
        }
        return;
    }
    urlString_ = [ urlString_ stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
    urlString_ = [ urlString_ stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
    NSURL* url_ = [ NSURL URLWithString: urlString_ ];
    if ( url_ )
    {
        //STODO fix sync loading data
        NSData* data_ = [ NSData dataWithContentsOfURL: url_ ];
        if ( data_ )
        {
            CFErrorRef error_ = NULL;
            bool didSet = ABPersonSetImageData( record_, ( __bridge CFDataRef )data_, &error_ );
            if (!didSet) { NSLog( @"can not set %@", self.name ); }
        }
    }
}

-(NSString*)jsonValue
{
    NSString* result = [ self->_pngImageFile dwFilePath ];
    if ( nil == result )
    {
        result = @"";
    }
    
    return result;
}

@end
