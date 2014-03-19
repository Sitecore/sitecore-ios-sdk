#import <SitecoreMobileSDK/SCReadItemsRequest.h>

#import <Foundation/Foundation.h>

//STODO! document this file
@interface SCCreateItemRequest : SCReadItemsRequest

@property ( nonatomic, strong ) NSString* itemName;
@property ( nonatomic, strong ) NSString* itemTemplate;
@property ( nonatomic, strong ) NSDictionary* fieldsRawValuesByName;

@end
