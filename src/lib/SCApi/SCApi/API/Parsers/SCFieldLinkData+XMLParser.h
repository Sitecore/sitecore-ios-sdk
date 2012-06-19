#import "SCFieldLinkData.h"

@class CXMLDocument;

@interface SCFieldLinkData (XMLParser)

+(id)fieldLinkDataWithXMLData:( NSData* )data_
                        error:( NSError** )outError_;

@end
