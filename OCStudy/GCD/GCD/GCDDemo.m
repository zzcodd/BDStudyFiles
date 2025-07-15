//
//  GCDDemo.m
//  GCD
//
//  Created by ByteDance on 2025/7/14.
//

#import "GCDDemo.h"

@implementation GCDDemo

#pragma mark - 工具方法
// 获取当前时间戳字符串
- (NSString *)timeStamp{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

// 打印带时间戳的日志
- (void)log:(NSString *)message{
    printf("[%s] %s\n", [[self timeStamp] UTF8String], [message UTF8String]);
}

// 模拟耗时操作
- (void)simulateWork:(NSString *)taskName duration:(int)seconds {
    [self log:[NSString stringWithFormat:@"🔄 开始执行: %@", taskName]];
    sleep(seconds);
    [self log:[NSString stringWithFormat:@"✅ 完成执行: %@", taskName]];
}

#pragma mark - Demo 1: 串行队列 vs 并发队列
- (void)demo1_SerialVsConcurrent{
    [self log:@"\n =========Demo 1 : 串行队列 VS 并发队列 ============"];
    
    dispatch_queue_t serialQueue = dispatch_queue_create("con.demo.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.demo.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    [self log:@"\n--- 串行队列执行 (按顺序执行) ---"];
    for(int i = 1;i<=3;i++){
        dispatch_async(serialQueue, ^{
            [self simulateWork:[NSString stringWithFormat:@"串行任务 %d",i] duration:1];
        });
    }
    
    // 等待串行队列执行结束
    dispatch_sync(serialQueue, ^{
        [self log:@"串行队列所有任务全部执行结束"];
    });
    
    [self log:@"\n--- 并发队列执行 (同时执行) ---"];
    dispatch_group_t group = dispatch_group_create();
    for(int i = 1;i<=3;i++){
        dispatch_group_async(group, concurrentQueue, ^{
            [self simulateWork:[NSString stringWithFormat:@"并发任务%d", i] duration:1];
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    [self log:@"📋 并发队列所有任务完成"];

}

#pragma mark - Demo 2: 同步 vs 异步
- (void)demo2_SyncVsAsync {
    [self log:@"\n=== Demo 2: 同步 vs 异步执行 ==="];
    
    dispatch_queue_t queue = dispatch_queue_create("com.demo.queue", DISPATCH_QUEUE_SERIAL);
    [self log:@"\n--- 同步执行 (会阻塞) ---"];
    [self log:@"🚀 准备执行同步任务"];
    dispatch_sync(queue, ^{
        [self simulateWork:@"同步任务" duration:2];
    });
    
    [self log:@"🏁 同步任务执行完毕，继续后面的代码"];
    
    [self log:@"\n--- 异步执行 (不会阻塞) ---"];
    [self log:@"🚀 准备执行异步任务"];
    
    dispatch_async(queue, ^{
        [self simulateWork:@"异步任务" duration:2];
    });
    
    [self log:@"🏃 异步任务已提交，主线程继续执行"];
    [self log:@"🔄 等待异步任务完成..."];
    
    dispatch_sync(queue,^{
        [self log:@"异步任务执行完毕"];
    });
    
}

#pragma mark - Demo 3: 延迟执行
- (void)demo3_DelayedExecution {
    [self log:@"\n=== Demo 3: 延迟执行 ==="];
    
    [self log:@"⏰ 设置2秒后执行的任务"];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [self log:@"⏰ 延迟任务执行了！"];
        dispatch_group_leave(group);
    });
    
    [self log:@"⏳ 等待延迟任务..."];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC));
        [self log:@"等待结束"];
    });
}

#pragma mark - Demo 4: 一次性执行
- (void)demo4_DispatchOnce {
    [self log:@"\n=== Demo 4: 一次性执行 ==="];
    
    [self log:@"📞 多次调用一次性执行的代码"];
    
    for (int i = 1; i <= 5; i++) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self log:@"🎯 这段代码只会执行一次！"];
        });
        
        [self log:[NSString stringWithFormat:@"📞 第%d次调用", i]];
    }
}

#pragma mark - Demo 5: 任务组

