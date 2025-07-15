//
//  UserModel.h
//  JsonStudy
//
//  Created by ByteDance on 2025/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Geo : NSObject
    @property (nonatomic, copy) NSString * lat;
    @property (nonatomic, copy) NSString * lng;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionaty;
@end

@interface Address : NSObject
    @property (nonatomic, copy) NSString * street;
    @property (nonatomic, copy) NSString * suite;
    @property (nonatomic, copy) NSString * city;
    @property (nonatomic, copy) NSString * zipcode;
    @property (nonatomic, strong) Geo *geo;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end

@interface Company : NSObject
    @property (nonatomic, copy) NSString * name;
    @property (nonatomic, copy) NSString * catchPhrase;
    @property (nonatomic, copy) NSString * bs;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end



@interface Skill : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, assign) NSInteger years;

// 转换方法
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;
@end


@interface Project : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *projectDescription; // 避免与系统description冲突
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSArray<NSString *> *technologies;
// 转换方法
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;
@end



@interface UserModel : NSObject
    @property (nonatomic, assign) NSInteger userId; // 改名避免与系统id冲突
    @property (nonatomic, copy) NSString *name;
    @property (nonatomic, copy) NSString *username;
    @property (nonatomic, copy) NSString *email;
    @property (nonatomic, copy) NSString *phone;
    @property (nonatomic, copy) NSString *website;
    @property (nonatomic, assign) NSInteger age;
    @property (nonatomic, strong) Address *address;
    @property (nonatomic, strong) NSArray<NSString *> *hobbies;
    @property (nonatomic, strong) Company *company;
    @property (nonatomic, assign) BOOL isActive;
    @property (nonatomic, copy) NSString *joinDate;
    @property (nonatomic, strong) NSArray<Skill *> *skills;
    @property (nonatomic, strong) NSArray<Project *> *projects;

#pragma  mark - 创建方法
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelWithJSONString:(NSString *)jsonString;
+ (instancetype)modelWithJSONData:(NSData *)jsonData;

- (NSDictionary *)toDictionary;
- (NSString *)toJSONString;
- (NSData *)toJSONData;

- (void)printModelInfo;
@end




NS_ASSUME_NONNULL_END
