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

+(id)contactFieldWithName:( NSString* )name_
{
    return [ self contactFieldWithName: name_
                            propertyID: 0 ];

}

-(void)readPropertyFromRecord:( ABRecordRef )record_
{
    CFDataRef dataRef_ = ABPersonCopyImageData( record_ );
    if ( dataRef_ )
    {
        NSData* data_ = ( __bridge_transfer NSData* )dataRef_;
        self.value = [ UIImage imageWithData: data_ ];
    }
}

-(void)setPropertyFromValues:( NSDictionary* )components_
                    toRecord:( ABRecordRef )record_
{
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
    return self.value ? [ [ self.value tmpPathToPNGImage ] dwFilePath ] : @"";
}

@end
