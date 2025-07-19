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

// 注册复用标签
static NSString *const kCellIdentifier = @"BookCollectionViewCell";

// 需要用到 UICollectionView 和 UISearchView
@interface BookCityViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, CategorySegmentViewDelegate, CategoryPageViewControllerDelegate>

// UI组件
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UIScrollView *categoryScrollView;
@property(nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

// 数据
@property(nonatomic, strong) NSArray<BookModel *> *booksArray;
@property(nonatomic, strong) NSArray<NSString *> *categories;
// 管理顶部分类栏的按钮状态和交互逻辑
@property(nonatomic, strong) NSMutableArray<UIButton *> *categoryButtons;
@property(nonatomic, assign) NSInteger selectedCategoryIndex;

// 布局参数
@property(nonatomic, assign) CGFloat searchBarHeight;
@property(nonatomic, assign) CGFloat categoryBarHeight;

// PageViewController
@property(nonatomic, strong) UIPageViewController *pageViewController;
@property(nonatomic, strong) NSMutableArray<CategoryPageViewController *> *categorypages;

// 分类选择器
@property (nonatomic, strong) CategorySegmentView *categorySegmentView;

@end


@implementation BookCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupConstants];
    [self setupUI];
    [self loadBookData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏，用搜索栏
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 为了避免跳到其他页面也会隐藏导航栏 所以不在设置时设置导航栏隐藏，而在这动态设置加载和隐藏
    // 恢复导航栏
    self.navigationController.navigationBar.hidden = NO;
    
}

#pragma mark - Setup Constants
- (void)setupConstants{
    self.searchBarHeight = 44;
    self.categoryBarHeight = 50;
    self.selectedCategoryIndex = 1; // 默认选中第二个 "小说"
    
    self.categories = @[@"推荐", @"小说", @"经典", @"知识", @"听书", @"看剧", @"视频", @"动漫", @"短篇", @"漫画", @"新书", @"买书"];
    self.categorypages = [NSMutableArray array];
}


#pragma mark - Setup UI
- (void)setupUI{
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupSearchBar];
//    [self setupCategoryBar];
//    [self setupCollectionView];
  // 替换原有的分类选择器
    [self setupCategorySegmentView];
    
    [self setupLoadingIndicator];
    [self setupConstraints];
}

- (void)setupCategorySegmentView{
    self.categorySegmentView = [[CategorySegmentView alloc] initWithCategories:self.categories];
    self.categorySegmentView.delegate = self;
    self.categorySegmentView.selectedIndex = self.selectedCategoryIndex;
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
        
//        [self.categoryScrollView.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor constant:8],
//        [self.categoryScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
//        [self.categoryScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
//        [self.categoryScrollView.heightAnchor constraintEqualToConstant:self.categoryBarHeight],
//        
//        [self.collectionView.topAnchor constraintEqualToAnchor:self.categoryScrollView.bottomAnchor constant:0],
//        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
//        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
//        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
  
        // CategorySegmentView约束
        [self.categorySegmentView.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor constant:8],
        [self.categorySegmentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.categorySegmentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.categorySegmentView.heightAnchor constraintEqualToConstant:50],
        
        [self.loadingIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.loadingIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];
}

#pragma mark - Data Loading
- (void)loadBookData{
    NSLog(@"开始加载书籍数据......");
    [self showLoadingState];
    
    // 异步解析数据
    [JSONParser parseBookListFromFileAsync:@"book_list" completion:^(NSArray<BookModel *> *books, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopLoadingState];
            if(error || books.count == 0){
                NSLog(@"❌ 书籍数据加载失败: %@", error.localizedDescription);
            } else {
                NSLog(@"✅ 成功加载 %lu 本书籍", (unsigned long)books.count);
                self.booksArray = books;
                
//                [self.collectionView reloadData];
//                [self animateCollectionViewAppearance];
                [self setupPageViewController];
            }
        });
    }];
}

- (void)showLoadingState{
    // 🔧 修正：隐藏pageViewController而不是collectionView
    if (self.pageViewController) {
        self.pageViewController.view.hidden = YES;
    }
    [self.loadingIndicator startAnimating];
}

- (void)stopLoadingState{
    [self.loadingIndicator stopAnimating];
    // 🔧 修正：显示pageViewController
    if (self.pageViewController) {
        self.pageViewController.view.hidden = NO;
    }
}

- (void)setupPageViewController{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    // 添加为子控制器
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];  // 🔧 修正：添加这行

    
    // 设置PageViewController的约束
    self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.pageViewController.view.topAnchor constraintEqualToAnchor:self.categorySegmentView.bottomAnchor],
        [self.pageViewController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.pageViewController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.pageViewController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    // 创建所有分类页面
    [self createCategoryPages];
    // 初始界面
    [self setupInitialPage];
}

- (void)createCategoryPages{
    [self.categorypages removeAllObjects];
    
    for(NSInteger i=0; i<self.categories.count; i++){
        CategoryPageViewController *pageVC = [[CategoryPageViewController alloc] init];
        pageVC.categoryIndex = i;
        pageVC.categoryName = self.categories[i];
        pageVC.delegate = self;
        
        pageVC.booksArray = [self getBooksForCategoryIndex:i];
        
        [self.categorypages addObject:pageVC];
    }
}

