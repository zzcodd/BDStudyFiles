//
//  NetWorkDemo.m
//  NetWork
//
//  Created by ByteDance on 2025/7/11.
//

#import "NetWorkDemo.h"

@implementation NetWorkDemo

- (void)performGETRequest {
    NSLog(@"=== GET请求演示 ===");
    
    // 1. 创建URL
    NSURL *url = [NSURL URLWithString:@"https://jsonplaceholder.typicode.com/posts/1"];
    
    // 2. 创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 4. 创建数据任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // 回调在子线程执行，需要切换到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"GET请求失败: %@", error.localizedDescription);
                return;
            }
            
            // 检查HTTP状态码
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"GET响应状态码: %ld", (long)httpResponse.statusCode);
            NSLog(@"GET响应头: %@", httpResponse.allHeaderFields);
            
            if (httpResponse.statusCode == 200) {
                // 解析JSON数据
                NSError *jsonError;
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&jsonError];
                if (jsonData) {
                    NSLog(@"GET请求成功:");
                    NSLog(@"标题: %@", jsonData[@"title"]);
                    NSLog(@"内容: %@", jsonData[@"body"]);
                    NSLog(@"用户ID: %@", jsonData[@"userId"]);
                } else {
                    NSLog(@"JSON解析失败: %@", jsonError.localizedDescription);
                }
            } else {
                NSLog(@"GET请求HTTP错误: %ld", (long)httpResponse.statusCode);
            }
        });
    }];
    
    // 5. 开始任务
    [dataTask resume];
}


- (void)performPOSTRequest {
    NSLog(@"=== POST请求演示 ===");
    
    // 1. 创建URL
    NSURL *url = [NSURL URLWithString:@"https://jsonplaceholder.typicode.com/posts"];
    
    // 2. 创建可变请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 3. 设置HTTP方法
    [request setHTTPMethod:@"POST"];
    
    // 4. 设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // 5. 准备POST数据
    NSDictionary *postData = @{
        @"title": @"测试标题",
        @"body": @"这是一条测试内容",
        @"userId": @1
    };
    
    // 6. 将字典转换为JSON数据
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jsonError];
    
    if (jsonError) {
        NSLog(@"JSON序列化失败: %@", jsonError.localizedDescription);
        return;
    }
    
    // 7. 设置请求体
    [request setHTTPBody:jsonData];
    
    // 8. 设置超时时间
    [request setTimeoutInterval:30.0];
    
    // 9. 创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 10. 创建数据任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"POST请求失败: %@", error.localizedDescription);
                return;
            }
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"POST响应状态码: %ld", (long)httpResponse.statusCode);
            
            if (httpResponse.statusCode == 201) { // 创建成功
                NSError *responseJsonError;
                NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:0
                                                                               error:&responseJsonError];
                if (responseData) {
                    NSLog(@"POST请求成功:");
                    NSLog(@"创建的ID: %@", responseData[@"id"]);
                    NSLog(@"返回的标题: %@", responseData[@"title"]);
                } else {
                    NSLog(@"POST响应JSON解析失败: %@", responseJsonError.localizedDescription);
                }
            } else {
                NSLog(@"POST请求HTTP错误: %ld", (long)httpResponse.statusCode);
            }
        });
    }];
    
    // 11. 开始任务
    [dataTask resume];
}

#pragma mark - 文件下载演示
- (void)performDownloadRequest {
    NSLog(@"=== 文件下载演示 ===");
    
    // 1. 创建URL
    NSURL *url = [NSURL URLWithString:@"https://httpbin.org/image/jpeg"];
    
    // 2. 创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3. 创建下载任务
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url
                                                        completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"下载失败: %@", error.localizedDescription);
                return;
            }
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"下载响应状态码: %ld", (long)httpResponse.statusCode);
            
            if (httpResponse.statusCode == 200) {
                // 获取文档目录路径
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"downloaded_image.jpg"];
                
                // 移动文件到目标位置
                NSError *moveError;
                BOOL success = [[NSFileManager defaultManager] moveItemAtURL:location
                                                                       toURL:[NSURL fileURLWithPath:filePath]
                                                                       error:&moveError];
                
                if (success) {
                    NSLog(@"文件下载成功，保存路径: %@", filePath);
                    
                    // 获取文件大小
                    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
                    NSNumber *fileSize = [attributes objectForKey:NSFileSize];
                    NSLog(@"文件大小: %@ bytes", fileSize);
                } else {
                    NSLog(@"文件移动失败: %@", moveError.localizedDescription);
                }
            } else {
                NSLog(@"下载HTTP错误: %ld", (long)httpResponse.statusCode);
            }
        });
    }];
    
    // 4. 开始下载
    [downloadTask resume];
}

@end
