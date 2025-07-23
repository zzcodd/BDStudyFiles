//
//  BookCityViewController.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/16.
//

#import "BookCityViewController.h"
#import "BookCollectionViewCell.h"
#import "../Common/AdViewController.h"
#import "../../Models/BookModel.h"
#import "../../Utils/JSONParser.h"
#import "CategorySegmentView.h"
#import "CategoryPageViewController.h"
#import "../../Presenters/BookCityPresenter.h"

// 注册复用标签
static NSString *const kCellIdentifier = @"BookCollectionViewCell";

// 需要用到 UICollectionView 和 UISearchView
@interface BookCityViewController ()<BookCityViewProtocol, UISearchBarDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, CategorySegmentViewDelegate, CategoryPageViewControllerDelegate>


// 🆕 MVP架构：Presenter
@property (nonatomic, strong) BookCityPresenter *presenter;

// UI组件
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray<CategoryPageViewController *> *categorypages;
@property (nonatomic, strong) CategorySegmentView *categorySegmentView;

// 布局参数
@property (nonatomic, assign) CGFloat searchBarHeight;


@end


@implementation BookCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPresenter];
    [self setupConstants];
    [self setupUI];
    [self setupConstraints];
    
    // 通知Presenter
    [self.presenter viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏，用搜索栏
    self.navigationController.navigationBar.hidden = YES;
    [self.presenter viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 为了避免跳到其他页面也会隐藏导航栏 所以不在设置时设置导航栏隐藏，而在这动态设置加载和隐藏
    // 恢复导航栏
    self.navigationController.navigationBar.hidden = NO;
    
    [self.presenter viewWillDisappear];
    
}

#pragma mark - Setup Constants
- (void)setupPresenter{
    self.presenter = [[BookCityPresenter alloc] initWithView:self];
}

- (void)setupConstants{
    self.searchBarHeight = 44;
    self.categorypages = [NSMutableArray array];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupSearchBar];
//    [self setupCategoryBar];
//    [self setupCollectionView];
  // 替换原有的分类选择器
    [self setupCategorySegmentView];
    
    [self setupLoadingIndicator];
}


- (void)setupCategorySegmentView{
    // 从Presenter获取分类数据
    NSArray<NSString *> *categories = [self.presenter getCategories];
    self.categorySegmentView = [[CategorySegmentView alloc] initWithCategories:categories];
    self.categorySegmentView.delegate = self;
    self.categorySegmentView.selectedIndex = [self.presenter getCurrentCategoryIndex];
    self.categorySegmentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.categorySegmentView];
}

- (void)setupSearchBar{
    self.searchBar  = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"实时推荐的兴趣词条";
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.backgroundColor = UIColor.whiteColor;
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    if(searchField){
        searchField.backgroundColor = [UIColor systemGray6Color];
        searchField.layer.cornerRadius = 8;
        searchField.clipsToBounds = YES;
    }
    
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchBar];
    
}
//
//- (void)setupCategoryBar{
//    self.categoryScrollView = [[UIScrollView alloc] init];
//    if(self.categoryScrollView){
//        self.categoryScrollView.backgroundColor = [UIColor systemBackgroundColor];
//        self.categoryScrollView.showsHorizontalScrollIndicator = NO;
//        self.categoryScrollView.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view addSubview:self.categoryScrollView];
//        [self createCategoryButtons];
//    }
//}
//
//- (void)createCategoryButtons{
//    CGFloat buttonSpacing = 10;     // 按钮间距
//    CGFloat currentX = 12;          // 起始X位置
//    for(int i=0; i<self.categories.count; i++){
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:self.categories[i] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(categortButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = i;
//        
//        // 按钮样式
//        button.titleLabel.font = [UIFont systemFontOfSize:16];
//        [self updateButtonStyle:button selected:(self.selectedCategoryIndex == i)];
//        
//        // 计算按钮尺寸
//        CGSize buttonSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
//        CGFloat buttonWidth = buttonSize.width + 8;
//        button.frame = CGRectMake(currentX, 10, buttonWidth, 30);
//        
//        currentX += buttonWidth + buttonSpacing;
//        
//        [self.categoryScrollView addSubview:button];
//        [self.categoryButtons addObject:button];
//    }
//    // 设置 scrollView大小
//    self.categoryScrollView.contentSize = CGSizeMake(currentX, self.categoryBarHeight);
//}
//
//// 创建选中按钮的样式
//- (void)updateButtonStyle:(UIButton *)button selected:(BOOL)selected {
//    if(selected){
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//
//    } else {
//        [button setTitleColor:[UIColor systemGrayColor] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:16];
//    }
//}
//
//- (void)setupCollectionView{
//    // 创建流式布局
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.minimumLineSpacing = 16;
//    flowLayout.minimumInteritemSpacing = 12;
//    flowLayout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    
//    // 创建CollectionView
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
//    // 代理源和数据源
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    
//    self.collectionView.backgroundColor = [UIColor systemBackgroundColor];
//    self.collectionView.showsVerticalScrollIndicator = YES;
//    self.collectionView.alwaysBounceVertical = YES;
//    
//    // 注册Cell
//    [self.collectionView registerClass:[BookCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
//    
//    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:self.collectionView];
//}

- (void)setupLoadingIndicator{
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.loadingIndicator.color = [UIColor systemPinkColor];
    self.loadingIndicator.hidesWhenStopped = YES;
    self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.loadingIndicator];
}

