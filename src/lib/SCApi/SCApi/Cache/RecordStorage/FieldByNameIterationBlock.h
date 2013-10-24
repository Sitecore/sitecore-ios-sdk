#ifndef SCApi_FieldByNameIterationBlock_h
#define SCApi_FieldByNameIterationBlock_h

#import <Foundation/Foundation.h>

typedef void(^FieldByNameIterationBlock)( NSString* fieldName, SCFieldRecord* fieldRecord, BOOL *stop);

#endif
