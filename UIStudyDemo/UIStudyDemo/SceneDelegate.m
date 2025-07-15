//
//  SceneDelegate.m
//  UIStudyDemo
//
//  Created by ByteDance on 2025/7/8.
//

#import "SceneDelegate.h"
#import "DetailViewController.h"
#import "ProfileViewController.h"
#import "TableViewController.h"
#import "WebViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    
    // 创建三个标签控制器
    // 🔥 第1个标签：UITableView演示
    TableViewController *tableVC = [[TableViewController alloc] init];
    tableVC.title = @"列表";
    tableVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"列表" image:nil tag:0];
    UINavigationController *tableNav = [[UINavigationController alloc] initWithRootViewController:tableVC];
        

    // 🔥 第2个标签：WKWebView演示
   WebViewController *webVC = [[WebViewController alloc] init];
   webVC.title = @"网页";
   webVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"网页" image:nil tag:1];
   UINavigationController *webNav = [[UINavigationController alloc] initWithRootViewController:webVC];
       

   ProfileViewController *profileVC = [[ProfileViewController alloc] init];
   profileVC.title = @"我的";
   profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:nil tag:2];
   UINavigationController *profileNav = [[UINavigationController alloc]      initWithRootViewController:profileVC];
  
    
    // 创建UITabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[tableNav, webNav, profileNav];
    
    tabBarController.tabBar.barTintColor = [UIColor systemBrownColor];
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    NSLog(@"✅ 包含UITableView和WKWebView的应用创建完成！");

    
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
