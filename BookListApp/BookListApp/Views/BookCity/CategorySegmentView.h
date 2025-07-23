//
//  CategorySegmentView.h
//  BookListApp
//
//  Created by ByteDance on 2025/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CategorySegmentView;

// 代理协议 ：需要对分类选择进行回调
@protocol CategorySegmentViewDelegate <NSObject>

- (void)categorySegmentView:(CategorySegmentView *)segmentView didSelectIndex:(NSInteger)index;

@end


@interface CategorySegmentView : UIView

@property(nonatomic, weak) id<CategorySegmentViewDelegate> delegate;
@property(nonatomic, assign) NSInteger selectedIndex;

- (instancetype)initWithCategories:(NSArray<NSString *> *)categories;
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
