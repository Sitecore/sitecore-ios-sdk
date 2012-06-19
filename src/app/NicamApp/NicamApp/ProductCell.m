#import "ProductCell.h"

#import <SitecoreMobileSDK/SCImageView.h>

@interface ProductCell ()

@property ( nonatomic, strong ) SCItem* item;
@property ( nonatomic, assign ) NSUInteger index;

@end

@implementation ProductCell

@synthesize title, imageView, item, index;

-(void)setModel:( SCItem* )item_
{
    self.item = item_;
    self.title.text = [ item_ displayName ];
    self.title.lineBreakMode = UILineBreakModeClip;
    SCAsyncOp getItemField_ = [ item_ fieldValueReaderForFieldName: @"Image" ];
    [ self.imageView setImageReader: getItemField_ ];
}

@end
