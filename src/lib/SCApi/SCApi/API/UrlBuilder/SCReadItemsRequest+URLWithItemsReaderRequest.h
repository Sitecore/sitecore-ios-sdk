#import "SCReadItemsRequest.h"

@interface SCReadItemsRequest (URLWithItemsReaderRequestPrivate)

@property ( nonatomic, readonly ) NSString* database;

-(NSString*)pathURLParam;
-(NSString*)itemIdURLParam;
-(NSString*)scopeURLParam;
-(NSString*)queryURLParam;
-(NSString*)fieldsURLParam;
-(NSString*)pagesURLParam;
-(NSString*)itemVersionURLParam;

@end
