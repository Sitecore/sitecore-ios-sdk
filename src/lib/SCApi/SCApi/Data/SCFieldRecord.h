#import <Foundation/Foundation.h>

@class SCField;
@class SCItemRecord;
@class SCExtendedApiSession;
@class SCItemSourcePOD;

@interface SCFieldRecord : NSObject

@property ( nonatomic ) NSString* fieldId;
@property ( nonatomic ) NSString* name;
@property ( nonatomic ) NSString* type;
@property ( nonatomic ) NSString* rawValue;

@property ( nonatomic ) SCExtendedApiSession* apiSession;
@property ( nonatomic, weak   ) SCItemRecord* itemRecord;
@property ( nonatomic, weak, readonly ) SCField* field;
@property ( nonatomic, weak ) SCField* fieldRef;
@property ( nonatomic ) id fieldValue;

#pragma mark -
#pragma mark Dynamic
@property ( nonatomic, readonly ) SCItemSourcePOD* itemSource;
@property ( nonatomic, readonly ) NSString*        itemId;

@end
