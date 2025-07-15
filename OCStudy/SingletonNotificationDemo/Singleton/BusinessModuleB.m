//
//  BusinessModuleB.m
//  Singleton
//
//  Created by ByteDance on 2025/7/10.
//

#import "BusinessModuleB.h"
#import "NotificationNames.h"
@implementation BusinessModuleB

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"BusinessModuleB 初始化");
    }
    return self;
}

- (void)startListening{
    NSLog(@"BusinessModuleB 开始监听通知");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserDidLogin:) name:UserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserDidLogout:) name:UserDidLogoutNotification object:nil];

}

- (void)handleUserDidLogin:(NSNotification *)notification {
    NSString *username = notification.userInfo[@"username"];
    NSLog(@"BusinessModuleB 收到登录通知: 欢迎 %@，开始同步服务器数据", username);
    // 模拟网络同步
    [self syncDataFromServer];
}

- (void)handleUserDidLogout:(NSNotification *)notification {
    NSString *username = notification.userInfo[@"username"];
    NSLog(@"BusinessModuleB 收到退出通知: 再见 %@，停止数据同步", username);
    // 停止同步任务
    [self stopDataSync];
}

- (void)syncDataFromServer {
    NSLog(@"BusinessModuleB 开始从服务器同步数据...");
}

- (void)stopDataSync {
    NSLog(@"BusinessModuleB 停止数据同步");
}

- (void)stopListening {
    NSLog(@"BusinessModuleB 停止监听通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    NSLog(@"BusinessModuleB 销毁，移除通知监听");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
