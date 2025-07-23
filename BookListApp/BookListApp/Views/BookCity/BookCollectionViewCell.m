//
//  BookCollectionViewCell.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/16.
//

#import "BookCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>



@implementation BookCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

// 设置Cell样式
- (void)setupSubviews{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    
    // 封面图片
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 8;
    self.coverImageView.backgroundColor = [UIColor systemGray6Color];
    self.coverImageView.translatesAutoresizingMaskIntoConstraints = NO; // 使用Auto layout
    [self.contentView addSubview:self.coverImageView];
    
    // 评分
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:12];
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.scoreLabel.layer.cornerRadius = 8;
    self.scoreLabel.clipsToBounds = YES;
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.coverImageView addSubview:self.scoreLabel];
    
    // 书名
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor labelColor];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    
    // 摘要
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.font = [UIFont boldSystemFontOfSize:11];
    self.descriptionLabel.textColor = [UIColor secondaryLabelColor];
    self.descriptionLabel.numberOfLines = 2;
    self.descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.descriptionLabel];
}

// 设置Cell约束
- (void)setupConstraints{
    [NSLayoutConstraint activateConstraints:@[
        // 封面图片约束
        [self.coverImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.coverImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.coverImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.coverImageView.heightAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:1.3],
        
        // 评分标签约束
        [self.scoreLabel.leadingAnchor constraintEqualToAnchor:self.coverImageView.leadingAnchor constant:8],
        [self.scoreLabel.bottomAnchor constraintEqualToAnchor:self.coverImageView.bottomAnchor constant:-8],
        [self.scoreLabel.widthAnchor constraintEqualToConstant:45],
        [self.scoreLabel.heightAnchor constraintEqualToConstant:18],
        
        // 书名约束
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.coverImageView.bottomAnchor constant:8],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        
        // 描述约束
        [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:4],
        [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.descriptionLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.descriptionLabel.bottomAnchor constraintLessThanOrEqualToAnchor:self.contentView.bottomAnchor]
    ]];
}

// 配置Cell
- (void)configureWithBook:(BookModel *)book{
    
    // 设置文本内容
    self.titleLabel.text = book.bookName?:@"未知书籍";
    self.descriptionLabel.text = book.abstract?:@"暂无摘要";
    self.scoreLabel.text = book.score?:@"暂无评分";
    
    // 加载图片
    NSString *httpsImageURL = [book.thumbUrl stringByReplacingOccurrencesOfString:@"http:" withString:@"https:"];
    NSURL *imageURL = [NSURL URLWithString:httpsImageURL];
    // 占位图
    UIImage *placeholderImage = [UIImage systemImageNamed:@"book.closed"]?:[UIImage systemImageNamed:@"book_placeholder"];
    
    [self.coverImageView sd_setImageWithURL:imageURL
                           placeholderImage:placeholderImage
                                    options:SDWebImageRetryFailed
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        if(image){
            // 新下载 添加淡入动画
            if(cacheType == SDImageCacheTypeNone){
                self.coverImageView.alpha = 0;
                [UIView animateWithDuration:0.3
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.coverImageView.alpha = 1;
                }
                                 completion:nil];
            }
        } else if(error){
            NSLog(@"图片加载失败 ： %@", error.localizedDescription);
        }
    }];
    
}

// Cell重用时清空内容
- (void)prepareForReuse{
    [super prepareForReuse];
    
    // 文本
    self.scoreLabel.text = nil;
    self.titleLabel.text = nil;
    self.descriptionLabel.text = nil;
    // 图片
    [self.coverImageView sd_cancelCurrentImageLoad];
    self.coverImageView.image = nil;
    self.coverImageView.alpha = 1;
}

@end
