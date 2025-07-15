//
//  JSONParser.h
//  BookListApp
//
//  Created by ByteDance on 2025/7/14.
//

#import <Foundation/Foundation.h>
#import "../Models/AdModel.h"
#import "../Models/BookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSONParser : NSObject

#pragma mark - 同步解析
/*
 解析JSON数据成BookModel
 */
+ (NSArray<BookModel *> *)parseBookListFromFile:(NSString *)filename;

/*
 解析JSON数据成AdModel
 */
+ (AdModel *)parseADFromFile:(NSString *)filename;

#pragma mark - 异步解析
/*
异步解析书籍列表JSON文件
 */
- (void)parseBookListFromFileAsync:(NSString *)filename
                         completion:(void(^)(NSArray<BookModel *> * books, NSError * error))completion;

/*
 * 异步解析广告JSON文件
 */
- (void)parseAdFromFileAsync:(NSString *)filename
                  completion:(void(^)(AdModel *ad, NSError * error))completion;

#pragma mark - 工具方法
/*
 文件名是否存在
 */
+ (BOOL)checkJSONFileExists:(NSString *)filename;

/*
 获取完整路径
 */
+ (NSString *)pathForJSONFile:(NSString *)filename;
@end

NS_ASSUME_NONNULL_END
