#import <Foundation/Foundation.h>

@class SCItem;

@protocol ProductsViewControllerDelegate <NSObject>

@required
-(void)productsViewController:( id )controller_
         didSelectProductItem:( SCItem* )item_;

@end
