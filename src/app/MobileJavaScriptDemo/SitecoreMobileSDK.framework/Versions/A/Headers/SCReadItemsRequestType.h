#ifndef SCAPI_ITEM_READER_REQUEST_TYPE_H_INCULDED
#define SCAPI_ITEM_READER_REQUEST_TYPE_H_INCULDED

/**
 Specifies the type of [SCReadItemsRequest request] option, see [SCReadItemsRequest request] for details
 */
typedef enum
{
    SCReadItemRequestItemId,
    SCReadItemRequestItemPath,
    SCReadItemRequestQuery
} SCReadItemRequestType;

#endif //SCAPI_ITEM_READER_REQUEST_TYPE_H_INCULDED
