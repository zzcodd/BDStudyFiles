//
//  WebViewController.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/15.
//

#import "WebViewController.h"

@interface WebViewController ()<WKNavigationDelegate>

// UI组件
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) UILabel *errorLabel;
@property(nonatomic, strong) UIButton *retryButton;
@property(nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property(nonatomic, strong) UIProgressView *progressView;

// 状态
@property(nonatomic, assign) BOOL isLoading;

@end

@implementation WebViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupConstraints];
    [self loadWebContent];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 添加进度观察 (KVO)
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - UISetUp
- (void)setupUI{
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // 设置导航栏
    self.title = self.webTitle?:@"网页";
    // 关闭按钮
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped)];
    self.navigationItem.rightBarButtonItem = closeButton;
    // 刷新
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshButtonTapped)];
    self.navigationItem.leftBarButtonItem = refreshButton;
    // 网页配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlinePredictions = YES;
    config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    // 创建WebView
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES; // 支持手势返回
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    
    // 进度条
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progressTintColor = [UIColor systemBlueColor];
    self.progressView.trackTintColor = [UIColor systemGray5Color];
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.progressView];
    
    // 加载指示器
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.loadingIndicator.hidesWhenStopped = YES;
    self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.loadingIndicator];
    
    // 错误提示标签
    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.textColor = [UIColor secondaryLabelColor];
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    self.errorLabel.numberOfLines = 0;
    self.errorLabel.font = [UIFont systemFontOfSize:16];
    self.errorLabel.hidden = YES;
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.errorLabel];
    
    // 重试按钮
    self.retryButton = [[UIButton alloc] init];
    [self.retryButton setTitle:@"重新加载" forState:UIControlStateNormal];
    self.retryButton.backgroundColor = [UIColor systemBlueColor];
    [self.retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.retryButton.layer.cornerRadius = 8;
    self.retryButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.retryButton addTarget:self action:@selector(retryButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    self.retryButton.hidden = YES;
    self.retryButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.retryButton];
}

