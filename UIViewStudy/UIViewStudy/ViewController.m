#import "ViewController.h"
#import "CustomView.h"  // 导入自定义控件

@interface ViewController ()
@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
//     使用封装后的控件
    [self useCustomViews];
    
}

-(void)useCustomViews{
    // 1.使用封装的CustomView
    CustomView *customView = [CustomView createViewWithFrame:CGRectMake(50, 100, 150, 100) color:[UIColor systemRedColor] cornerRadius:15];
    [customView setCustonShadow];
    [customView setBorderWithWidth:2 color:[UIColor darkGrayColor]];
    [self.view addSubview:customView];
    
    // 2.使用封装的CustomButton
    CustomButton *priButton = [CustomButton primaryButtonWithTitle:@"主要按钮"];
    priButton.frame = CGRectMake(50, 220, 120, 50);
    [priButton addTarget:self action:@selector(primaryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:priButton];
    
    CustomButton *sndButton = [CustomButton secondaryButtonWithTitle:@"次要按钮"];
    sndButton.frame = CGRectMake(180, 220, 120, 50);
    [sndButton addTarget:self action:@selector(secondaryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sndButton];
    
    // 3.使用封装的CustomLabel
    CustomLabel *titleLabel = [CustomLabel titleLabelWithText:@"标题文本"];
    titleLabel.frame = CGRectMake(50, 330, 250, 60);
    [self.view addSubview:titleLabel];
    
    CustomLabel *contentLabel = [CustomLabel contentLabelWithText:@"这是内容文本，可以自动换行使用 \n \n你好呀"];
    contentLabel.frame = CGRectMake(50, 330, 250, 60);
    [contentLabel setMultilineText:contentLabel.text];
    [self.view addSubview:contentLabel];
    
    // 4.使用封装的CustomImageView
    CustomImageView *circleImageView = [CustomImageView circleImageViewWithFrame:CGRectMake(50, 410, 80, 80)];
    circleImageView.backgroundColor = [UIColor systemPinkColor];
    [self.view addSubview:circleImageView];
    
    CustomImageView *roundedImageView = [CustomImageView roundedImageViewWithFrame:CGRectMake(150, 410, 80, 80) cornerRadius:10];
    roundedImageView.backgroundColor = [UIColor systemGreenColor];
    [self.view addSubview:roundedImageView];
    
    NSLog(@"✅ 所有自定义控件创建完成！");

    
}

#pragma mark - 按钮事件
- (void)primaryButtonTapped:(CustomButton *)button{
    NSLog(@"🔘 主要按钮被点击");
    
    // 演示封装的便捷方法
    [button setLoadingState:YES];
    NSLog(@"111");
    // 2秒后恢复正常状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [button setLoadingState:NO];
    });
}

- (void)secondaryButtonTapped:(CustomButton *)button {
    NSLog(@"🔘 次要按钮被点击");
    
    // 简单的动画效果
    [UIView animateWithDuration:0.3 animations:^{
        button.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            button.transform = CGAffineTransformIdentity;
        }];
    }];
}
@end
