//
//  YiDispatchQueue.h
//  YiDispatchQueue
//
//  Created by coderyi on 2019/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    YiDispatchQueuePriorityLow,
    YiDispatchQueuePriorityDefault,
    YiDispatchQueuePriorityHigh
} ATQueuePriority;

@interface YiDispatchQueue : NSObject


+ (YiDispatchQueue *)mainQueue;
+ (YiDispatchQueue *)concurrentDefaultQueue;
+ (YiDispatchQueue *)concurrentBackgroundQueue;

- (instancetype)init;
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithPriority:(ATQueuePriority)priority;

- (void)dispatch:(dispatch_block_t)block;
- (void)dispatch:(dispatch_block_t)block synchronous:(bool)synchronous;
- (void)dispatchAfter:(NSTimeInterval)seconds block:(dispatch_block_t)block;

- (dispatch_queue_t)dispatchQueue;

@end

NS_ASSUME_NONNULL_END
