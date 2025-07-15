//
//  UserManager.h
//  MVC
//
//  Created by ByteDance on 2025/7/11.
//

#import <Foundation/Foundation.h>
#import "User.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject
+ (instancetype)sharedManager ;
- (NSArray<User *> *)getAllUsers;

- (void)addUser:(User *)user ;

- (void)removeUser:(User *)user ;

- (void)updateUser:(User *)user ;

- (User *)getUserByID:(NSString *)userID ;

@end

NS_ASSUME_NONNULL_END