- (NSArray<BookModel *> *)getBooksForCategoryIndex:(NSInteger)index {
    NSString *categoryName = self.categories[index];
    if([categoryName isEqualToString:@"小说"]){
        return self.booksArray;
    } else {
        return @[];
    }
}

- (void)setupInitialPage{
    if(self.categorypages.count > 0){
        CategoryPageViewController *initialPage = self.categorypages[self.selectedCategoryIndex];
        [self.pageViewController setViewControllers:@[initialPage] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

#pragma mark - CategorySegmentViewDelegate
- (void)categorySegmentView:(CategorySegmentView *)segmentView didSelectIndex:(NSInteger)index{
    if(index == self.selectedCategoryIndex) return;
    
    NSLog(@"📂 分类选择器点击: %@", self.categories[index]);
    [self switchToCategoryIndex:index animated:YES];
}

- (void)switchToCategoryIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < 0 || index >= self.categorypages.count) return;
    NSInteger oldIndex = self.selectedCategoryIndex;
    self.selectedCategoryIndex = index;
    
    // 更新分类选择器
    [self.categorySegmentView setSelectedIndex:index animated:animated];
    
    // 切换页面
    CategoryPageViewController *targetpage = self.categorypages[index];
    UIPageViewControllerNavigationDirection direction =
            (index > oldIndex) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        
    [self.pageViewController setViewControllers:@[targetpage]
                                      direction:direction
                                       animated:animated
                                     completion:^(BOOL finished) {
        NSLog(@"📱 页面切换完成");
    }];

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
        
        NSLog(@"📱 滑动切换到分类: %@", self.categories[newIndex]);
        
        // 更新选中状态（不触发动画，避免循环）
        self.selectedCategoryIndex = newIndex;
        [self.categorySegmentView setSelectedIndex:newIndex animated:YES];
    }
}

#pragma mark - CategoryPageViewControllerDelegate
- (void)categoryPageViewController:(CategoryPageViewController *)pageViewController didSelectBook:(BookModel *)book atIndex:(NSInteger)index {
    NSLog(@"用户点击了书籍 %@", book.bookName);
    
    // 跳转到广告页面
    AdViewController *adVC = [[AdViewController alloc] init];
    [self.navigationController pushViewController:adVC animated:YES];
}

#pragma mark - Animations

- (void)animateCollectionViewAppearance {
    self.collectionView.alpha = 0;
    self.collectionView.transform = CGAffineTransformMakeTranslation(0, 30);
    
    [UIView animateWithDuration:0.6
                          delay:0.1
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.collectionView.alpha = 1;
        self.collectionView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)animateCellSelection:(UIView *)cell completion:(void(^)(void))completion {
    [UIView animateWithDuration:0.1 animations:^{
        cell.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }];
}

#pragma mark - 按钮事件
// 点击按钮事件
- (void)categortButtonTapped:(UIButton *)sender{
    NSInteger newIndex = sender.tag;
    
    // 同一类
    if(newIndex == self.selectedCategoryIndex) return;
    
    NSLog(@"📂 切换分类: %@ → %@", self.categories[self.selectedCategoryIndex], self.categories[newIndex]);

//cc
    self.selectedCategoryIndex = newIndex;
    
    [self animateCategorySwitch];
    
    // 后续可根据不同分类加载不同数据
//    [self loadDataForCategory:newIndex];
    
}

- (void)animateCategorySwitch {
    // 添加分类切换的视觉反馈
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.alpha = 0.7;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.collectionView.alpha = 1.0;
        }];
    }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"开始搜索编辑");
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"结束搜索编辑");
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.booksArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.item < self.booksArray.count) {
        BookModel *book = self.booksArray[indexPath.item];
        [cell configureWithBook:book];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 计算Cell大小（2列布局）
    CGFloat sectionInsets = 16 + 16; // 左右边距
    CGFloat itemSpacing = 12; // 中间间距
    CGFloat availableWidth = collectionView.frame.size.width - sectionInsets - itemSpacing;
    CGFloat cellWidth = availableWidth / 2.0;
    
    // 根据设计图比例计算高度
    CGFloat imageHeight = cellWidth * 1.3; // 图片高度
    CGFloat textHeight = 60; // 文字区域高度
    CGFloat cellHeight = imageHeight + textHeight;
    
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.item >= self.booksArray.count) {
        return;
    }
    
    BookModel *selectedBook = self.booksArray[indexPath.item];
    NSLog(@"📖 用户点击了书籍: %@ (索引: %ld)", selectedBook.bookName, (long)indexPath.item);
    
    // 添加点击反馈动画
    BookCollectionViewCell *cell = (BookCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self animateCellSelection:cell completion:^{
        [self pushToAdViewController];
    }];
}




#pragma mark - Navigation
- (void)pushToAdViewController{
    NSLog(@"跳转到广告页面...");
    AdViewController *adVC = [[AdViewController alloc] init];
    [self.navigationController pushViewController:adVC animated:YES];
}

- (void)dealloc{
    NSLog(@"BookCityViewController dealloc");
}

@end
