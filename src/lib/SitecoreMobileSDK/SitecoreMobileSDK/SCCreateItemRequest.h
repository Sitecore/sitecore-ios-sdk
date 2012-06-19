#import <SitecoreMobileSDK/SCItemsReaderRequest.h>

#import <Foundation/Foundation.h>

//STODO! document this file
@interface SCCreateItemRequest : SCItemsReaderRequest

@property ( nonatomic, strong ) NSString* itemName;
@property ( nonatomic, strong ) NSString* itemTemplate;
@property ( nonatomic, strong ) NSDictionary* fieldsRawValuesByName;

@end
