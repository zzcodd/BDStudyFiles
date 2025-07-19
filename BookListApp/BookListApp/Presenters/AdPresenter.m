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

#pragma mark - AdPresenter Protocol
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


@end
