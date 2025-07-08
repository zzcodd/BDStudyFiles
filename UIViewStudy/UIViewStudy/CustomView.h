//
//  CustomView.h
//  UIViewStudy
//
//  Created by ByteDance on 2025/7/6.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

// 1.自定义UIView封装
@interface CustomView : UIView
+(instancetype)createViewWithFrame:(CGRect)frame
                             color:(UIColor *)color
                      cornerRadius:(CGFloat)radius;
// 设置阴影
-(void)setCustonShadow;
// 设置边框
-(void)setBorderWithWidth:(CGFloat)width color:(UIColor *)color;
@end

// 2.自定义UIButton封装
@interface CustomButton : UIButton
+(instancetype)primaryButtonWithTitle:(NSString *)title;
+(instancetype)secondaryButtonWithTitle:(NSString*)title;
-(void)setLoadingState:(BOOL)loading;
@end

// 3.自定义UILabel封装
@interface CustomLabel : UILabel
+(instancetype)titleLabelWithText:(NSString *)text;
+(instancetype)contentLabelWithText:(NSString *)text;
// 设置多行文本
-(void)setMultilineText:(NSString *)text;
@end

// 4.自定义UIImageView封装
@interface CustomImageView : UIImageView
// 创建图形图片视图
+(instancetype)circleImageViewWithFrame:(CGRect)frame;
// 创建圆角图片视图
+(instancetype)roundedImageViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius;
// 设置占位图片
-(void)setPlaceholderImage:(UIImage *)image;
@end

// 5.自定义UITableViewCell封装
@interface CustomTableViewCell : UITableViewCell
+(NSString *)reuseIdentifier;
-(void)configureWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
-(void)configureWithTitle:(NSString *)title subtitle:(NSString *)subtitle imageURL:(NSString *)imageURL;
@end

//====
NS_ASSUME_NONNULL_END
