#ifndef SCAPI_ITEM_READER_SCOPE_TYPE_H_INCULDED
#define SCAPI_ITEM_READER_SCOPE_TYPE_H_INCULDED

typedef enum {
    SCReadItemParentScope   = 1 << 0,
    SCReadItemSelfScope     = 1 << 1,
    SCReadItemChildrenScope = 1 << 2
} SCReadItemScopeType;

#endif //SCAPI_ITEM_READER_SCOPE_TYPE_H_INCULDED
