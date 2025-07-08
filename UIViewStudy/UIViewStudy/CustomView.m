//
//  CustomView.m
//  UIViewStudy
//
//  Created by ByteDance on 2025/7/6.
//

#import "CustomView.h"

#pragma mark - CustomView实现
@implementation CustomView
+(instancetype)createViewWithFrame:(CGRect)frame color:(UIColor *)color cornerRadius:(CGFloat)radius{
    CustomView *view = [[CustomView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    return view;
}

-(void)setCustonShadow{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2,2);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 4;
    self.layer.masksToBounds = NO;
}

-(void)setBorderWithWidth:(CGFloat)width color:(UIColor *)color{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}
@end


#pragma mark - CustomButton实现
@implementation CustomButton
+(instancetype)primaryButtonWithTitle:(NSString *)title{
    CustomButton *button = [CustomButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor systemBlueColor];
    button.layer.cornerRadius = 8;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    return button;
}

+(instancetype)secondaryButtonWithTitle:(NSString *)title{
    CustomButton *button = [CustomButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor systemMintColor].CGColor;
    button.layer.cornerRadius = 8;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    return button;
}

-(void)setLoadingState:(BOOL)loading{
    if (loading) {
        self.enabled = NO;
        [self setTitle:@"加载中..." forState:UIControlStateNormal];
        self.backgroundColor = [UIColor systemGrayColor];
    } else {
        self.enabled = YES;
        [self setTitle:@"确定" forState:UIControlStateNormal];
        self.backgroundColor = [UIColor systemBlueColor];
    }
}

@end

#pragma mark - CustomLabel实现
@implementation CustomLabel
+(instancetype)titleLabelWithText:(NSString *)text{
    CustomLabel *label = [[CustomLabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    return label;
}

+(instancetype)contentLabelWithText:(NSString *)text{
    CustomLabel *label = [[CustomLabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    return label;
}

-(void)setMultilineText:(NSString *)text{
    self.text = text;
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
}

@end

#pragma mark - CustomImageView实现
@implementation CustomImageView
// 创建圆形图片视图
+ (instancetype)circleImageViewWithFrame:(CGRect)frame {
    CustomImageView *imageView = [[CustomImageView alloc] initWithFrame:frame];
    imageView.layer.cornerRadius = frame.size.width / 2;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

// 创建圆角图片视图
+ (instancetype)roundedImageViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius {
    CustomImageView *imageView = [[CustomImageView alloc] initWithFrame:frame];
    imageView.layer.cornerRadius = radius;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

// 设置占位图片
- (void)setPlaceholderImage:(UIImage *)image {
    if (!self.image) {
        self.image = image;
        self.backgroundColor = [UIColor systemGray5Color];
    }
}
@end

#pragma mark - CustomTableView实现
@implementation CustomTableView
+(instancetype)createTableViewWithStyle:(UITableViewStyle)style{
    CustomTableView *tableView = [[CustomTableView alloc] initWithFrame:CGRectZero style:style];
    tableView.backgroundColor = [UIColor systemBackgroundColor];
    tableView.separatorColor = [UIColor redColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 60;
    return tableView;
}

-(void)setupEmptyDataView:(NSString *)message{
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    emptyLabel.text = message;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.textColor = [UIColor systemGrayColor];
    emptyLabel.font = [UIFont systemFontOfSize:15];
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    [emptyView addSubview:emptyLabel];
    
    self.backgroundView = emptyView;
}

-(void)showLoadingIndicator{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    indicator.frame = CGRectMake(0, 0, 50, 50);
    [indicator startAnimating];
    
    UIView *loadingView = [[UIView alloc] init];
    loadingView.frame = CGRectMake(0, 0, 50, 50);
    [loadingView addSubview:indicator];
    
    self.backgroundView = loadingView;
}

- (void)hideLoadingIndicator {
    self.backgroundView = nil;
}

@end




@end
