//
//  AdPresenter.h
//  BookListApp
//
//  Created by ByteDance on 2025/7/19.
//

#import <Foundation/Foundation.h>
#import "../Models/AdModel.h"
#import "../Models/BookModel.h"

@class AdPresenter;

// View层协议，AdViewController需要实现
@protocol AdViewProtocol <NSObject>

// 数据更新回调
- (void)adPresenterDidLoadAd:(AdModel *_Nullable)ad;

// UI状态回调
- (void)adPresenterShowLoading;
- (void)adPresenterHideLoading;

// 页面跳转回调
- (void)adPresenterRequestWebViewWithUrl:(NSString *_Nullable)url title:(NSString *_Nullable)title;

@end


// Presenter协议，对外的接口
@protocol AdPresenterProtocol <NSObject>

// 数据接口
- (void)loadAdData;
- (void)loadAdDataWithBookInfo:(BookModel *_Nullable)book;

// 用户交互处理
- (void)didTapDownloadButton;
- (void)didTapAdImage;
- (void)didTapBackButton;

// 生命周期
- (void)viewDidLoad;
- (void)viewWillAppear;
- (void)viewWillDisappear;

@end


NS_ASSUME_NONNULL_BEGIN

@interface AdPresenter : NSObject<AdPresenterProtocol>

@property(nonatomic, weak) id<AdViewProtocol> viewDelegate;

// 初始化
- (instancetype)initWithView:(id<AdViewProtocol>)viewDelegate;

@end

NS_ASSUME_NONNULL_END
