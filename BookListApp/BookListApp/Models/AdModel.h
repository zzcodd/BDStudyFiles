//
//  AdModel.h
//  BookListApp
//
//  Created by ByteDance on 2025/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdModel : NSObject

@property(nonatomic, copy) NSString *title;             // 广告标题
@property(nonatomic, copy) NSString *subTitle;          // 副标题
@property(nonatomic, copy) NSString *adDescription;     // 广告描述
@property(nonatomic, copy) NSString *downloadUrl;       // 下载链接
@property(nonatomic, copy) NSString *imageUrl;          // 图片URL
@property(nonatomic, copy) NSString *webTitle;          // web页面标题
@property(nonatomic, copy) NSString *appInstall;        // 应用安装数
@property(nonatomic, copy) NSString *appLike;           // 应用评分
@property(nonatomic, copy) NSString *appId;             // 应用ID
@property(nonatomic, copy) NSString *buttonText;        // 按钮文字
@property(nonatomic, copy) NSString *packageName;       // 应用包名

#pragma mark - 数值转换
/*
 应用评分
 */
- (CGFloat)appRatingValue;

/*
 安装数
 */
- (NSInteger)installCountValue;

#pragma mark - 便利构造
+ (instancetype)adWithDictionary:(NSDictionary *)dict;

#pragma mark - 实用方法
/*
 格式化的评分
 */
- (NSString *)formattedRating;

/*
 格式化安装数
 */
- (NSString *)formattedInstallCount;

/*
 是否有效
 */
- (BOOL)isVaildAD;

/*
 是否有效的图片URL
 */
- (BOOL)isVaildImageUrl;
@end

NS_ASSUME_NONNULL_END
