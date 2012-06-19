#include "JBeepFileURL.h"

#include <stdio.h>

#include "beep.caf.h"

NSURL* jdfBeepFileURL( void )
{
    static NSURL* instance_;
	static dispatch_once_t predicate_;

	dispatch_once( &predicate_, ^( void )
    {
        NSString* path_ = [ NSString documentsPathByAppendingPathComponent: @"scmobile_beep.caf" ];

        if ( ![ [ NSFileManager defaultManager ] fileExistsAtPath: path_ ] )
        {
            FILE* file_;
            file_ = fopen( [ path_ cStringUsingEncoding: NSUTF8StringEncoding ], "wb" );
            if ( file_ != NULL )
            {
                fwrite( __SCWebPlugins_Plugins_notification_beep_beep_caf
                       , 1
                       , __SCWebPlugins_Plugins_notification_beep_beep_caf_len
                       , file_ );
            }
            fclose( file_ );
        }

		instance_ = [ NSURL fileURLWithPath: path_ ];
	} );

    return instance_;
}
