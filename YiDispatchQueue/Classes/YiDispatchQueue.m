//
//  YiDispatchQueue.m
//  YiDispatchQueue
//
//  Created by coderyi on 2019/9/15.
//

#import "YiDispatchQueue.h"

@interface YiDispatchQueue ()
{
    dispatch_queue_t _dispatchQueue;
    bool _isMainQueue;
    
    const char *_name;
}


@end

@implementation YiDispatchQueue

+ (NSString *)applicationPrefix
{
    static NSString *prefix = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      prefix = [[NSBundle mainBundle] bundleIdentifier];
                  });
    
    return prefix;
}

+ (YiDispatchQueue *)mainQueue
{
    static YiDispatchQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      queue = [[YiDispatchQueue alloc] init];
                      queue->_dispatchQueue = dispatch_get_main_queue();
                      queue->_isMainQueue = true;
                  });
    
    return queue;
}

+ (YiDispatchQueue *)concurrentDefaultQueue
{
    static YiDispatchQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      queue = [[YiDispatchQueue alloc] initWithNativeQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
                  });
    
    return queue;
}

+ (YiDispatchQueue *)concurrentBackgroundQueue
{
    static YiDispatchQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      queue = [[YiDispatchQueue alloc] initWithNativeQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
                  });
    
    return queue;
}

- (instancetype)init
{
    return [self initWithName:[[YiDispatchQueue applicationPrefix] stringByAppendingFormat:@".%ld", lrand48()]];
}

static int32_t numQueues = 0;

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self != nil)
    {
        _name = [name UTF8String];
        _dispatchQueue = dispatch_queue_create([name UTF8String], DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(_dispatchQueue, _name, (void *)_name, NULL);

        numQueues++;
#ifdef DEBUG
        NSLog(@"YiDispatchQueue count = %d", numQueues);
#endif
    }
    return self;
}

- (instancetype)initWithPriority:(ATQueuePriority)priority
{
    self = [super init];
    if (self != nil)
    {
        _dispatchQueue = dispatch_queue_create([[[YiDispatchQueue applicationPrefix] stringByAppendingFormat:@".%ld", lrand48()] UTF8String], DISPATCH_QUEUE_SERIAL);
        long targetQueueIdentifier = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        switch (priority)
        {
            case YiDispatchQueuePriorityLow:
                targetQueueIdentifier = DISPATCH_QUEUE_PRIORITY_LOW;
                break;
            case YiDispatchQueuePriorityDefault:
                targetQueueIdentifier = DISPATCH_QUEUE_PRIORITY_DEFAULT;
                break;
            case YiDispatchQueuePriorityHigh:
                targetQueueIdentifier = DISPATCH_QUEUE_PRIORITY_HIGH;
                break;
        }
        dispatch_set_target_queue(_dispatchQueue, dispatch_get_global_queue(targetQueueIdentifier, 0));
        dispatch_queue_set_specific(_dispatchQueue, _name, (void *)_name, NULL);
    }
    return self;
}

- (instancetype)initWithNativeQueue:(dispatch_queue_t)queue
{
    self = [super init];
    if (self != nil)
    {
        _dispatchQueue = queue;
    }
    return self;
}

- (void)dealloc
{
    if (_dispatchQueue != nil)
    {
        _dispatchQueue = nil;
    }
}

- (void)dispatch:(dispatch_block_t)block
{
    [self dispatch:block synchronous:false];
}

- (void)dispatch:(dispatch_block_t)block synchronous:(bool)synchronous
{
    if (block == nil)
        return;

    if (_isMainQueue)
    {
        if ([NSThread isMainThread])
            block();
        else if (synchronous)
            dispatch_sync(_dispatchQueue, block);
        else
            dispatch_async(_dispatchQueue, block);
    }
    else
    {
        if (_name != NULL && dispatch_get_specific(_name) == _name)
            block();
        else if (synchronous)
            dispatch_sync(_dispatchQueue, block);
        else
            dispatch_async(_dispatchQueue, block);
    }
}

- (void)dispatchAfter:(NSTimeInterval)seconds block:(dispatch_block_t)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), _dispatchQueue, block);
}

- (dispatch_queue_t)dispatchQueue
{
    return _dispatchQueue;
}

- (bool)isCurrentQueue
{
    if (_dispatchQueue == nil || _name == nil)
        return false;
    
    if (_isMainQueue)
        return [NSThread isMainThread];
    else
        return dispatch_get_specific(_name) == _name;
}

@end
