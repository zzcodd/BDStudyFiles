//
//  MainTabBarController.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/16.
//

#import "MainTabBarController.h"
#import "BookCity/BookCityViewController.h"
#import "Bookshelf/BookshelfViewController.h"
#import "profile/ProfileViewController.h"
#import "ShortDrama/ShortDramaViewController.h"
#import "Welfare/WelfareViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabBar];
    [self setupViewControllers];
}

- (void)setupTabBar{
    // 整体样式
    self.tabBar.backgroundColor = [UIColor systemBackgroundColor];
    self.tabBar.tintColor = [UIColor blackColor];    // 选中
    self.tabBar.unselectedItemTintColor = [UIColor systemGrayColor];    // 未选中
        
    // 边框
    self.tabBar.layer.borderWidth = 0.5;
    self.tabBar.layer.borderColor = [UIColor systemGray4Color].CGColor;
}

- (void)setupViewControllers{
    
    // SF Symbols
    UIViewController *bookCityVC = [self createTabViewController:[BookCityViewController new] title:@"书城" imageName:@"book" selectedImageName:@"book.fill"];
    UIViewController *shortDramaVC = [self createTabViewController:[ShortDramaViewController new] title:@"短剧" imageName:@"tv" selectedImageName:@"tv.fill"];
    UIViewController *welfareVC = [self createTabViewController:[WelfareViewController new] title:@"福利" imageName:@"gift" selectedImageName:@"gift.fill"];
    UIViewController *bookshelfVC = [self createTabViewController:[BookshelfViewController new] title:@"书架" imageName:@"books.vertical" selectedImageName:@"book.vertical.fill"];
    UIViewController *profileVC = [self createTabViewController:[ProfileViewController new] title:@"我的" imageName:@"person" selectedImageName:@"person.fill"];
    
    // 设置TabBarController 的 ViewControllers
    self.viewControllers = @[bookCityVC, shortDramaVC, welfareVC, bookshelfVC, profileVC];
    self.selectedIndex = 0;
}

// 创建页面控制器
- (UIViewController *)createTabViewController:(UIViewController *)viewController
                                        title:(NSString *)title
                                    imageName:(NSString *)imageName
                            selectedImageName:(NSString *)selectedImageName{
    
    // 创建NavigationController包装每个Tab
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    // 设置样式
    navController.navigationBar.backgroundColor = [UIColor systemBackgroundColor];
    navController.navigationBar.tintColor = [UIColor labelColor];
    
    // 设置TabBarItem
    navController.tabBarItem.title = title;
    navController.tabBarItem.image = [UIImage systemImageNamed:imageName];
    navController.tabBarItem.selectedImage = [UIImage systemImageNamed:selectedImageName];
    
    // 设置TabBarItem的字体样式
    [navController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    
    return navController;
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
