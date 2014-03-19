#import <Foundation/Foundation.h>

@class SCItemSourcePOD;

@protocol SCItemSource <NSObject>

-(NSString*)site;
-(NSString*)database;
-(NSString*)language;
-(NSString*)itemVersion;

@optional
-(SCItemSourcePOD*)toPlainStructure;

@end
