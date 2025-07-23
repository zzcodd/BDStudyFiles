//
//  BookCityPresenter.h
//  BookListApp
//
//  Created by ByteDance on 2025/7/21.
//

#import <Foundation/Foundation.h>
#import "../Models/BookModel.h"

NS_ASSUME_NONNULL_BEGIN

@class BookCityPresenter;

// View层需遵守的协议 BookCityViewController实现
@protocol BookCityViewProtocol <NSObject>
// 数据更新回调
- (void)bookCityPresenterDidLoadBooks:(NSArray<BookModel *> *)books;
- (void)bookCityPresenterDidFailWithError:(NSError *)error;

// UI状态回调
- (void)bookCityPresenterShowLoading;
- (void)bookCityPresenterHideLoading;

// 分类相关的回调
- (void)bookCityPresenterDidUpdateCategories:(NSArray<NSString *> *)categories;
- (void)bookCityPresenterDidSwitchToCategory:(NSInteger)categoryIndex animated:(BOOL)animated;

// 页面跳转的回调
- (void)bookCityPresenterRequestAdViewWithBook:(BookModel *)book;

@end


// Presenter协议，对外的接口
@protocol BookCityPresenterProtocol <NSObject>

// 生命周期
- (void)viewDidLoad;
- (void)viewWillAppear;
- (void)viewWillDisappear;

// 数据加载
- (void)loadBookData;
- (void)refreshBookData;

// 分类管理
- (NSArray<NSString *> *)getCategories;
- (NSInteger)getCurrentCategoryIndex;
- (void)switchToCategoryIndex:(NSInteger)index animated:(BOOL)animated;
- (NSArray<BookModel *> *)getBooksForCategoryIndex:(NSInteger)index;

// 与用户交互
- (void)didSelectCategotuAtIndex:(NSInteger)index;
- (void)didSelectBook:(BookModel *)book atIndex:(NSInteger)index fromCategory:(NSInteger)categoryIndex;
- (void)didSwipeToCategoty:(NSInteger)index;

//// 搜索功能
- (void)searchBooksWithKeyword:(NSString *)keyword;
- (void)clearSearch;

@end

@interface BookCityPresenter : NSObject<BookCityPresenterProtocol>

@property(nonatomic, weak) id<BookCityViewProtocol> viewDelegate;



- (instancetype)initWithView:(id<BookCityViewProtocol>)view;

// 便利方法
- (BOOL)hasValidData;
- (NSString *)getCurrentCategoryName;


@end

NS_ASSUME_NONNULL_END
