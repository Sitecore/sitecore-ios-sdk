#ifndef SCApi_SCItemPropertyGetterBlock_h
#define SCApi_SCItemPropertyGetterBlock_h

@class NSString;
@class SCItemRecord;

typedef NSString*(^SCItemPropertyGetter)( SCItemRecord* itemRecord );

#endif
