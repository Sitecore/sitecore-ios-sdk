#ifndef SCAPI_ITEM_READER_SCOPE_TYPE_H_INCULDED
#define SCAPI_ITEM_READER_SCOPE_TYPE_H_INCULDED

typedef enum {
    SCItemReaderParentScope   = 1 << 0,
    SCItemReaderSelfScope     = 1 << 1,
    SCItemReaderChildrenScope = 1 << 2
} SCItemReaderScopeType;

#endif //SCAPI_ITEM_READER_SCOPE_TYPE_H_INCULDED
