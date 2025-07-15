//
//  main.m
//  JsonStudy
//
//  Created by ByteDance on 2025/7/9.
//

#import <Foundation/Foundation.h>
#import "JSONParser.h"



int main(int argc, const char * argv[]) {
    @autoreleasepool {
  
        NSLog(@"🚀 JSON学习Demo - 核心功能");
        
        // 1. 网络JSON解析
        NSLog(@"\n=== 网络JSON解析 ===");
        [JSONParser loadNetworkJSON];
        
        // 2. 本地JSON文件解析
        NSLog(@"\n=== 本地JSON解析 ===");
        // 使用您提供的文件路径
        NSString *filePath = @"/Users/bytedance/projects/code-learning/bussine_new_member/zhangyu/xcode_study_demo/OCStudy/JsonStudy/JsonStudy/myFile.json";
        [JSONParser loadLocalJSONFile:filePath];
        
        // 等待网络请求完成（简单的延迟，实际项目中不建议这样做）
        NSLog(@"\n⏳ 等待网络请求完成...");
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3.0]];
        
        NSLog(@"\n🎉 Demo完成");

    }
    
    
    return 0;
}

