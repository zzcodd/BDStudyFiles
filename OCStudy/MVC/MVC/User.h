//
//  User.h
//  MVC
//
//  Created by ByteDance on 2025/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *email;
@property(nonatomic, assign) NSInteger age;
@property(nonatomic, copy) NSString *userID;

- (instancetype)initWithName:(NSString *)name email:(NSString *)email age:(NSInteger)age;
- (BOOL)isValidEmail;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
