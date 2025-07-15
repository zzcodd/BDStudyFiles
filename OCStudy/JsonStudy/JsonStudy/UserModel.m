//
//  UserModel.m
//  JsonStudy
//
//  Created by ByteDance on 2025/7/11.
//

#import "UserModel.h"
#pragma mark - Geo Implementation

@implementation Geo
+ (instancetype)modelWithDictionary:(NSDictionary *)dict{
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]){
        return nil;
    }
    Geo *model = [[Geo alloc] init];
    model.lat = dict[@"lat"]?:@"";
    model.lng = dict[@"lng"]?:@"";
    return model;
}

- (NSDictionary *)toDictionaty{
    return @{
        @"lat":self.lat?:@"",
        @"l":self.lng?:@""
    };
}
@end

@implementation Address

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    Address *model = [[Address alloc] init];
    model.street = dict[@"street"] ?: @"";
    model.suite = dict[@"suite"] ?: @"";
    model.city = dict[@"city"] ?: @"";
    model.zipcode = dict[@"zipcode"] ?: @"";
    
    // 处理嵌套的Geo对象
    NSDictionary *geoDict = dict[@"geo"];
    if([geoDict isKindOfClass:[NSDictionary class]]){
        model.geo = [Geo modelWithDictionary:geoDict];
    }
    
    return model;
}

- (NSDictionary *)toDictionary{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"street"] = self.street ?: @"";
    dict[@"suite"] = self.suite ?: @"";
    dict[@"city"] = self.city ?: @"";
    dict[@"zipcode"] = self.zipcode ?: @"";
    
    if(self.geo){
        dict[@"geo"] = [self.geo toDictionaty];
    }
    
    return [dict copy];
}

@end

#pragma mark - Company Implementation

@implementation Company

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    Company *model = [[Company alloc] init];
    model.name = dict[@"name"] ?: @"";
    model.catchPhrase = dict[@"catchPhrase"] ?: @"";
    model.bs = dict[@"bs"] ?: @"";
    
    return model;
}

- (NSDictionary *)toDictionary {
    return @{
        @"name": self.name ?: @"",
        @"catchPhrase": self.catchPhrase ?: @"",
        @"bs": self.bs ?: @""
    };
}

@end

#pragma mark - Skill Implementation

@implementation Skill

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    Skill *model = [[Skill alloc] init];
    model.name = dict[@"name"] ?: @"";
    model.level = dict[@"level"] ?: @"";
    model.years = [dict[@"years"] integerValue];
    
    return model;
}

- (NSDictionary *)toDictionary {
    return @{
        @"name": self.name ?: @"",
        @"level": self.level ?: @"",
        @"years": @(self.years)
    };
}

@end

#pragma mark - Project Implementation

@implementation Project

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    Project *model = [[Project alloc] init];
    model.name = dict[@"name"] ?: @"";
    model.projectDescription = dict[@"description"] ?: @""; // JSON中是description
    model.status = dict[@"status"] ?: @"";
    
    // 处理technologies数组
    NSArray *techArray = dict[@"technologies"];
    if ([techArray isKindOfClass:[NSArray class]]) {
        model.technologies = techArray;
    }
    
    return model;
}

- (NSDictionary *)toDictionary {
    return @{
        @"name": self.name ?: @"",
        @"description": self.projectDescription ?: @"", // 转回JSON时用description
        @"status": self.status ?: @"",
        @"technologies": self.technologies ?: @[]
    };
}

@end

#pragma mark - UserModel Implementation
@implementation UserModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict{
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]){
        NSLog(@"无效的字典数据");
        return nil;
    }
    UserModel *model = [[UserModel alloc] init];
    
    // 基本属性映射
    model.userId = [dict[@"id"] integerValue]; // JSON中是id，模型中是userId
    model.name = dict[@"name"] ?: @"";
    model.username = dict[@"username"] ?: @"";
    model.email = dict[@"email"] ?: @"";
    model.phone = dict[@"phone"] ?: @"";
    model.website = dict[@"website"] ?: @"";
    model.age = [dict[@"age"] integerValue];
    model.isActive = [dict[@"isActive"] boolValue];
    model.joinDate = dict[@"joinDate"] ?: @"";
    
    // Address
    NSDictionary *addressDict = dict[@"address"];
    if([addressDict isKindOfClass:[NSDictionary class]]){
        model.address = [Address modelWithDictionary:addressDict];
    }
    
    // Hobbies
    NSArray *hobbiesArray = dict[@"hobbies"];
    if([hobbiesArray isKindOfClass:[NSArray class]]){
        model.hobbies = hobbiesArray;
    }
    
    // Company
    NSDictionary *companyDict = dict[@"company"];
    if([companyDict isKindOfClass:[NSDictionary class]]){
        model.company = [Company modelWithDictionary:companyDict];
    }
    
    // Skills
    NSArray *skillsArray = dict[@"skills"];
    if([skillsArray isKindOfClass:[NSArray class]]){
        NSMutableArray *skills = [NSMutableArray array];
        for (NSDictionary *skillDict in skillsArray){
            if([skillDict isKindOfClass:[NSDictionary class]]){
                Skill *sk = [Skill modelWithDictionary:skillDict];
                if(sk){
                    [skills addObject:sk];
                }
            }
        }
        model.skills = [skills copy];
    }
    
    // projects
    NSArray *projectsArray = dict[@"projects"];
    if([projectsArray isKindOfClass:[NSArray class]]){
        NSMutableArray *projects = [NSMutableArray array];
        for(NSDictionary *projectDict in projectsArray){
            if([projectDict isKindOfClass:[NSDictionary class]]){
                Project *project = [Project modelWithDictionary:projectDict];
                [projects addObject:project];
            }
        }
        model.projects = [projects copy];
    }
    
    
    return model;
}

