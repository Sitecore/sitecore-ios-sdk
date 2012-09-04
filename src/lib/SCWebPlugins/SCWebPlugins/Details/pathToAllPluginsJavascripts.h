#ifndef SC_PATH_TO_ALL_PLUGINS_JAVASCRIPT_EXPORT_INCLUDED_H
#define SC_PATH_TO_ALL_PLUGINS_JAVASCRIPT_EXPORT_INCLUDED_H

@class NSString, NSArray;

#ifdef __cplusplus
extern "C"
{
#endif //__cplusplus
    NSArray* scWebPluginsClasses( void );
    NSString* pathToAllPluginsJavascripts( void );
#ifdef __cplusplus
}
#endif //__cplusplus

#endif //SC_PATH_TO_ALL_PLUGINS_JAVASCRIPT_EXPORT_INCLUDED_H
