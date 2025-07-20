//
//  AdPresenter.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/19.
//

#import "AdPresenter.h"
#import "../Utils/JSONParser.h"

@interface AdPresenter()

@property(nonatomic, strong) AdModel *currentAd;
@property(nonatomic, strong) BookModel *currentBook;
@property(nonatomic, assign) BOOL isLoading;

@end


@implementation AdPresenter

#pragma mark - 初始化

- (instancetype)initWithView:(id<AdViewProtocol>)viewDelegate{
    self = [super init];
    if(self){
        _viewDelegate = viewDelegate;
        _isLoading = NO;
    }
    return self;
}

#pragma mark - AdPresenterProtocol Implementation
- (void)viewDidLoad{
    NSLog(@"📺 AdPresenter: viewDidLoad");
    // 后续可补充一些准备工作，此处无
}

- (void)viewWillAppear{
    NSLog(@"📺 AdPresenter: viewWillAppear");
    if(!self.currentAd){
        [self loadAdData];
    }
}

- (void)viewWillDisappear{
    NSLog(@"📺 AdPresenter: viewDidDisappear");
    // 后续可补充一些清理工作
}


#pragma mark - Data Loading
- (void)loadAdData{
    if(self.isLoading){
        NSLog(@"⚠️ AdPresenter: 正在加载中，忽略重复请求");
        return;
    }
    NSLog(@"📺 AdPresenter: 开始加载广告数据");
    self.isLoading = YES;
    
    // 显示加载
    if([self.viewDelegate respondsToSelector:@selector(adPresenterShowLoading)]){
        [self.viewDelegate adPresenterShowLoading];
    }
    
    // 加载数据
    [JSONParser parseAdFromFileAsync:@"作业横版视频" completion:^(AdModel *ad, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isLoading = NO;
            
            if([self.viewDelegate respondsToSelector:@selector(adPresenterHideLoading)]){
                [self.viewDelegate  adPresenterHideLoading];
            }
            
            if(error || !ad){
                NSLog(@"❌ AdPresenter: 广告数据加载失败 - %@", error.localizedDescription);
            } else {
                NSLog(@"✅ AdPresenter: 广告数据加载成功 - %@", ad.title);
                [self  handleLoadSuccess:ad];
            }
        });
        
    }];
}
- (void)loadAdDataWithBookInfo:(BookModel *)book{
    NSLog(@"📺 AdPresenter: 加载广告数据（关联书籍：%@）", book.bookName);

    // 保存书籍信息用于个性化广告
    self.currentBook = book;
    [self loadAdData];
}

#pragma mark - User Interactions
- (void)didTapDownloadButton{
    NSLog(@"📺 AdPresenter: 用户点击下载按钮");
        
    NSString *downloadUrl = self.currentAd.downloadUrl;
    NSString *webTitle = self.currentAd.webTitle?:@"详情见页面";
    
    if(downloadUrl && downloadUrl.length>0){
        NSLog(@"🚀 AdPresenter: 准备跳转到Web页面 - %@", downloadUrl);
        
        // 通知view跳转
        if([self.viewDelegate respondsToSelector:@selector(adPresenterRequestWebViewWithUrl:title:)]){
            [self.viewDelegate adPresenterRequestWebViewWithUrl:downloadUrl title:webTitle];
        } else {
            NSLog(@"⚠️ AdPresenter: 下载链接无效");
        }
    }
}

- (void)didTapAdImage{
    NSLog(@"📺 AdPresenter: 用户点击广告图片");
    [self didTapDownloadButton];
}

- (void)didTapBackButton{
    NSLog(@"📺 AdPresenter: 用户点击返回按钮");
    
    // 通常返回按钮的处理由View层的导航控制器处理
    // 这里可以做一些数据清理或统计上报
}
#pragma mark - Private Methods
- (void)handleLoadSuccess:(AdModel *)ad{
    self.currentAd = ad;
    
    if([self.viewDelegate respondsToSelector:@selector(adPresenterDidLoadAd:)]){
        [self.viewDelegate adPresenterDidLoadAd:_currentAd];
    }
}
- (void)handleLoadError:(NSError *)error {}
- (void)handleInvalidUrl {}

#pragma mark - Memory Management
- (void)dealloc{
    NSLog(@"📺 AdPresenter dealloc");
    self.viewDelegate = nil;
    self.currentAd = nil;
    self.currentBook = nil;
}
@end
