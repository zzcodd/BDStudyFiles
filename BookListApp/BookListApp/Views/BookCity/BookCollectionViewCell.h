//
//  BookCollectionViewCell.h
//  BookListApp
//
//  Created by ByteDance on 2025/7/16.
//

#import <UIKit/UIKit.h>
#import "../../Models/BookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *coverImageView;
@property(nonatomic, strong) UILabel *scoreLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *descriptionLabel;

- (void)configureWithBook:(BookModel *)book;

@end

NS_ASSUME_NONNULL_END