+ (instancetype)modelWithJSONString:(NSString *)jsonString{
    if(!jsonString || jsonString.length == 0){
        NSLog(@"❌ JSON字符串为空");
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [self modelWithJSONData:jsonData];
}

+ (instancetype)modelWithJSONData:(NSData *)jsonData {
    if (!jsonData) {
        NSLog(@"❌ JSON数据为空");
        return nil;
    }
    
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (error) {
        NSLog(@"❌ JSON解析失败: %@", error.localizedDescription);
        return nil;
    }
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        return [self modelWithDictionary:jsonObject];
    } else {
        NSLog(@"❌ JSON数据不是字典格式");
        return nil;
    }
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"id"] = @(self.userId); // 转回JSON时用id
    dict[@"name"] = self.name ?: @"";
    dict[@"username"] = self.username ?: @"";
    dict[@"email"] = self.email ?: @"";
    dict[@"phone"] = self.phone ?: @"";
    dict[@"website"] = self.website ?: @"";
    dict[@"age"] = @(self.age);
    dict[@"isActive"] = @(self.isActive);
    dict[@"joinDate"] = self.joinDate ?: @"";
    
    if (self.address) {
        dict[@"address"] = [self.address toDictionary];
    }
    
    if (self.hobbies) {
        dict[@"hobbies"] = self.hobbies;
    }
    
    if (self.company) {
        dict[@"company"] = [self.company toDictionary];
    }
    
    if (self.skills && self.skills.count > 0) {
        NSMutableArray *skillsArray = [NSMutableArray array];
        for (Skill *skill in self.skills) {
            [skillsArray addObject:[skill toDictionary]];
        }
        dict[@"skills"] = skillsArray;
    }
    
    if (self.projects && self.projects.count > 0) {
        NSMutableArray *projectsArray = [NSMutableArray array];
        for (Project *project in self.projects) {
            [projectsArray addObject:[project toDictionary]];
        }
        dict[@"projects"] = projectsArray;
    }
    
    return [dict copy];
}

- (NSString *)toJSONString {
    NSData *jsonData = [self toJSONData];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSData *)toJSONData {
    NSDictionary *dict = [self toDictionary];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error) {
        NSLog(@"❌ 转换为JSON失败: %@", error.localizedDescription);
        return nil;
    }
    
    return jsonData;
}

#pragma mark - 工具方法

- (void)printModelInfo {
    NSLog(@"\n=== 👤 用户模型信息 ===");
    NSLog(@"用户ID: %ld", (long)self.userId);
    NSLog(@"姓名: %@", self.name);
    NSLog(@"用户名: %@", self.username);
    NSLog(@"邮箱: %@", self.email);
    NSLog(@"电话: %@", self.phone);
    NSLog(@"网站: %@", self.website);
    NSLog(@"年龄: %ld", (long)self.age);
    NSLog(@"状态: %@", self.isActive ? @"活跃" : @"非活跃");
    NSLog(@"加入日期: %@", self.joinDate);
    
    if (self.address) {
        NSLog(@"\n📍 地址信息:");
        NSLog(@"  街道: %@", self.address.street);
        NSLog(@"  套房: %@", self.address.suite);
        NSLog(@"  城市: %@", self.address.city);
        NSLog(@"  邮编: %@", self.address.zipcode);
        if (self.address.geo) {
            NSLog(@"  坐标: (%@, %@)", self.address.geo.lat, self.address.geo.lng);
        }
    }
    
    if (self.company) {
        NSLog(@"\n🏢 公司信息:");
        NSLog(@"  名称: %@", self.company.name);
        NSLog(@"  口号: %@", self.company.catchPhrase);
        NSLog(@"  业务: %@", self.company.bs);
    }
    
    if (self.hobbies && self.hobbies.count > 0) {
        NSLog(@"\n🎯 爱好:");
        for (NSString *hobby in self.hobbies) {
            NSLog(@"  - %@", hobby);
        }
    }
    
    if (self.skills && self.skills.count > 0) {
        NSLog(@"\n💪 技能:");
        for (Skill *skill in self.skills) {
            NSLog(@"  - %@: %@ (%ld年)", skill.name, skill.level, (long)skill.years);
        }
    }
    
    if (self.projects && self.projects.count > 0) {
        NSLog(@"\n🚀 项目:");
        for (Project *project in self.projects) {
            NSLog(@"  - %@: %@ [%@]", project.name, project.projectDescription, project.status);
            if (project.technologies && project.technologies.count > 0) {
                NSLog(@"    技术栈: %@", [project.technologies componentsJoinedByString:@", "]);
            }
        }
    }
    
    NSLog(@"==================\n");
}


@end
