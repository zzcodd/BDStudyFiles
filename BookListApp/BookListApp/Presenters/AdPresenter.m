//
//  AdPresenter.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/18.
//

#import "AdPresenter.h"
#import "../Utils/JSONParser.h"


@implementation AdPresenter

- (instancetype)initWithView:(id<AdPresenterViewProtocol>)view{
    self = [super init];
    if(self){
        _view = view;
    }
    return  self;
}

#pragma mark - AdPresenterProtocol
- (void)viewDidLoad{
    NSLog(@"🎬 AdPresenter: 开始加载广告数据");

    // 显示加载状态
    if([self.view respondsToSelector:@selector(showLoadingState)]){
        [self.view showLoadingState];
    }
    
    // 异步解析广告数据
    [JSONParser parseAdFromFileAsync:@"作业横版视频" completion:^(AdModel *ad, NSError *error){
        if([self.view respondsToSelector:@selector(hideLoadingState)]){
            // 隐藏加载状态
            [self.view hideLoadingState];
        }
        if(error || !ad){
            NSLog(@"❌ AdPresenter: 广告数据加载失败 - %@", error.localizedDescription);
            [self.view showErrorMessage:@"广告数据加载失败，请重试"];
        } else {
            NSLog(@"✅ AdPresenter: 广告数据加载成功 - %@", ad.title);
            self.adModel = ad;
            
            // 通知view显示数据
            if([self.view respondsToSelector:@selector(displayAdData:)]){
                [self.view displayAdData:ad];
            }
        }
    }];
}

- (void)adButtonTapped{
    NSLog(@"🔘 AdPresenter: 广告按钮被点击");
    if(self.adModel && self.adModel.downloadUrl.length > 0){
        NSLog(@"🌐 准备跳转到URL: %@", self.adModel.downloadUrl);
        
        // 实际页面跳转由View处理
        // Presenter只负责业务逻辑的判断
    } else {
        NSLog(@"⚠️ AdPresenter: 无效的下载链接");
        [self.view showErrorMessage:@"链接无效，无法跳转"];
    }
}

- (void) adImageTapped{
    NSLog(@"🔘 AdPresenter: 广告按钮被点击");
    
    // 和按钮逻辑相同
    [self adButtonTapped];
}

@end
