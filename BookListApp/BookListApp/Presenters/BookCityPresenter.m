//
//  BookCityPresenter.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/21.
//

#import "BookCityPresenter.h"
#import "../Utils/JSONParser.h"

@interface BookCityPresenter()

@property(nonatomic, strong) NSArray<BookModel *> *allBooks;
@property(nonatomic, strong) NSArray<NSString *> *categories;
@property(nonatomic, assign) NSInteger currentCategoryIndex;
@property(nonatomic, assign) BOOL isLoading;
// 分类数据映射
@property (nonatomic, strong) NSDictionary<NSNumber *, NSArray<BookModel *> *> *categoryBooksMap;

// 搜索相关
@property (nonatomic, strong) NSString *currentSearchKeyword;
@property (nonatomic, strong) NSArray<BookModel *> *searchResults;
@property (nonatomic, assign) BOOL isSearching;

@end



@implementation BookCityPresenter
#pragma mark - Initialization
- (instancetype)initWithView:(id<BookCityViewProtocol>)view{
    self = [super init];
    if(self){
        _viewDelegate = view;
        _isLoading = NO;
        _isSearching = NO;
        _currentCategoryIndex = 1; // 默认小说
            
        // 初始化分类数据
        [self setupCategories];
    }
    return self;
}

-(void)setupCategories{
    _categories = self.categories = @[@"推荐", @"小说", @"经典", @"知识", @"听书", @"看剧", @"视频", @"动漫", @"短篇", @"漫画", @"新书", @"买书"];
    NSLog(@"📚 BookCityPresenter: 初始化分类数据，共 %lu 个分类", (unsigned long)self.categories.count);
    
    if([self.viewDelegate respondsToSelector:@selector(bookCityPresenterDidUpdateCategories:)]){
        [self.viewDelegate bookCityPresenterDidUpdateCategories:_categories];
    }
}

#pragma mark - BookCityPresenterProtocol Implementation
- (void)viewDidLoad{
    NSLog(@"📚 BookCityPresenter: viewDidLoad");
    // 初始化时可以做一些准备工作
}

- (void)viewWillAppear{
    NSLog(@"📚 BookCityPresenter: viewWillAppear");
    // 页面即将出现时自动加载数据
    if(!self.allBooks || self.allBooks.count == 0){
        [self loadBookData];
    }
}

- (void)viewWillDisappear {
    NSLog(@"📚 BookCityPresenter: viewWillDisappear");
    // 页面消失时的清理工作
}

#pragma mark - Data Loading
- (void)loadBookData{
    if(self.isLoading){
        NSLog(@"⚠️ BookCityPresenter: 正在加载中，忽略重复请求");
        return;
    }
    NSLog(@"📚 BookCityPresenter: 开始加载书籍数据");
    self.isLoading = YES;
    
    // 通知View显示加载状态
    if([self.viewDelegate respondsToSelector:@selector(bookCityPresenterShowLoading)]){
        [self.viewDelegate bookCityPresenterShowLoading];
    }
    
//    [JSONParser parseBookListFromFileAsync:@"book_list" completion:^(NSArray<BookModel *> *books, NSError *error){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.isLoading = NO;
//            
//            if([self.viewDelegate respondsToSelector:@selector(bookCityPresenterHideLoading)]){
//                [self.viewDelegate bookCityPresenterHideLoading];
//            }
//            
//            if(error || !books || books.count == 0){
//                NSLog(@"❌ BookCityPresenter: 书籍数据加载失败 - %@", error.localizedDescription);
//            } else {
//                NSLog(@"✅ BookCityPresenter: 书籍数据加载成功 - %lu 本书籍", (unsigned long)books.count);
//                [self handleLoadSuccess:books];
//            }
//        });
//    }];
    
    [JSONParser parseBookListFromFileAsync:@"book_list" completion:^(NSArray<BookModel *> *books, NSError *error) {
        // 此处已在主线程，无需再次切换
        self.isLoading = NO;
        
        if ([self.viewDelegate respondsToSelector:@selector(bookCityPresenterHideLoading)]) {
            [self.viewDelegate bookCityPresenterHideLoading];
        }
        
        if (error || !books || books.count == 0) {
            NSLog(@"❌ 加载失败: %@", error.localizedDescription);
        } else {
            NSLog(@"✅ 加载成功: %lu 本", (unsigned long)books.count);
            [self handleLoadSuccess:books];
        }
    }];
}

