#import <Foundation/Foundation.h>

@class SCField;
@class SCItemRecord;
@class SCApiContext;

@interface SCFieldRecord : NSObject

@property ( nonatomic ) NSString* fieldId;
@property ( nonatomic ) NSString* name;
@property ( nonatomic ) NSString* type;
@property ( nonatomic ) NSString* rawValue;

@property ( nonatomic ) SCApiContext* apiContext;
@property ( nonatomic, weak   ) SCItemRecord* itemRecord;
@property ( nonatomic, weak, readonly ) SCField* field;
@property ( nonatomic, weak ) SCField* fieldRef;
@property ( nonatomic ) id fieldValue;

@end
