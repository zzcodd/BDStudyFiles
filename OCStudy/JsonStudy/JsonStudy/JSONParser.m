//
//  JSONParser.m
//  JsonStudy
//
//  Created by ByteDance on 2025/7/9.
//

#import "JSONParser.h"
#import "UserModel.h"

@implementation JSONParser

+ (void)loadNetworkJSON{
    
    // 1.url
    NSURL *url = [NSURL URLWithString:@"https://jsonplaceholder.typicode.com/users/1"];
    
    // 2. 创建请求任务
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithURL:url
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // 3. 检查网络错误
        if (error) {
            NSLog(@"❌ 网络请求失败: %@", error.localizedDescription);
            return;
        }
        
        // 4. 检查HTTP状态码
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode != 200) {
                NSLog(@"❌ HTTP错误，状态码: %ld", (long)httpResponse.statusCode);
                return;
            }
        }
        
        NSLog(@"✅ 网络请求成功");
        
        // 5. 解析JSON并演示模型转换
        [self parseJSONData:data source:@"网络"];
        [self demonstrateModelConversion:data];
    }];

    [task resume];
    
}

+ (void)loadLocalJSONFile:(NSString *)filePath{
    NSLog(@"📁 开始读取本地JSON文件");
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){
        NSLog(@"文件不存在");
        return;
    }
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"文件读取成功 大小:%lu bytes", (unsigned long)jsonData.length);
    
    // 3. 解析JSON并演示模型转换
    [self parseJSONData:jsonData source:@"本地文件"];
    [self demonstrateModelConversion:jsonData];
}

+ (void)parseJSONData:(NSData *)data source:(NSString *)source{
    NSLog(@"\n=== 解析来自%@的JSON数据 ===", source);

    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        NSLog(@"❌ JSON解析失败: %@", error.localizedDescription);
        return;
    }
    
    if([jsonObject isKindOfClass:[NSDictionary class]]){
        [self handleJSONDictionary:(NSDictionary *)jsonObject];
    } else if([jsonObject isKindOfClass:[NSArray class]]){
        [self handleJSONArray:(NSArray *)jsonObject];
    } else {
        NSLog(@"未知的数据类型，无法转换");
    }
}


+ (void)handleJSONDictionary:(NSDictionary *)jsonDict {
    NSLog(@"📄 JSON类型: 字典对象");
    NSLog(@"包含 %lu 个键值对:", (unsigned long)jsonDict.count);
    
    // 遍历并显示键值对
    for (NSString *key in jsonDict) {
        id value = jsonDict[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSLog(@"  %@ = <嵌套对象> (%lu个属性)", key, (unsigned long)[(NSDictionary *)value count]);
        } else if ([value isKindOfClass:[NSArray class]]) {
            NSLog(@"  %@ = <数组> (%lu个元素)", key, (unsigned long)[(NSArray *)value count]);
        } else {
            NSLog(@"  %@ = %@", key, value);
        }
    }
}

+ (void)handleJSONArray:(NSArray *)jsonArray {
    NSLog(@"📋 JSON类型: 数组");
    NSLog(@"包含 %lu 个元素:", (unsigned long)jsonArray.count);
    
    for (NSInteger i = 0; i < MIN(jsonArray.count, 3); i++) { // 只显示前3个
        id item = jsonArray[i];
        NSLog(@"  [%ld] %@ (%@)", (long)i, item, [item class]);
    }
    
    if (jsonArray.count > 3) {
        NSLog(@"  ... 还有 %lu 个元素", (unsigned long)(jsonArray.count - 3));
    }
}

// 模型转换演示
+ (void)demonstrateModelConversion:(NSData *)jsonData{
    NSLog(@"\n🔄 === 模型转换演示 ===");

    // 1.JSON数据转模型
    UserModel *user = [UserModel modelWithJSONData:jsonData];
    if(user){
        NSLog(@"✅ JSON → 模型 转换成功");
        [user printModelInfo];

    }
    // 2. 模型 → JSON字符串
    NSString *jsonString = [user toJSONString];
    if (jsonString) {
        NSLog(@"✅ 模型 → JSON 转换成功");
        NSLog(@"转换后的JSON:\n%@", jsonString);
    } else {
        NSLog(@"❌ JSON → 模型 转换失败");
    }
    
    
}
@end
