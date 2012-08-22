#import "SCImageView.h"

//STODO add documentation for this class
@interface SCImageView ()

@property ( copy, nonatomic ) SCAsyncOp reader;

@end

@implementation SCImageView

-(void)showImage:( UIImage* )image_ reader:( SCAsyncOp )reader_
{
    if ( reader_ != self.reader )
        return;

    self.alpha = 0.f;
    [ UIView animateWithAnimations: ^void( void )
    {
        self.alpha = 1.f;
        self.image = image_;
    } ];
}

-(void)setImageReader:( SCAsyncOp )reader_
{
    self.image = nil;

    reader_ = [ reader_ copy ];
    self.reader = reader_;
    if ( reader_ )
    {
        self.reader( ^( UIImage* image_, NSError* error_ )
        {
            [ self showImage: image_ reader: reader_ ];
        } );
    }
}

@end
