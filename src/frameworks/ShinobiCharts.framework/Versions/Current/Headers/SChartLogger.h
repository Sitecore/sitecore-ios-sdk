//
//  SChartLogger.h
//  SChart
//
//  Copyright (c) 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SChartLogLevelDebug,    // print out everything, include debug and diagnostic messages
    SChartLogLevelWarning,  // print out most things, including warnings
    SChartLogLevelError,    // only print errors and messages causing SChart to abort
    SChartLogLevelSilent    // print nothing at all
} SChartLogLevel;

/** A class to format output and control the level of reporting by the chart and its objects. Setting the log level to SChartLogLevelError will output all messages _below_ this level ie: `SChartLogLevelDebug` and `SChartLogLevelWarning`.
 
 *Log Levels*:<br>
 <code>typedef enum {<br>
 SChartLogLevelDebug,    // print out everything, include debug and diagnostic messages<br>
 SChartLogLevelWarning,  // print out most things, including warnings<br>
 SChartLogLevelError,    // only print errors and messages causing ShinobiChart to abort<br>
 SChartLogLevelSilent    // print nothing at all<br>
 } SChartLogLevel;</code>
 
*/
@interface SChartLogger : NSObject

/** @name Initialisation and config */
/** Initialise the log object with an output level
 
 All messages at or _below_ `outputLevel` will be sent to the console. */
- (id)initWithLogLevelToOutput:(SChartLogLevel)outputLevel;

/** All messages at or _below_ `logLevel` will be sent to the console.  */
@property (nonatomic) SChartLogLevel logLevel;


/** @name Logging messages */
/** Log a message at a particular level
 
 The `message` will be output during execution whenever the `logLevel` passed to this method is at or _below_ the class `logLevel`.*/
- (void)logAtLevel:(SChartLogLevel)logLevel
            inFile:(const char *)file
       andFunction:(const char *)function
            onLine:(unsigned)line
       withMessage:(NSString *)message;

@end
