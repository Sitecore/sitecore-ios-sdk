#ifndef SC_API_ITEMS_REQUEST_FLAGS_INCLUDED_H
#define SC_API_ITEMS_REQUEST_FLAGS_INCLUDED_H

typedef NS_OPTIONS(NSUInteger, SCReadItemRequestFlags)
{
   SCReadItemRequestIngnoreCache     = 1 << 0,
   SCReadItemRequestReadFieldsValues = 1 << 1
} ;

#endif //SC_API_ITEMS_REQUEST_FLAGS_INCLUDED_H