- (void)setupConstraints{
    [NSLayoutConstraint activateConstraints:@[
        [self.searchBar.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:8],
        [self.searchBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.searchBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.searchBar.heightAnchor constraintEqualToConstant:self.searchBarHeight],
        
        // CategorySegmentView约束
        [self.categorySegmentView.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor constant:8],
        [self.categorySegmentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.categorySegmentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.categorySegmentView.heightAnchor constraintEqualToConstant:50],
        
        [self.loadingIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.loadingIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];
}


#pragma mark - Page View Controller Setup
- (void)setupPageViewController{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    // 添加为子控制器
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    // 设置PageViewController的约束
    self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.pageViewController.view.topAnchor constraintEqualToAnchor:self.categorySegmentView.bottomAnchor],
        [self.pageViewController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.pageViewController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.pageViewController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    // 创建所有分类的界面
    [self createCategoryPages];
    
    // 初始界面
    [self setupInitialPage];
}


- (void)createCategoryPages{
    [self.categorypages removeAllObjects];
    
    NSArray<NSString *> *categories = [self.presenter getCategories];
    for(NSInteger i=0; i<categories.count; i++){
        CategoryPageViewController *pageVC = [[CategoryPageViewController alloc] init];
        pageVC.categoryIndex = i;
        pageVC.categoryName = categories[i];
        pageVC.delegate = self;
        
        // 从Presenter获取数据
        pageVC.booksArray = [self.presenter getBooksForCategoryIndex:i];
        
        [self.categorypages addObject:pageVC];
    }
}

- (void)setupInitialPage{
    if(self.categorypages.count > 0){
        NSInteger initialIndex = [self.presenter getCurrentCategoryIndex];
        CategoryPageViewController *initialPage = self.categorypages[initialIndex];
        [self.pageViewController setViewControllers:@[initialPage] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}


#pragma mark - BookCityViewProtocol Implementation
// 数据更新回调
- (void)bookCityPresenterDidLoadBooks:(NSArray<BookModel *> *)books{
    NSLog(@"✅ BookCityViewController: 收到书籍数据 - %lu 本书籍", (unsigned long)books.count);
    // 如果是第一次加载，需要设置PageViewController
    if(!self.pageViewController){
        [self setupPageViewController];
    } else {
        [self updateCurrentCategoryPageWithBooks:books];
    }
    
}
- (void)bookCityPresenterDidFailWithError:(NSError *)error{
    NSLog(@"❌ BookCityViewController: 数据加载失败 - %@", error.localizedDescription);
    [self showErrorAlert:error.localizedDescription];
}

// UI状态回调
- (void)bookCityPresenterShowLoading{
    NSLog(@"🔄 BookCityViewController: 显示加载状态");
    if(self.pageViewController){
        self.pageViewController.view.hidden = YES;
    }
    [self.loadingIndicator startAnimating];
}

- (void)bookCityPresenterHideLoading{
    NSLog(@"⏹️ BookCityViewController: 隐藏加载状态");
    
    [self.loadingIndicator stopAnimating];
    if (self.pageViewController) {
        self.pageViewController.view.hidden = NO;
    }
}

// 分类相关的回调
- (void)bookCityPresenterDidUpdateCategories:(NSArray<NSString *> *)categories{
    NSLog(@"📂 BookCityViewController: 收到分类数据更新 - %lu 个分类", (unsigned long)categories.count);
    
    // 更新CategorySegmentView
    // 注意：这里可能需要重新创建CategorySegmentView，或者给它添加更新方法
}

- (void)bookCityPresenterDidSwitchToCategory:(NSInteger)categoryIndex animated:(BOOL)animated{
    NSLog(@"📱 BookCityViewController: 切换到分类 %ld", (long)categoryIndex);
    
    [self switchToCategoryIndex:categoryIndex animated:animated];
}

// 页面跳转的回调
- (void)bookCityPresenterRequestAdViewWithBook:(BookModel *)book{
    NSLog(@"🚀 BookCityViewController: 准备跳转广告页面 - %@", book.bookName);

    AdViewController *adVC = [[AdViewController alloc] init];
    [adVC loadAdWithBookInfo:book];
    [self.navigationController pushViewController:adVC animated:YES];
}



#pragma mark - CategorySegmentViewDelegate
- (void)categorySegmentView:(CategorySegmentView *)segmentView didSelectIndex:(NSInteger)index{
    NSLog(@"📂 分类选择器点击: 索引 %ld", (long)index);
    // 通过Presenter选择
    [self.presenter didSelectCategotuAtIndex:index];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    CategoryPageViewController *currentPage = (CategoryPageViewController *)viewController;
    NSInteger index = currentPage.categoryIndex;
    
    if (index <= 0) {
        return nil; // 已经是第一页
    }
    
    return self.categorypages[index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    CategoryPageViewController *currentPage = (CategoryPageViewController *)viewController;
    NSInteger index = currentPage.categoryIndex;
    
    if (index >= self.categorypages.count - 1) {
        return nil; // 已经是最后一页
    }
    
    return self.categorypages[index + 1];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    if (completed) {
        CategoryPageViewController *currentPage = (CategoryPageViewController *)pageViewController.viewControllers.firstObject;
        NSInteger newIndex = currentPage.categoryIndex;
        
        NSLog(@"📱 滑动切换到分类索引: %ld", (long)newIndex);
        
        // 🔧 修改：通过Presenter处理滑动切换
        [self.presenter didSwipeToCategoty:newIndex];
        
        // 更新分类选择器状态
        [self.categorySegmentView setSelectedIndex:newIndex animated:YES];
    }
}

#pragma mark - CategoryPageViewControllerDelegate
- (void)categoryPageViewController:(CategoryPageViewController *)pageViewController didSelectBook:(BookModel *)book atIndex:(NSInteger)index {
    NSLog(@"📖 用户点击了书籍: %@ (索引: %ld)", book.bookName, (long)index);
    
    // 🔧 修改：通过Presenter处理书籍选择
    [self.presenter didSelectBook:book atIndex:index fromCategory:pageViewController.categoryIndex];
}


    
#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"开始搜索编辑");
    searchBar.placeholder = @"请输入您想搜索的内容";
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"结束搜索编辑");
    searchBar.placeholder = @"实时推荐的兴趣词条";
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"取消搜索");
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"🔍 搜索: %@", searchBar.text);
    [searchBar resignFirstResponder];
    
    // 真正的搜索逻辑
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // 🆕 实时搜索
    if (searchText.length == 0) {
        [self.presenter clearSearch];
    } else if (searchText.length >= 2) { // 至少2个字符才开始搜索
        [self.presenter searchBooksWithKeyword:searchText];
    }
}

#pragma mark - Private Helper Methods

- (void)switchToCategoryIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < 0 || index >= self.categorypages.count) return;
    
    NSInteger currentIndex = [self.presenter getCurrentCategoryIndex];
    
    // 更新分类选择器
    [self.categorySegmentView setSelectedIndex:index animated:animated];
    
    // 切换页面
    CategoryPageViewController *targetPage = self.categorypages[index];
    
    UIPageViewControllerNavigationDirection direction =
        (index > currentIndex) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    
    [self.pageViewController setViewControllers:@[targetPage]
                                      direction:direction
                                       animated:animated
                                     completion:^(BOOL finished) {
        NSLog(@"📱 页面切换完成到索引: %ld", (long)index);
    }];
}

