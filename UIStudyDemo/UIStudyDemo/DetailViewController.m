//
//  DetailViewController.m
//  UIStudyDemo
//
//  Created by ByteDance on 2025/7/8.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemGrayColor];
    NSLog(@"📋 DetailViewController加载，显示选中的项目：%@", self.selectedItem);

    [self setupDetailView];
}

- (void)setupDetailView {
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"从UITableViewCell跳转来的详情页";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(20, 150, self.view.bounds.size.width - 40, 30);
    [self.view addSubview:titleLabel];
    
    // 选中项目显示
    UILabel *itemLabel = [[UILabel alloc] init];
    itemLabel.text = [NSString stringWithFormat:@"您选择了：%@", self.selectedItem];
    itemLabel.font = [UIFont systemFontOfSize:16];
    itemLabel.textAlignment = NSTextAlignmentCenter;
    itemLabel.textColor = [UIColor systemBlueColor];
    itemLabel.frame = CGRectMake(20, 200, self.view.bounds.size.width - 40, 30);
    [self.view addSubview:itemLabel];
    
    // 说明文字
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"这演示了UITableView的cell点击\n→ 导航跳转 → 数据传递的完整流程";
    descLabel.numberOfLines = 2;
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = [UIColor blackColor];
    descLabel.frame = CGRectMake(20, 250, self.view.bounds.size.width - 40, 50);
    [self.view addSubview:descLabel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
