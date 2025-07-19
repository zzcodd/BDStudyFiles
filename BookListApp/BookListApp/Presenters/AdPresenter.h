//
//  AdPresenter.h
//  BookListApp
//
//  Created by ByteDance on 2025/7/18.
//

#import <Foundation/Foundation.h>
#import "../Models/AdModel.h"


NS_ASSUME_NONNULL_BEGIN

// presenter -> View    View的对外接口
@protocol AdPresenterViewProtocol <NSObject>

- (void)showLoadingState;
- (void)hideLoadingState;
- (void)displayAdData:(AdModel *)ad;
- (void)showErrorMessage:(NSString *)message;

@end


// view -> persenter    定义 View 可以调用 Presenter 的方法。
@protocol AdPresenterProtocol <NSObject>

- (void)viewDidLoad;
- (void)adButtonTapped;
- (void)adImageTapped;

@end


@interface AdPresenter : NSObject <AdPresenterProtocol>

@property(nonatomic, weak) id<AdPresenterViewProtocol> view;
@property(nonatomic, strong) AdModel *adModel;

- (instancetype)initWithView:(id<AdPresenterViewProtocol>)view;

@end

NS_ASSUME_NONNULL_END
