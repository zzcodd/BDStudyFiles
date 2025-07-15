//
//  UserManager.m
//  MVC
//
//  Created by ByteDance on 2025/7/11.
//

#import "UserManager.h"
#import "User.h"

@interface UserManager ()
@property(nonatomic, strong) NSMutableArray<User *> *users;
@end

@implementation UserManager

+ (instancetype)sharedManager {
    static UserManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[UserManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init{
    self = [super init];
    if(self){
        _users = [[NSMutableArray alloc] init];
        [self loadSampleData];
    }
    return self;
}

- (void)loadSampleData{
    User *user1 = [[User alloc] initWithName:@"张三" email:@"zhangsan@example.com" age:25];
    User *user2 = [[User alloc] initWithName:@"李四" email:@"lisi@example.com" age:30];
    User *user3 = [[User alloc] initWithName:@"王五" email:@"wangwu@example.com" age:28];
    
    [self.users addObjectsFromArray:@[user1, user2, user3]];
}

- (NSArray<User *> *)getAllUsers{
    return [self.users copy];
}

- (void)addUser:(User *)user {
    if (user && user.name.length > 0) {
        [self.users addObject:user];
        NSLog(@"用户添加成功: %@", user.name);
    }
}

- (void)removeUser:(User *)user {
    if (user) {
        [self.users removeObject:user];
        NSLog(@"用户删除成功: %@", user.name);
    }
}

- (void)updateUser:(User *)user {
    NSInteger index = [self.users indexOfObject:user];
    if (index != NSNotFound) {
        [self.users replaceObjectAtIndex:index withObject:user];
        NSLog(@"用户更新成功: %@", user.name);
    }
}

- (User *)getUserByID:(NSString *)userID {
    for (User *user in self.users) {
        if ([user.userID isEqualToString:userID]) {
            return user;
        }
    }
    return nil;
}

@end
