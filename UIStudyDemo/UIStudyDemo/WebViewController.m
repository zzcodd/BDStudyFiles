//
//  WebViewController.m
//  UIStudyDemo
//
//  Created by ByteDance on 2025/7/8.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"🌐 WebViewController加载，演示WKWebView");
    
    [self setupWebView];
    [self addControlButtons];
    [self loadWebsite];

}

-(void)setupWebView{
    
    // WKWebViewConfiguration 的核心作用是让你能够定制 WKWebView 的行为。即使你暂时不需要特殊配置，也必须创建这个对象并传入初始化方法，因为这是 WKWebView 的设计要求。

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
 
    self.webView.navigationDelegate = self;
    self.webView.frame = CGRectMake(0, 120, self.view.bounds.size.width, self.view.bounds.size.height-120);
    [self.view addSubview:self.webView];
    NSLog(@"🌐 WKWebView创建完成");
}

-(void)addControlButtons{
    // 创建按钮容器
    UIView *buttonContainer = [[UIView alloc] init];
    buttonContainer.backgroundColor = [UIColor systemGrayColor];
    buttonContainer.frame = CGRectMake(0, 40, self.view.bounds.size.width, 100);
    [self.view addSubview:buttonContainer];
    
    // 说明标签
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"WKWebView演示 - 网页浏览器";
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = [UIFont boldSystemFontOfSize:16];
    infoLabel.frame = CGRectMake(0, 10, self.view.bounds.size.width, 30);
    [buttonContainer addSubview:infoLabel];

    // 加载苹果官网按钮
    UIButton *appleButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 80, 40)];
    [appleButton setTitle:@"苹果官网" forState:UIControlStateNormal];
    appleButton.backgroundColor = [UIColor systemBlueColor];
    appleButton.layer.cornerRadius = 8;
    [appleButton addTarget:self action:@selector(loadAppleWebsite) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:appleButton];
    
    // 🔥 加载百度按钮
    UIButton *baiduButton = [[UIButton alloc] init];
    [baiduButton setTitle:@"百度" forState:UIControlStateNormal];
    [baiduButton setBackgroundColor:[UIColor systemGreenColor]];
    baiduButton.layer.cornerRadius = 8;
    baiduButton.frame = CGRectMake(120, 50, 80, 40);
    [baiduButton addTarget:self action:@selector(loadBaiduWebsite) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:baiduButton];
    
    // 🔥 后退按钮
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setTitle:@"后退" forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor systemOrangeColor]];
    backButton.layer.cornerRadius = 8;
    backButton.frame = CGRectMake(220, 50, 60, 40);
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:backButton];
    
    // 🔥 前进按钮
    UIButton *forwardButton = [[UIButton alloc] init];
    [forwardButton setTitle:@"前进" forState:UIControlStateNormal];
    [forwardButton setBackgroundColor:[UIColor systemPurpleColor]];
    forwardButton.layer.cornerRadius = 8;
    forwardButton.frame = CGRectMake(300, 50, 60, 40);
    [forwardButton addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:forwardButton];
}

- (void)loadWebsite {
    // 🔥 默认加载苹果官网
    [self loadAppleWebsite];
}

#pragma mark - 🔥 WKWebView操作方法
-(void)loadAppleWebsite{
    NSLog(@"🍎 加载苹果官网");
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com"]];
    [self.webView loadRequest:request];
}

- (void)loadBaiduWebsite {
    NSLog(@"🔍 加载百度网站");
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.webView loadRequest:request];
}

- (void)goBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        NSLog(@"⬅️ 网页后退");
    } else {
        NSLog(@"⬅️ 无法后退，已经是第一页");
    }
}

- (void)goForward {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
        NSLog(@"➡️ 网页前进");
    } else {
        NSLog(@"➡️ 无法前进，已经是最后一页");
    }
}

#pragma mark - 🔥 WKNavigationDelegate（网页导航代理）
// 🔥 网页开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"🌐 网页开始加载...");
    // 可以在这里显示加载指示器
}

// 🔥 网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"✅ 网页加载完成：%@", webView.URL.absoluteString);
    // 可以在这里隐藏加载指示器
}

// 🔥 网页加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"❌ 网页加载失败：%@", error.localizedDescription);
    // 可以在这里显示错误信息
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