- (void)updateCurrentCategoryPageWithBooks:(NSArray<BookModel *> *)books {
    NSInteger currentIndex = [self.presenter getCurrentCategoryIndex];
    if (currentIndex >= 0 && currentIndex < self.categorypages.count) {
        CategoryPageViewController *currentPage = self.categorypages[currentIndex];
        currentPage.booksArray = books;
        
        NSLog(@"📱 更新分类页面数据: %ld 本书籍", (long)books.count);
    }
}

- (void)updateAllCategoryPagesData {
    // 更新所有分类页面的数据
    for (NSInteger i = 0; i < self.categorypages.count; i++) {
        CategoryPageViewController *pageVC = self.categorypages[i];
        NSArray<BookModel *> *categoryBooks = [self.presenter getBooksForCategoryIndex:i];
        pageVC.booksArray = categoryBooks;
    }
}

- (void)navigateToAdViewWithBook:(BookModel *)book {
    AdViewController *adVC = [[AdViewController alloc] init];
    [adVC loadAdWithBookInfo:book];  // 传递书籍信息到广告页面
    [self.navigationController pushViewController:adVC animated:YES];
}

- (void)showErrorAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"加载失败"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        [self.presenter refreshBookData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:retryAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc{
    NSLog(@"📚 BookCityViewController dealloc");
//    self.presenter = nil;
}
@end
