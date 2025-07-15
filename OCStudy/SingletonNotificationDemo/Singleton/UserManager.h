//
//  UserManager.h
//  Singleton
//
//  Created by ByteDance on 2025/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject<NSCopying, NSMutableCopying>

+(instancetype)sharedInstance;

@property(nonatomic, strong) NSString *currentUserName;
@property(nonatomic, strong) NSString *userToken;
@property(nonatomic, assign) BOOL isLogged;

- (void)loginWithUsername:(NSString *)username toke:(NSString *)token;
- (void)logout;
- (void)upateUserProfile:(NSDictionary *)profileData;
- (void)saveUserData;
- (void)loadUserData;

@end

NS_ASSUME_NONNULL_END
