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

@interface AdViewController ()<AdPresenterViewProtocol>

// MVP架构
@property(nonatomic, strong) AdPresenter *presenter;

// UI组件
@property(nonatomic, strong) UIImageView *adImageView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subTitleLabel;
@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UIButton *actionButton;

// 状态
@property(nonatomic, strong) UILabel *errorLabel;
@property(nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPresenter];
    [self setupUI];
    [self setupConstraints];
    
    // 通知Persenter加载数据
    [self.presenter viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addEnterAnimation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 恢复导航栏
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - setup Persenter

- (void)setupPresenter{
    self.presenter = [[AdPresenter alloc] initWithView:self];
}

#pragma mark - setup UI
- (void)setupUI{
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    // 设置导航栏
    self.title = @"广告详情";
    self.navigationController.navigationBar.tintColor = [UIColor systemBlueColor];
    
    
}

- (void)setupScrollView{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
}

- (void)setupContentView{
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.contentView];
}

- (void)setupAdImageView{
    self.adImageView = [[UIImageView alloc] init];
    self.adImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.adImageView.clipsToBounds = YES;
    self.adImageView.layer.cornerRadius = 12;
    self.adImageView.backgroundColor = [UIColor systemGray5Color];
    self.adImageView.userInteractionEnabled = NO;
    self.adImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.adImageView];
}

//- (void)

- (void)setupConstraints{}

#pragma mark - ViewProtocol
- (void)showLoadingState{}
- (void)hideLoadingState{}
- (void)displayAdData:(AdModel *)ad{}
- (void)showErrorMessage:(NSString *)message{}


#pragma mark - Animations
- (void)addEnterAnimation{
//    self.view.alpha = 0;
//    self.view.transform = CGAffineTransformMakeTranslation(0, 30);
//    
//    [UIView animateWithDuration:0.6 delay:0.1 options:UIViewAnimationCurveEaseOut animations:^{
//        self.view.alpha = 1;
//        self.view.transform = CGAffineTransformIdentity;
//    } completion:nil];
}


#pragma mark - dealloc
- (void)dealloc{
    NSLog(@"AdviewController dealloc");
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
