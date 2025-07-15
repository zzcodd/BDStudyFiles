//
//  main.m
//  Singleton
//
//  Created by ByteDance on 2025/7/9.
//

#import <Foundation/Foundation.h>
#import "UserManager.h"
#import "BusinessModuleA.h"
#import "BusinessModuleB.h"

// 单例模式演示
void demonstrateSingleton(void){
    UserManager *manager1 = [UserManager sharedInstance];
    UserManager *manager2 = [UserManager sharedInstance];
    // 验证是否一个地址
    NSLog(@"manager1 的地址 %p", manager1);
    NSLog(@"manager2 的地址 %p", manager2);
    
    manager1.currentUserName = @"张彧";
    NSLog(@"通过manager1 设置用户名 %@",manager1.currentUserName);
    NSLog(@"通过manager2 获取用户名 %@",manager2.currentUserName);
}

void demostrateNotification(void){
    NSLog(@"\n==== 通知机制演示 ====\n");
    BusinessModuleA *moduleA = [[BusinessModuleA alloc] init];
    BusinessModuleB *moduleB = [[BusinessModuleB alloc] init];
    
    // 开始监听
    [moduleA startListening];
    [moduleB startListening];

    // 获取用户管理单例
    UserManager *userManager = [UserManager sharedInstance];
    NSLog(@"\n--- 测试登录 ---");
    [userManager loginWithUsername:@"张三" toke:@"token_abc123"];
    
    // 等待一下，让通知处理完成
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    
    NSLog(@"\n--- 测试数据更新 ---");
    [userManager upateUserProfile:@{
        @"nickname": @"小张",
        @"age": @25,
        @"city": @"北京"
    }];
    
    // 等待一下
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];

    NSLog(@"\n--- 测试退出登录 ---");
    [userManager logout];

    // 等待一下
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];

    NSLog(@"\n--- 停止监听 ---");
    [moduleA stopListening];
    [moduleB stopListening];
    
}
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        demonstrateSingleton();
        
        demostrateNotification();
        
    }
    return 0;
}

// 演示多线程环境下的单例
void demonstrateThreadSafety(void) {
    NSLog(@"\n=== 多线程单例安全性演示 ===");
    dispatch_group_t group = dispatch_group_create();

    // 在多个线程中同时获取单例
    for (int i = 0; i < 5; i++) {
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UserManager *manager = [UserManager sharedInstance];
            NSLog(@"线程%d获取的单例地址: %p", i, manager);
        });
    }

    // 等待所有线程完成
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"多线程测试完成 - 所有地址应该相同");
}
// 演示通知的移除重要性
void demonstrateNotificationRemoval(void) {
    NSLog(@"\n=== 通知移除重要性演示 ===");
    // 创建一个临时监听者
    BusinessModuleA *tempModule = [[BusinessModuleA alloc] init];
    [tempModule startListening];

    // 发送通知
    UserManager *userManager = [UserManager sharedInstance];
    [userManager loginWithUsername:@"临时用户" toke:@"temp_token"];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];

    // 手动移除监听（模拟对象销毁前的清理）
    [tempModule stopListening];

    // 再次发送通知，tempModule不应该收到
    NSLog(@"移除监听后再次发送通知:");
    [userManager logout];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];

    NSLog(@"通知移除演示完成");
    
}
