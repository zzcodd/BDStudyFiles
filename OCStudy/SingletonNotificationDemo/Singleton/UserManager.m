//
//  UserManager.m
//  Singleton
//
//  Created by ByteDance on 2025/7/9.
//

#import "UserManager.h"
#import "NotificationNames.h"

@implementation UserManager

static UserManager *instance = nil;
+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserManager alloc] init];
    });
    return instance;
}

-(instancetype)copyWithZone:(NSZone *)zone{
    return instance;
}

-(instancetype)mutableCopyWithZone:(NSZone *)zone{
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化默认值
        self.currentUserName = @"";
        self.userToken = @"";
        self.isLogged = NO;
        
        // 加载保存的用户数据
        [self loadUserData];
    }
    return self;
}

-(void)loginWithUsername:(NSString *)username toke:(NSString *)token{
    _currentUserName = username;
    _userToken = token;
    _isLogged = YES;
    
    [self saveUserData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:self userInfo:@{
        @"username": username,
        @"token": token,
        @"loginTime": [NSDate date]
        }];
    
    NSLog(@"用户 %@ 登录成功", username);
}

-(void)logout{
    NSString *oldUsername = self.currentUserName;
    
    self.currentUserName = @"";
    self.userToken = @"";
    self.isLogged = NO;
    
    [self saveUserData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:self userInfo:@{
        @"username": oldUsername,
        @"logoutTime": [NSDate date]}
    ];
    
    NSLog(@"用户退出登录");

}

-(void)upateUserProfile:(NSDictionary *)profileData{
    NSLog(@"UserManager:更新用户资料%@",profileData);
    [[NSNotificationCenter defaultCenter] postNotificationName:DataDidUpdateNotification object:self userInfo:@{@"type":@"userProfile", @"data":profileData, @"updataTime":[NSDate date]}];
}

- (void)saveUserData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.currentUserName forKey:@"currentUserName"];
    [defaults setObject:self.userToken forKey:@"userToken"];
    [defaults setBool:self.isLogged forKey:@"isLoggedIn"];
    [defaults synchronize];
}

- (void)loadUserData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currentUserName = [defaults stringForKey:@"currentUserName"] ?: @"";
    self.userToken = [defaults stringForKey:@"userToken"] ?: @"";
    self.isLogged = [defaults boolForKey:@"isLoggedIn"];
}
@end
