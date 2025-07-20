//
//  AdViewController.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/15.
//

#import "AdViewController.h"
#import "../../Presenters/AdPresenter.h"
#import "../../Models/AdModel.h"
#import "WebViewController.h"
#import <SDWebImage/SDWebImage.h>

@interface AdViewController ()<AdViewProtocol>

// MVP架构
@property(nonatomic, strong) AdPresenter *presenter;

// UI组件
@property(nonatomic, strong) UIImageView *adImageView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subTitleLabel;
@property(nonatomic, strong) UIButton *downloadButton;

// 状态
@property(nonatomic, strong) UILabel *errorLabel;
@property(nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation AdViewController

#pragma mark - lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupPresenter];
    [self setupUI];
    [self setupConstraints];
    
    // 通知Presenter
    [self.presenter viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 通知Presenter
    [self.presenter viewWillAppear];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // 通知Presenter
    [self.presenter viewWillDisappear];
}

#pragma mark - setup
- (void)setupPresenter{
    self.presenter = [[AdPresenter alloc] initWithView:self];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // 导航栏
    self.title = @"广告详情";
    self.navigationController.navigationBar.tintColor = [UIColor systemBlueColor];
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];
    
    // 广告视图
    self.adImageView = [[UIImageView alloc] init];
    self.adImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.adImageView.clipsToBounds = YES;
    self.adImageView.layer.cornerRadius = 12;
    self.adImageView.backgroundColor = [UIColor systemGrayColor];
    self.adImageView.userInteractionEnabled = YES;
    self.adImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.adImageView];
    
    // 添加图片点击手势
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImageTapper)];
    [self.adImageView addGestureRecognizer:imageTap];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor labelColor];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    
    // 副标题
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:16];
    self.subTitleLabel.textColor = [UIColor secondaryLabelColor];
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.subTitleLabel];
    
    // 下载按钮
    self.downloadButton = [[UIButton alloc] init];
    self.downloadButton.backgroundColor = [UIColor systemOrangeColor];
    self.downloadButton.layer.cornerRadius = 25;
    self.downloadButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.downloadButton.titleLabel.textColor = [UIColor whiteColor];
    [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.downloadButton addTarget:self action:@selector(downloadButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.downloadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.downloadButton];
    
    // 加载指示器
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.loadingIndicator.hidesWhenStopped = YES;
    self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.loadingIndicator];
    
    // 错误提示标签
    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.textColor = [UIColor secondaryLabelColor];
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    self.errorLabel.numberOfLines = 0;
    self.errorLabel.font = [UIFont systemFontOfSize:16];
    self.errorLabel.hidden = YES;
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.errorLabel];
    
 }