- (void)setupConstraints{
    // 进度条
    [NSLayoutConstraint activateConstraints:@[
        [self.progressView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.progressView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.progressView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.progressView.heightAnchor constraintEqualToConstant:2],
    ]];
    
    // WebView
    [NSLayoutConstraint activateConstraints:@[
        [self.webView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
    
    // 加载指示器
    [NSLayoutConstraint activateConstraints:@[
        [self.loadingIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.loadingIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];
    
    // 错误标签
    [NSLayoutConstraint activateConstraints:@[
        [self.errorLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.errorLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.errorLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:40],
        [self.errorLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor constant:-40],
    ]];
    
    // 重试按钮
    [NSLayoutConstraint activateConstraints:@[
        [self.retryButton.topAnchor constraintEqualToAnchor:self.errorLabel.bottomAnchor constant:20],
        [self.retryButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.retryButton.widthAnchor constraintEqualToConstant:120],
        [self.retryButton.heightAnchor constraintEqualToConstant:44],
    ]];
}

- (void)loadWebContent{
    if(!self.urlString || self.urlString.length == 0){
        [self showErrorWithMessage:@"网址不能为空"];
        return;
    }
    NSLog(@"🌐 WebViewController: 开始加载网页 - %@", self.urlString);
    // 显示加载状态
    [self showLoadingState];
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    if (!url) {
        [self showErrorWithMessage:@"网址格式不正确"];
        return;
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    [self.webView loadRequest:request];
}

#pragma mark - USER Actions
- (void)closeButtonTapped{
    NSLog(@"🌐 WebViewController: 用户点击关闭按钮");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshButtonTapped{
    NSLog(@"🌐 WebViewController: 用户点击刷新按钮");
    [self loadWebContent];
}
- (void)retryButtonTapped{
    NSLog(@"🌐 WebViewController: 用户点击重试按钮");
    [self loadWebContent];
}


#pragma mark - State Management
- (void)showErrorWithMessage:(NSString *)message{
    [self hideAllStates];
    self.errorLabel.text = message;
    self.errorLabel.hidden = NO;
    self.retryButton.hidden = NO;
}

- (void)showLoadingState{
    [self hideAllStates];
    [self.loadingIndicator startAnimating];
    self.progressView.alpha = 1;
}

- (void)showContentState{
    [self hideAllStates];
    self.webView.hidden = NO;
}

- (void)hideAllStates{
    [self.loadingIndicator stopAnimating];
    self.errorLabel.hidden = YES;
    self.retryButton.hidden = YES;
    self.loadingIndicator.hidden = NO;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"🌐 WebViewController: 开始加载网页");
    self.isLoading = YES;
    [self showLoadingState];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"🌐 WebViewController: 网页加载完成");
    self.isLoading = NO;
    [self showContentState];
    
    // 更新标题
    if (webView.title && webView.title.length > 0) {
        self.title = webView.title;
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"❌ WebViewController: 网页预加载失败 - %@", error.localizedDescription);
    self.isLoading = NO;
    
    if(error.code == NSURLErrorCancelled) return;
    
    [self showErrorWithMessage:[self friendlyErrorMessage:error]];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(WK_SWIFT_UI_ACTOR void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *originalUrl = navigationAction.request.URL;
    if (!originalUrl) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    NSString *originalUrlString = originalUrl.absoluteString;
    NSLog(@"🌐 原始导航请求：%@", originalUrlString);
    
    // 核心：替换错误协议 itms-appss:// → itms-apps://
    NSString *fixedUrlString = [originalUrlString stringByReplacingOccurrencesOfString:@"itms-appss://" withString:@"itms-apps://"];
    NSURL *fixedUrl = [NSURL URLWithString:fixedUrlString];
    
    if (![fixedUrlString isEqualToString:originalUrlString]) {
        NSLog(@"🌐 修正协议错误：%@ → %@", originalUrlString, fixedUrlString);
    }
    
    // 处理修正后的 URL
    NSString *scheme = fixedUrl.scheme.lowercaseString;
    
    // 1. 处理 App Store 协议（itms-apps://）
    if ([scheme isEqualToString:@"itms-apps"]) {
        [[UIApplication sharedApplication] openURL:fixedUrl options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"✅ 成功打开 App Store 客户端");
            } else {
                NSLog(@"❌ 打开 App Store 失败，尝试网页打开");
                // 转换为 HTTPS 链接（网页版）
                NSString *webUrlString = [fixedUrlString stringByReplacingOccurrencesOfString:@"itms-apps://" withString:@"https://"];
                NSURL *webUrl = [NSURL URLWithString:webUrlString];
                if (webUrl) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [webView loadRequest:[NSURLRequest requestWithURL:webUrl]];
                    });
                }
            }
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    // 2. 其他协议（http/https 等）正常加载
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"estimatedProgress"]){
        // 更新进度条
        float progress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        
        [self.progressView setProgress:progress animated:YES];
        
        if(progress>0 && progress<1.0){
            self.progressView.alpha = 1.0;
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                self.progressView.alpha = 0;
            }];
        }
    }
}

#pragma mark - Helper Methods

- (NSString *)friendlyErrorMessage:(NSError *)error {
    switch (error.code) {
        case NSURLErrorNotConnectedToInternet:
            return @"网络连接不可用\n请检查网络设置";
        case NSURLErrorTimedOut:
            return @"网络连接超时\n请稍后重试";
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
            return @"无法连接到服务器\n请检查网址是否正确";
        case NSURLErrorBadURL:
            return @"网址格式不正确";
        case NSURLErrorUnsupportedURL:
            return @"不支持的网址格式";
        default:
            return [NSString stringWithFormat:@"加载失败\n%@", error.localizedDescription];
    }
}

#pragma mark - memory management
- (void)dealloc{
    // 移除KVO观察
    @try {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    } @catch (NSException *exception) {
        // 忽略异常
    }
    
    
    [self.webView stopLoading];

    self.webView.navigationDelegate = nil;
    NSLog(@"🌐 WebViewController dealloc");

}

@end
