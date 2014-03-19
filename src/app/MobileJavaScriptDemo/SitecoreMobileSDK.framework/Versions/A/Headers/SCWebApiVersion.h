#ifndef SCApi_SCWebApiVersion_h
#define SCApi_SCWebApiVersion_h


typedef enum SCWebApiVersion
{
    SCWebApiUnknown = 0,
    SCWebApiV1 = 1,
    
    SCWebApiMinSupportedVersion = SCWebApiV1,
    SCWebApiMaxSupportedVersion = SCWebApiV1
} SCWebApiVersion;


#endif