- (void)refreshBookData{
    NSLog(@"📚 BookCityPresenter: 刷新书籍数据");
    
    // 清空现有数据
    self.allBooks = nil;
    
    [self loadBookData];
}

#pragma mark - Category Management
- (NSArray<NSString *> *)getCategories{
    return self.categories;
}

- (NSInteger)getCurrentCategoryIndex{
    return self.currentCategoryIndex;
}

- (void)switchToCategoryIndex:(NSInteger)index animated:(BOOL)animated{
    if (index < 0 || index >= self.categories.count) {
         NSLog(@"⚠️ BookCityPresenter: 无效的分类索引 %ld", (long)index);
         return;
     }
    
    if (index == self.currentCategoryIndex) {
        NSLog(@"📚 BookCityPresenter: 分类索引未变化，忽略");
        return;
    }
    
    NSLog(@"📚 BookCityPresenter: 切换分类 %@ → %@",
          self.categories[self.currentCategoryIndex],
          self.categories[index]);
    
    self.currentCategoryIndex = index;
    // 通知代理更新
    if([self.viewDelegate respondsToSelector:@selector(bookCityPresenterDidSwitchToCategory:animated:)]){
        [self.viewDelegate bookCityPresenterDidSwitchToCategory:_currentCategoryIndex animated:animated];
    }
}

- (NSArray<BookModel *> *)getBooksForCategoryIndex:(NSInteger)index {
    if (index < 0 || index >= self.categories.count) {
        return @[];
    }

    
    // 从缓存中获取分类数据
    NSNumber *categoryKey = @(index);
    NSArray<BookModel *> *categoryBooks = self.categoryBooksMap[categoryKey];
    
    if (categoryBooks) {
        return categoryBooks;
    }
    
    // 如果缓存中没有，重新计算
    return [self calculateBooksForCategoryIndex:index];
}

- (NSArray<BookModel *> *)calculateBooksForCategoryIndex:(NSInteger)index {
    if (!self.allBooks || self.allBooks.count == 0) {
        return @[];
    }
    
    NSString *categoryName = self.categories[index];
    NSArray<BookModel *> *result = @[];
    
    // 根据不同分类返回不同的书籍数据
    if ([categoryName isEqualToString:@"小说"]) {
        // "小说" 分类显示所有书籍
        result = self.allBooks;
    } else if ([categoryName isEqualToString:@"推荐"]) {
        // "推荐" 分类显示评分最高的前6本书
       result = [self fetchTopRatedBooksWithCount:6];
    } else if ([categoryName isEqualToString:@"经典"]) {
        // "经典" 分类随机推荐6本
        result = [self fetchRandomBooksWithCount:6];
    } else {
        // 其他分类暂时为空
        result = @[];
    }
    
    // 缓存结果
    [self cacheBooks:result forCategoryIndex:index];
    
    NSLog(@"📚 BookCityPresenter: 分类 '%@' 包含 %lu 本书籍", categoryName, (unsigned long)result.count);
    
    return result;
}

// 辅助方法：获取评分最高的书籍
- (NSArray<BookModel *> *)fetchTopRatedBooksWithCount:(NSInteger)count {
    if (self.allBooks.count <= count) {
        return [self.allBooks sortedArrayUsingComparator:^NSComparisonResult(BookModel * _Nonnull obj1, BookModel * _Nonnull obj2) {
            return [obj2.score compare:obj1.score]; // 降序排列
        }];
    }
    
    // 优化：大数据集下使用堆排序只取前N个
    NSArray<BookModel *> *sortedBooks = [self.allBooks sortedArrayUsingComparator:^NSComparisonResult(BookModel * _Nonnull obj1, BookModel * _Nonnull obj2) {
        return [obj2.score compare:obj1.score]; // 降序排列
    }];
    return [sortedBooks subarrayWithRange:NSMakeRange(0, count)];
}

// 辅助方法：随机获取书籍
- (NSArray<BookModel *> *)fetchRandomBooksWithCount:(NSInteger)count {
    NSMutableArray<BookModel *> *randomBooks = [NSMutableArray array];
    NSMutableArray<BookModel *> *availableBooks = [NSMutableArray arrayWithArray:self.allBooks];
    
    // 随机选择 count 本书籍
    NSInteger maxCount = MIN(count, availableBooks.count);
    for (NSInteger i = 0; i < maxCount; i++) {
        NSInteger randomIndex = arc4random_uniform((uint32_t)availableBooks.count);
        [randomBooks addObject:availableBooks[randomIndex]];
        [availableBooks removeObjectAtIndex:randomIndex]; // 避免重复选择
    }
    
    return randomBooks;
}



