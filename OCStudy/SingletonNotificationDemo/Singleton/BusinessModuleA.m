//
//  BusinessModuleA.m
//  Singleton
//
//  Created by ByteDance on 2025/7/10.
//

#import "BusinessModuleA.h"
#import "NotificationNames.h"
@implementation BusinessModuleA

-(instancetype)init{
    [super self];
    NSLog(@"BussinessModuleA 初始化");
    return self;
}

// 注册监听
- (void)startListening{
    NSLog(@"BusinessModuleA 开始监听通知");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserDidLogin:) name:UserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserDidLogout:) name:UserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataUpdate:) name:DataDidUpdateNotification object:nil];
}

- (void)handleUserDidLogin:(NSNotification *)notification{
    NSString *username = notification.userInfo[@"username"];
    NSString *token = notification.userInfo[@"token"];
    NSDate *loginTime = notification.userInfo[@"loginTime"];
    NSLog(@"BusinessModuleA 收到登录通知: 用户=%@, token=%@, 时间=%@",username, token, loginTime);

    [self onUserLogin:username];
}

- (void)handleUserDidLogout:(NSNotification *)notification{
    NSString *username = notification.userInfo[@"username"];
    NSDate *logoutTime = notification.userInfo[@"logoutTime"];
    NSLog(@"BusinessModuleA 收到退出通知: 用户=%@, 时间=%@", username, logoutTime);
    
    [self onUserLogout:username];
}
    
- (void)handleDataUpdate:(NSNotification *)notification{
    NSString *type = notification.userInfo[@"type"];
    NSDictionary *data = notification.userInfo[@"data"];
    NSDate *updateTime = notification.userInfo[@"updateTime"];
    NSLog(@"BusinessModuleA 收到数据更新通知: 类型=%@, 数据=%@, 时间=%@",type, data, updateTime);

    if ([type isEqualToString:@"userProfile"]) {
        [self onUserProfileUpdate:data];
    }
}
    
    
- (void)onUserLogin:(NSString *)username {
    NSLog(@"BusinessModuleA 执行登录后逻辑: 为用户 %@ 加载个人数据", username);
}
    
- (void)onUserLogout:(NSString *)username {
    NSLog(@"BusinessModuleA 执行退出后逻辑: 清理用户 %@ 的缓存数据", username);
}

- (void)onUserProfileUpdate:(NSDictionary *)profileData {
    NSLog(@"BusinessModuleA 执行资料更新逻辑: 刷新用户界面显示");
}

- (void)stopListening {
    NSLog(@"BusinessModuleA 停止监听通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    
- (void)dealloc {
    NSLog(@"BusinessModuleA 销毁，移除通知监听");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
