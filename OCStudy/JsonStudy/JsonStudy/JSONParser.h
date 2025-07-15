//
//  JSONParser.h
//  JsonStudy
//
//  Created by ByteDance on 2025/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSONParser : NSObject

/**
 * 从网络加载JSON数据并解析
 */
+ (void)loadNetworkJSON;

/**
 * 从本地文件加载JSON数据并解析
 * @param filePath 文件路径
 */
+ (void)loadLocalJSONFile:(NSString *)filePath;



/**
 * 演示模型转换功能
 * @param jsonData JSON数据
 */
+ (void)demonstrateModelConversion:(NSData *)jsonData;


@end

NS_ASSUME_NONNULL_END
