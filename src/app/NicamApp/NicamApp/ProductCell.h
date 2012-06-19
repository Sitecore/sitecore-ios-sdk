#import <UIKit/UIKit.h>

@class SCItem;
@class SCImageView;

@interface ProductCell : UITableViewCell

@property ( nonatomic, weak ) IBOutlet UILabel* title;
@property ( nonatomic, strong ) IBOutlet SCImageView* imageView;
@property ( nonatomic, strong, readonly ) SCItem* item;

-(void)setModel:( SCItem* )item_;

@end