- (void)cacheBooks:(NSArray<BookModel *> *)books forCategoryIndex:(NSInteger)index {
    if (!self.categoryBooksMap) {
        self.categoryBooksMap = [NSMutableDictionary dictionary];
    }
    
    NSMutableDictionary *mutableMap = [self.categoryBooksMap mutableCopy];
    mutableMap[@(index)] = books;
    self.categoryBooksMap = [mutableMap copy];
}

#pragma mark - User Interactions
- (void)didSelectCategotuAtIndex:(NSInteger)index{
    NSLog(@"📚 BookCityPresenter: 用户选择分类 %@", self.categories[index]);
    [self switchToCategoryIndex:index animated:YES];
}

- (void)didSelectBook:(BookModel *)book atIndex:(NSInteger)index fromCategory:(NSInteger)categoryIndex{
    NSLog(@"📚 BookCityPresenter: 用户选择书籍 '%@' (分类: %@, 索引: %ld)",
          book.bookName,
          self.categories[categoryIndex],
          (long)index);
    
    // 通知View跳转到广告页面
    if([self.viewDelegate respondsToSelector:@selector(bookCityPresenterRequestAdViewWithBook:)]){
        [self.viewDelegate bookCityPresenterRequestAdViewWithBook:book];
    }
}

- (void)didSwipeToCategoty:(NSInteger)index{
    NSLog(@"📚 BookCityPresenter: 用户滑动到分类 %@", self.categories[index]);
    self.currentCategoryIndex = index;
    // 注意：这里不需要通知View切换，因为是由用户滑动触发的
}




#pragma mark - Private Methods
- (void)handleLoadSuccess:(NSArray<BookModel *> *)books {
    self.allBooks = books;
    
    if([self.viewDelegate respondsToSelector:@selector(bookCityPresenterDidLoadBooks:)]){
        [self.viewDelegate bookCityPresenterDidLoadBooks:books];
    }
}

#pragma mark - Public Helper Methods

- (BOOL)hasValidData {
    return self.allBooks && self.allBooks.count > 0;
}

- (NSString *)getCurrentCategoryName {
    if (self.currentCategoryIndex >= 0 && self.currentCategoryIndex < self.categories.count) {
        return self.categories[self.currentCategoryIndex];
    }
    return @"未知分类";
}

#pragma mark - Search Functionality
- (void)searchBooksWithKeyword:(NSString *)keyword {
    if (!keyword || keyword.length == 0) {
        [self clearSearch];
        return;
    }
    
    NSLog(@"📚 BookCityPresenter: 搜索关键词 '%@'", keyword);
    self.currentSearchKeyword = keyword;
    self.isSearching = YES;
    
    // 简单的书名搜索
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookName CONTAINS[cd] %@", keyword];
   self.searchResults = [self.allBooks filteredArrayUsingPredicate:predicate];
   
   NSLog(@"📚 BookCityPresenter: 搜索结果 %lu 本书籍", (unsigned long)self.searchResults.count);
   
   // 通知View更新当前分类的数据
   if ([self.viewDelegate respondsToSelector:@selector(bookCityPresenterDidLoadBooks:)]) {
       [self.viewDelegate bookCityPresenterDidLoadBooks:self.searchResults];
   }
        
}

- (void)clearSearch{
    NSLog(@"📚 BookCityPresenter: 清空搜索");

    self.currentSearchKeyword = nil;
    self.searchResults = nil;
    self.isSearching = NO;
    
    // 恢复当前分类的数据
    NSArray<BookModel *> *currentCategoryBooks = [self getBooksForCategoryIndex:self.currentCategoryIndex];
    if ([self.viewDelegate respondsToSelector:@selector(bookCityPresenterDidLoadBooks:)]) {
        [self.viewDelegate bookCityPresenterDidLoadBooks:currentCategoryBooks];
    }
}

#pragma mark - Memory Management

- (void)dealloc {
    NSLog(@"📚 BookCityPresenter dealloc");

}
@end
