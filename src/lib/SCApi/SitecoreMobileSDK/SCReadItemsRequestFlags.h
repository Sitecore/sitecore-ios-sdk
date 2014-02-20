#ifndef SC_API_ITEMS_REQUEST_FLAGS_INCLUDED_H
#define SC_API_ITEMS_REQUEST_FLAGS_INCLUDED_H

typedef NS_OPTIONS(NSUInteger, SCItemReaderRequestFlags)
{
   SCItemReaderRequestIngnoreCache     = 1 << 0,
   SCItemReaderRequestReadFieldsValues = 1 << 1
} ;

#endif //SC_API_ITEMS_REQUEST_FLAGS_INCLUDED_H