- (void)demo5_DispatchGroup {
    [self log:@"\n=== Demo 5: 任务组 ==="];
        
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [self log:@"🎭 开始执行一组相关任务"];

    dispatch_group_async(group, queue, ^{
        [self simulateWork:@"下载图片1" duration:2];
    });
    
    dispatch_group_async(group, queue, ^{
        [self simulateWork:@"下载图片2" duration:3];
    });
    
    
    dispatch_group_async(group, queue, ^{
        [self simulateWork:@"下载图片3" duration:1];
    });
    
    NSLog(@"等待所有下载任务完成...");
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self log:@"🎉 所有图片下载完成，可以更新UI了！"];
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

#pragma mark - Demo 6: 信号量

- (void)demo6_Semaphore {
    [self log:@"\n=== Demo 6: 信号量控制并发 ==="];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [self log:@"最多允许两个任务执行"];
    
    dispatch_group_t group = dispatch_group_create();
    
    for(int i = 1;i<=5 ;i++){
        dispatch_group_async(group, queue, ^{
            [self log:[NSString stringWithFormat:@"⏳ 任务%d等待获取资源", i]];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [self log:[NSString stringWithFormat:@"🔄 任务%d获得资源，开始执行", i]];
            [self simulateWork:[NSString stringWithFormat:@"受限任务%d", i] duration:2];
            dispatch_semaphore_signal(semaphore);
            [self log:[NSString stringWithFormat:@"✅ 任务%d释放资源", i]];

        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    [self log:@"所有受限任务全部完成"];
}

#pragma mark - Demo 7: 栅栏函数
- (void)demo7_Barrier {
    [self log:@"\n=== Demo 7: 栅栏函数 ==="];
        
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.demo.barrier", DISPATCH_QUEUE_CONCURRENT);
    [self log:@"📚 模拟读写操作"];
    // 并发读操作
    for (int i = 1; i <= 3; i++) {
        dispatch_async(concurrentQueue, ^{
            [self simulateWork:[NSString stringWithFormat:@"读操作%d", i] duration:1];
        });
    }
    // 栅栏写操作
    dispatch_barrier_async(concurrentQueue, ^{
        [self log:@"🚧 栅栏：等待所有读操作完成"];
        [self simulateWork:@"写操作(独占)" duration:2];
        [self log:@"🚧 栅栏：写操作完成，允许后续操作"];
    });
    
    // 后续读操作
    for (int i = 4; i <= 6; i++) {
        dispatch_async(concurrentQueue, ^{
            [self simulateWork:[NSString stringWithFormat:@"读操作%d", i] duration:1];
        });
    }
    
    // 等待所有操作完成
    dispatch_barrier_sync(concurrentQueue, ^{
        [self log:@"📚 所有读写操作完成"];
    });
    
}

#pragma mark - Demo 8: 实际应用场景

- (void)demo8_RealWorldExample {
    [self log:@"\n=== Demo 8: 实际应用场景 - 模拟App启动 ==="];
    
    dispatch_group_t startupGroup = dispatch_group_create();
    [self log:@"App启动"];
    
    // 并行执行多个初始化任务
    dispatch_group_async(startupGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self simulateWork:@"初始化网络模块" duration:1];
    });
    
    dispatch_group_async(startupGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self simulateWork:@"初始化数据库" duration:2];
    });
    
    dispatch_group_async(startupGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self simulateWork:@"加载用户偏好设置" duration:1];
    });
    
    dispatch_group_async(startupGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self simulateWork:@"预加载图片缓存" duration:3];
    });
    
    // 等待关键任务完成
    dispatch_group_notify(startupGroup, dispatch_get_main_queue(), ^{
        [self log:@"🎉 App启动完成，显示主界面"];
        
        // 模拟用户操作
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
            [self log:@"👆 用户点击了按钮"];
            
            // 异步处理用户操作
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self simulateWork:@"处理用户请求" duration:1];
                
                // 回到主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self log:@"🔄 更新界面"];
                });
            });
        });
    });
    
    dispatch_group_wait(startupGroup, DISPATCH_TIME_FOREVER);
    sleep(3); // 等待后续操作完成
    
}


- (void)runAllDemos {
    [self log:@"🎬 开始GCD演示程序"];
    [self log:@"================================="];
    
//    [self demo1_SerialVsConcurrent];
//    [self demo2_SyncVsAsync];
//    [self demo3_DelayedExecution];
//    [self demo4_DispatchOnce];
//    [self demo5_DispatchGroup];
//    [self demo6_Semaphore];
//    [self demo7_Barrier];
    [self demo8_RealWorldExample];
//    
//    [self log:@"\n🎉 所有演示完成！"];
//    [self log:@"================================="];
}

@end