- (void)setupConstraints{
    // 滚动视图
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
    
    // 内容视图
    [NSLayoutConstraint activateConstraints:@[
        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor]
    ]];
    
    // 广告图片约束
    [NSLayoutConstraint activateConstraints:@[
        [self.adImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
        [self.adImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.adImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.adImageView.heightAnchor constraintEqualToConstant:250]
    ]];
    
    // 标题约束
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.adImageView.bottomAnchor constant:24],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20]
    ]];
    
    // 副标题约束
    [NSLayoutConstraint activateConstraints:@[
        [self.subTitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:12],
        [self.subTitleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.subTitleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20]
    ]];
    
    // 下载按钮约束
    [NSLayoutConstraint activateConstraints:@[
         [self.downloadButton.topAnchor constraintEqualToAnchor:self.subTitleLabel.bottomAnchor constant:40],
         [self.downloadButton.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
         [self.downloadButton.widthAnchor constraintEqualToConstant:200],
         [self.downloadButton.heightAnchor constraintEqualToConstant:50],
         [self.downloadButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-40]
     ]];
    
    // 加载指示器约束
    [NSLayoutConstraint activateConstraints:@[
        [self.loadingIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.loadingIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    // 错误标签约束
    [NSLayoutConstraint activateConstraints:@[
        [self.errorLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.errorLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.errorLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:40],
        [self.errorLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor constant:-40]
    ]];
    
}

#pragma mark - Public Methods

- (void)loadAdWithBookInfo:(BookModel *)book {
    NSLog(@"📺 AdViewController: 开始加载广告（关联书籍：%@）", book.bookName);
    [self.presenter loadAdDataWithBookInfo:book];
}

#pragma mark - User Action
- (void)adImageTapper{
    NSLog(@"📺 AdViewController: 用户点击广告图片");
    [self.presenter didTapAdImage];
}

- (void)downloadButtonTapped{
    NSLog(@"📺 AdViewController: 用户点击下载按钮");
    [self animateButton:self.downloadButton completion:^{
        [self.presenter didTapDownloadButton];
    }];
}

#pragma mark - AdViewProtocol implementation
- (void)adPresenterDidLoadAd:(AdModel *)ad{
    NSLog(@"✅ AdViewController: 收到广告数据 - %@", ad.title);

    [self hideAllStates];
    [self showContentWithAd:ad];
    [self addEnterAnimation];
}

- (void)adPresenterShowLoading{
    NSLog(@"🔄 AdViewController: 显示加载状态");
    [self hideAllStates];
    [self.loadingIndicator startAnimating];
}

- (void)adPresenterHideLoading{
    NSLog(@"⏹️ AdViewController: 隐藏加载状态");
    [self.loadingIndicator stopAnimating];
}

- (void)adPresenterRequestWebViewWithUrl:(NSString *)url title:(NSString *)title{
    NSLog(@"🚀 AdViewController: 准备跳转Web页面 - %@", url);
    
    [self navigateToWebViewWithURL:url title:title];
}


#pragma mark - private method
- (void)hideAllStates{
    [self.loadingIndicator stopAnimating];
    self.errorLabel.hidden = YES;
    self.scrollView.hidden = NO;
}

- (void)showContentWithAd:(AdModel *)ad{
    self.titleLabel.text = ad.title?:@"精彩内容推荐";
    self.subTitleLabel.text = ad.subTitle?:ad.description?:@"点击下方按钮了解更多";
    [self.downloadButton setTitle:ad.buttonText?:@"立即查看" forState:UIControlStateNormal];
    
    // 加载图片
    if(ad.imageUrl && ad.imageUrl.length > 0){
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:ad.imageUrl]
                                    placeholderImage:[UIImage systemImageNamed:@"photo"]
                                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image && cacheType == SDImageCacheTypeNone){
                // 添加图片加载完成的动画
                self.adImageView.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    self.adImageView.alpha = 1;
                }];
            }
        }];
    } else {
        self.adImageView.image = [UIImage systemImageNamed:@"photo"];
    }
}

- (void)showErrorWithMessage:(NSString *)message {
    self.scrollView.hidden = YES;
    self.errorLabel.hidden = NO;
    self.errorLabel.text = [NSString stringWithFormat:@"😔 %@\n\n点击返回重试", message];
}

- (void)navigateToWebViewWithURL:(NSString *)url title:(NSString *)title {
    if(!url || url.length == 0){
        [self showErrorWithMessage:@"链接地址无效"];
        return;;
    }
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.uurlString = url;
    webVC.webTitle = title;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Animations

- (void)addEnterAnimation {
    // 页面进入动画
    self.adImageView.alpha = 0;
    self.titleLabel.alpha = 0;
    self.subTitleLabel.alpha = 0;
    self.downloadButton.alpha = 0;
    
    [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.adImageView.alpha = 1;
    } completion:nil];
    
    [UIView animateWithDuration:0.6 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.titleLabel.alpha = 1;
        self.subTitleLabel.alpha = 1;
    } completion:nil];
    
    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.downloadButton.alpha = 1;
    } completion:nil];
}

- (void)animateButton:(UIButton *)button completion:(void(^)(void))completion {
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            button.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }];
}


#pragma mark - Memory Management

- (void)dealloc {
    NSLog(@"📺 AdViewController dealloc");
}


@end
