
#define STREAM_OS_CAPACITY (1024)

struct StreamOS_Desc
{
    unsigned int length;
};



#define MAX_STREAM_OS_COUNT (512)

struct StreamOS_TableDesc
{
    struct StreamOS_Desc descs[MAX_STREAM_OS_COUNT];

    unsigned int bitset[1024/32];

    char streamData[STREAM_OS_CAPACITY*sizeof(struct StreamOS_Desc)*MAX_STREAM_OS_COUNT];
};
