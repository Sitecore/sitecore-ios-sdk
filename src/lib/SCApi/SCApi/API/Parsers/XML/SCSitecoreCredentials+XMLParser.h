#import "SCSitecoreCredentials.h"

@interface SCSitecoreCredentials (XMLParser)

+(SCSitecoreCredentials*)sitecoreCredentialsWithXMLData:( NSData* )xmlData_
                                                  error:( NSError** )error_;

@end
