//
//  CategorySegmentView.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/18.
//

#import "CategorySegmentView.h"

@interface CategorySegmentView ()

@property (nonatomic, strong) NSArray<NSString *> *categories;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;

@end

@implementation CategorySegmentView

- (instancetype)initWithCategories:(NSArray<NSString *> *)categories{
    self = [super init];
    if(self){
        _categories = categories;
        _selectedIndex = 0;
        _buttons = [NSMutableArray array];
        [self setupUI];
        // 不推荐：此时视图大小还不确定，容易造成混乱
//        [self createButtons];
    }
    return self;
}

- (void)setupUI{
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = YES;
    [self addSubview:self.scrollView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置scrollView的frame
    self.scrollView.frame = self.bounds;
    
    // 如果按钮还没创建，创建按钮
    if (self.buttons.count == 0) {
        [self createButtons];
    }
}

- (void)createButtons {
    CGFloat x = 16;
    CGFloat buttonHeight = 30;
    CGFloat buttonY = (self.bounds.size.height - buttonHeight) / 2; // 垂直居中
    
    for (NSInteger i = 0; i < self.categories.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = i;
        [button setTitle:self.categories[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        // 计算按钮尺寸
        [button sizeToFit];
        CGFloat width = MAX(button.frame.size.width + 20, 50); // 最小宽度50
        button.frame = CGRectMake(x, buttonY, width, buttonHeight);
        
        [self.scrollView addSubview:button];
        [self.buttons addObject:button];
        
        x += width + 20;
    }
    
    // 设置滚动视图内容大小
    self.scrollView.contentSize = CGSizeMake(x, self.bounds.size.height);
    
    // 设置初始选中状态
    [self updateButtonStyles];
    
    NSLog(@"✅ CategorySegmentView: 创建了%lu个按钮，总宽度:%.1f，scrollView宽度:%.1f",
          (unsigned long)self.buttons.count, x, self.bounds.size.width);
}

- (void)buttonTapped:(UIButton *)sender {
    NSInteger newIndex = sender.tag;
    [self setSelectedIndex:newIndex animated:YES];
    
    if (self.delegate) {
        [self.delegate categorySegmentView:self didSelectIndex:newIndex];
    }
    
    NSLog(@"📂 CategorySegmentView: 点击了 %@", self.categories[newIndex]);
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < 0 || index >= self.categories.count) return;
    
    _selectedIndex = index;
    [self updateButtonStyles];
    [self scrollToSelectedButton];
}

- (void)updateButtonStyles {
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        if (i == self.selectedIndex) {
            // 选中状态
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor systemOrangeColor];
            button.layer.cornerRadius = 15;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        } else {
            // 未选中状态
            [button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            button.layer.cornerRadius = 0;
            button.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
}

// 选中的按钮自动滚动到 ScrollView 的可视区域中央
- (void)scrollToSelectedButton {
    if (self.selectedIndex >= 0 && self.selectedIndex < self.buttons.count) {
        UIButton *selectedButton = self.buttons[self.selectedIndex];
        
        // 按钮在 父视图scrollView 中的 frame（位置和尺寸）
        CGRect buttonFrame = selectedButton.frame;
        // 按钮中心x坐标   buttonFrame.origin.x 是按钮左上角在 scrollView 中的 X 坐标；
        CGFloat centerX = buttonFrame.origin.x + buttonFrame.size.width / 2;
        
        // 计算滚动视图需要滚动到的目标 X 坐标
        CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
        CGFloat targetX = centerX - scrollViewWidth / 2;
        
        // 限制滚动范围
        CGFloat maxX = MAX(0, self.scrollView.contentSize.width - scrollViewWidth);
        targetX = MAX(0, MIN(targetX, maxX));
        
        [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    }
}
@end
