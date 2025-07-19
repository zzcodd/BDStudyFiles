//
//  CategorySegmentView.h
//  BookListApp
//
//  Created by ByteDance on 2025/7/18.
//

#import <UIKit/UIKit.h>
#import "../../Models/BookModel.h"
NS_ASSUME_NONNULL_BEGIN

@class CategoryPageViewController;

@protocol CategoryPageViewControllerDelegate <NSObject>

- (void)categoryPageViewController:(CategoryPageViewController *)pageViewController didSelectBook:(BookModel *)book atIndex:(NSInteger)index;

@end


@interface CategoryPageViewController : UIViewController

@property (nonatomic, assign) NSInteger categoryIndex;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSArray<BookModel *> *booksArray;
@property (nonatomic, weak) id<CategoryPageViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
