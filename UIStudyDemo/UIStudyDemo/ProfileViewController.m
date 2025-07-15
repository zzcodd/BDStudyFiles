//
//  ProfileViewController.m
//  UIStudyDemo
//
//  Created by ByteDance on 2025/7/8.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemPurpleColor];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"个人中心页@zz\n\n体验完整的iOS应用架构：\n\n✅ UIWindow\n\n✅ UITabBarController\n\n✅ UINavigationController\n\n✅ UIViewController\n\n✅ UITableView\n\n✅ UITableViewCell\n\n✅ WKWebView";
    infoLabel.numberOfLines = 30;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.frame = CGRectMake(20, 200, self.view.bounds.size.width - 40, 400);
    [self.view addSubview:infoLabel];
    
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
