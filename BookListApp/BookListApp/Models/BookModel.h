//
//  BookModel.h
//  BookListApp
//
//  Created by ByteDance on 2025/7/14.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookModel : NSObject

@property(nonatomic, copy) NSString *abstract;  // 摘要
@property(nonatomic, copy) NSString *author;    // 作者
@property(nonatomic, copy) NSString *bookId;    // 书本ID
@property(nonatomic, copy) NSString *bookName;  // 书名
@property(nonatomic, copy) NSString *thumbUrl;  // 封面图片
@property(nonatomic, copy) NSString *score;     // 书籍评分
@property(nonatomic, copy) NSString *category;  // 分类
@property(nonatomic, copy) NSString *subInfo;   // 阅读人数
@property(nonatomic, copy) NSString *tags;      // 标签
@property(nonatomic, copy) NSString *wordNumber;    // 字数
@property(nonatomic, copy) NSString *chapterNumber; // 章节数

#pragma mark - 对于数值类型进行转换
- (CGFloat)scoreValue;
- (NSInteger)wordNumberValue;
- (NSInteger)chapterNumberValue;

#pragma mark - 构造方法
/*
 从字典转换成BookModel
 */
+ (instancetype)bookWithDictionary:(NSDictionary *)dict;

#pragma mark - 便捷方法
/*
 格式化书籍评分
 */
- (NSString *)formattedScore;

/*
 格式化字数
 */
- (NSString *)formattedWordNumber;

/*
 获取具体的tags
 */
- (NSArray<NSString *> *)tagArray;

/*
 检查书籍是否有效
 */
- (BOOL)isVaildBook;

/*
 拓展一个不同分类返回不同颜色的方法
 */
- (UIColor *)categoryColor;

@end

NS_ASSUME_NONNULL_END
