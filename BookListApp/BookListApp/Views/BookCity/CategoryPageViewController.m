//
//  CategorySegmentView.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/18.
//

#import "CategoryPageViewController.h"
#import "BookCollectionViewCell.h"

//extern NSString *const kCellIdentifier;
static NSString *const kCellIdentifier = @"BookCollectionViewCell";


@interface CategoryPageViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *emptyStateLabel;

@end

@implementation CategoryPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
    [self updateDisplayState];
}

- (void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 16;
    layout.minimumInteritemSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor systemBackgroundColor];
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.alwaysBounceVertical = YES;
    
    // 注册cell
    [self.collectionView registerClass:[BookCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self.view addSubview:self.collectionView];
    
    // 设置约束
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    if(self.booksArray.count == 0){
        [self showEmptyState];
    }
}

- (void)showEmptyState{
    UILabel *emptyLabel = [[UILabel alloc] init];
    emptyLabel.text = [NSString stringWithFormat:@"%@📚分类\n\n功能正在开发中", self.categoryName];
    emptyLabel.textColor = [UIColor secondaryLabelColor];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.font = [UIFont systemFontOfSize:16];
    
    [self.view addSubview:emptyLabel];
    emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [emptyLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [emptyLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [emptyLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:40],
        [emptyLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor constant:-40]
    ]];
}

#pragma mark - data manager
- (void)setBooksArray:(NSArray<BookModel *> *)booksArray{
    _booksArray = booksArray;
    [self updateDisplayState];
    if(self.collectionView){
        [self.collectionView reloadData];
    }
}

- (void)updateDisplayState{
    BOOL hasData = self.booksArray.count > 0;
        
    if (hasData) {
        // 有数据：移除空状态，显示列表
        [self.emptyStateLabel removeFromSuperview];
        self.emptyStateLabel = nil;
        self.collectionView.hidden = NO;
    } else {
        // 无数据：显示空状态，隐藏列表
        self.collectionView.hidden = YES;
        [self showEmptyState];
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.booksArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView     cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    if(indexPath.item < self.booksArray.count){
        BookModel *book = self.booksArray[indexPath.item];
        [cell configureWithBook:book];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat totalHorizontalSpacing = 16 + 12 + 16; // 左边距 ＋ 中间间距 ＋ 右边距
    CGFloat availableWidth = collectionView.frame.size.width - totalHorizontalSpacing;
    CGFloat cellWidth = availableWidth/2.0;
    
    CGFloat imageHeight = 200;
    CGFloat textHeight = 60;
    CGFloat cellHeight = imageHeight + textHeight;
    
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取消高亮状态
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(indexPath.item >= self.booksArray.count) return;
    
    BookModel *selectedBook = self.booksArray[indexPath.item];
    
    if(self.delegate){
        [self.delegate categoryPageViewController:self didSelectBook:selectedBook atIndex:indexPath.item];
    }
}

@end
