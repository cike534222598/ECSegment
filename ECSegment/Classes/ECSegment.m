//
//  ECSegment.m
//  ECSegment
//
//  Created by Jame on 15/10/20.
//  Copyright © 2015年 SSIC. All rights reserved.
//


#import "ECSegment.h"

#define EC_ITEMPADDING 8.0f

#define ECSCREEN          [[UIScreen mainScreen] bounds]
#define ECSCREEN_W        [[UIScreen mainScreen]bounds].size.width
#define ECSCREEN_H        [[UIScreen mainScreen]bounds].size.height

#define ECCOLOR(r, g, b, a)             [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface ECSegment ()

@property(nonatomic, strong) UIView *buttonStyle;
@property(nonatomic, assign) CGFloat maxWidth;
@property(nonatomic, strong) NSMutableArray *buttonList;
@property(nonatomic, strong) NSMutableArray *allItems;
@property(nonatomic, weak) UIButton *buttonSelected;
@property(nonatomic, assign) ECSegmentStyle segmentStyle;
@property(nonatomic, assign) CGFloat buttonStyleY;
@property(nonatomic, assign) CGFloat buttonStyleHeight;
@property(nonatomic, assign) BOOL buttonStyleMasksToBounds;
@property(nonatomic, assign) CGFloat buttonStyleCornerRadius;

@end

@implementation ECSegment

+ (ECSegment *)ec_segmentWithFrame:(CGRect)frame style:(ECSegmentStyle)style {
    return [[ECSegment alloc] ec_initWithFrame:frame style:style];
}

#pragma mark ------初始化------
- (id)init {
    if (self = [super init]) {
        self.segmentStyle = ECSegmentLineStyle;
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if ([super initWithCoder:coder]) {
        self.segmentStyle = ECSegmentLineStyle;
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.segmentStyle = ECSegmentLineStyle;
        [self commonInit];
    }
    return self;
}

- (id)ec_initWithFrame:(CGRect)frame style:(ECSegmentStyle)style {
    if ([super initWithFrame:frame]) {
        self.segmentStyle = *(&(style));
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self buttonStyleFromSegmentStyle];
    self.ec_itemFontSize = 14;
    self.ec_itemMargin = 20;
    self.ec_itemDefaultColor = ECCOLOR(102.0f, 102.0f, 102.0f, 1.0f);
    self.itemStyleSelectedColor = ECCOLOR(202.0f, 51.0f, 54.0f, 1.0f);
    self.segmentBackgroundColor = ECCOLOR(238.0f, 238.0f, 238.0f, 1.0f);
    
    switch (self.segmentStyle) {
        case ECSegmentLineStyle:
            self.ec_itemSelectedColor = ECCOLOR(202.0f, 51.0f, 54.0f, 1.0f);
            break;
        case ECSegmentRectangleStyle:
            self.ec_itemSelectedColor = ECCOLOR(250.0f, 250.0f, 250.0f, 1.0f);
            self.ec_itemMargin = 10;
            break;
        case ECSegmentTextStyle:
            self.ec_itemSelectedColor = ECCOLOR(202.0f, 51.0f, 54.0f, 1.0f);
            break;
    }
    
    self.maxWidth = self.ec_itemMargin;
    self.buttonList = [NSMutableArray array];
    self.allItems = [NSMutableArray array];
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = self.ec_backgroundColor;
    self.buttonStyle = [[UIView alloc] initWithFrame:CGRectMake(self.ec_itemMargin, self.buttonStyleY, 0, self.buttonStyleHeight)];
    self.buttonStyle.backgroundColor = self.ec_itemStyleSelectedColor;
    self.buttonStyle.layer.masksToBounds = self.buttonStyleMasksToBounds;
    self.buttonStyle.layer.cornerRadius = self.buttonStyleCornerRadius;
    [self addSubview:self.buttonStyle];
}

- (void)setItemStyleSelectedColor:(UIColor *)itemStyleSelectedColor {
    _ec_itemStyleSelectedColor = itemStyleSelectedColor;
}

- (void)setSegmentBackgroundColor:(UIColor *)segmentBackgroundColor {
    _ec_backgroundColor = segmentBackgroundColor;
}


- (void)setEc_backgroundColor:(UIColor *)ec_backgroundColor
{
    self.backgroundColor = ec_backgroundColor;
}


- (void)setEc_itemStyleSelectedColor:(UIColor *)ec_itemStyleSelectedColor
{
    self.buttonStyle.backgroundColor = ec_itemStyleSelectedColor;
}


- (int)ec_selectedItemIndex {
    if (self.buttonSelected) {
        return [self indexOfItemsWithItem:self.buttonSelected.titleLabel.text];
    }
    return -1;
}

- (NSString *)ec_selectedItem {
    if (self.buttonSelected) {
        return self.buttonSelected.titleLabel.text;
    }
    return nil;
}


#pragma mark ------暴露给外部的------
- (void)ec_setItems:(NSArray *)items {
    if (!items || items.count == 0) {
        return;
    }
    for (int i = 0; i < self.subviews.count; i++) {
        if (self.subviews[i] != self.buttonStyle) {
            [self.subviews[i--] removeFromSuperview];
        }
    }
    self.buttonStyle.hidden = NO;
    self.maxWidth = self.ec_itemMargin;
    [self.allItems removeAllObjects];
    [self.allItems addObjectsFromArray:items];
    self.buttonList = nil;
    self.buttonList = [[NSMutableArray alloc] init];
    self.buttonSelected = nil;
    if (self.allItems && self.allItems.count > 0) {
        self.backgroundColor = self.backgroundColor;
        for (int i = 0; i < self.allItems.count; i++) {
            [self createItem:self.allItems[i]];
        }
        self.contentSize = CGSizeMake(self.maxWidth, -4);
        [self fiexButtonWidth];
    }
}

- (NSArray *)ec_items {
    return self.allItems;
}

- (void)ec_itemClickByIndex:(NSInteger)index {
    if (index < 0) {
        return;
    }
    UIButton *item = (UIButton *)self.buttonList[index];
    [self itemClick:item];
}

- (void)ec_addItem:(NSString *)item {
    if (self.buttonList.count == 0) {
        self.buttonStyle.hidden = NO;
    }
    [self.allItems addObject:item];
    [self createItem:item];
    [self resetButtonsFrame];
    [self fiexButtonWidth];
}

- (void)ec_removeItemAtIndex:(NSInteger)index {
    if (self.allItems.count == 0 || index < 0 || index >= self.allItems.count) {
        return;
    }
    [self.allItems removeObjectAtIndex:index];
    UIButton *button = self.buttonList[index];
    [self.buttonList removeObjectAtIndex:index];
    for (int i = 0; i < self.subviews.count; i++) {
        if (self.subviews[i] == button) {
            [self.subviews[i] removeFromSuperview];
        }
    }
    if (button == self.buttonSelected && self.buttonList.count > 0) {
        NSInteger _index = index;
        if (self.buttonList.count >= index && index > 0) {
            _index = index - 1;
        }
        [self itemClick:self.buttonList[_index]];
    }
    if (self.buttonList.count == 0) {
        self.buttonSelected = nil;
        self.buttonStyle.hidden = YES;
    }
    [self resetButtonsFrame];
    [self fiexButtonWidth];
}

- (void)ec_removeItem:(NSString *)item {
    if (self.allItems.count == 0 || ![self.allItems containsObject:item]) {
        return;
    }
    for (NSInteger i = 0; i < self.allItems.count; i++) {
        if ([self.allItems[i] isEqualToString:item]) {
            [self ec_removeItemAtIndex:i];
            return;
        }
    }
}

#pragma mark ------私有的------
- (void)buttonStyleFromSegmentStyle {
    switch (self.segmentStyle) {
        case ECSegmentLineStyle:
            self.buttonStyleY = self.frame.size.height - 2;
            self.buttonStyleHeight = 2.0f;
            break;
        case ECSegmentRectangleStyle:
            self.buttonStyleY = EC_ITEMPADDING;
            self.buttonStyleHeight = self.frame.size.height - EC_ITEMPADDING * 2;
            self.buttonStyleCornerRadius = 6.0f;
            self.buttonStyleMasksToBounds = YES;
            break;
        case ECSegmentTextStyle:
            self.buttonStyleY = 0;
            self.buttonStyleHeight = 0.0f;
            break;
    }
}

- (void)fiexButtonWidth {
    if (ECSCREEN_W - self.maxWidth > self.ec_itemMargin) {
        CGFloat bigButtonSumWidth = 0;
        int bigButtonCount = 0;
        self.maxWidth = self.ec_itemMargin;
        CGFloat width =
        (ECSCREEN_W - (self.buttonList.count + 1) * self.ec_itemMargin) / self.buttonList.count;
        for (int i = 0; i < self.buttonList.count; i++) {
            UIButton *button = self.buttonList[i];
            if (button.frame.size.width > width) {
                bigButtonCount++;
                bigButtonSumWidth += button.frame.size.width;
            }
        }
        width = (ECSCREEN_W - (self.buttonList.count + 1) * self.ec_itemMargin - bigButtonSumWidth) / (self.buttonList.count - bigButtonCount);
        for (int i = 0; i < self.buttonList.count; i++) {
            UIButton *button = self.buttonList[i];
            if (button.frame.size.width < width) {
                button.frame =
                CGRectMake(self.maxWidth, 0, width, self.frame.size.height);
                self.maxWidth += width + self.ec_itemMargin;
            } else {
                button.frame = CGRectMake(self.maxWidth, 0, button.frame.size.width, self.frame.size.height);
                self.maxWidth += button.frame.size.width + self.ec_itemMargin;
            }
            if (button == self.buttonSelected) {
                self.buttonStyle.frame = CGRectMake(button.frame.origin.x, self.buttonStyleY, button.frame.size.width, self.buttonStyleHeight);
            }
        }
        self.contentSize = CGSizeMake(self.maxWidth, -4);
    }
}

- (void)resetButtonsFrame {
    self.maxWidth = self.ec_itemMargin;
    
    for (int i = 0; i < self.allItems.count; i++) {
        CGFloat width = [self itemWidthFromSegmentStyle:self.allItems[i]];
        UIButton *button = self.buttonList[i];
        button.frame = CGRectMake(self.maxWidth, 0, width, self.frame.size.height);
        if (button == self.buttonSelected) {
            self.buttonStyle.frame = CGRectMake(self.maxWidth, self.buttonStyleY, width, self.buttonStyleHeight);
        }
        if (!self.buttonSelected) {
            [button setTitleColor:self.ec_itemSelectedColor forState:0];
            [self itemClick:button];
        }
        self.maxWidth += width + self.ec_itemMargin;
    }
    
    self.contentSize = CGSizeMake(self.maxWidth, -4);
}

- (void)createItem:(NSString *)item {
    CGFloat itemWidth = [self itemWidthFromSegmentStyle:item];
    UIButton *buttonItem = [[UIButton alloc] initWithFrame:CGRectMake(self.maxWidth, 0, itemWidth, self.frame.size.height)];
    buttonItem.titleLabel.font = [UIFont systemFontOfSize:self.ec_itemFontSize];
    [buttonItem setTitle:item forState:UIControlStateNormal];
    [buttonItem setTitleColor:self.ec_itemDefaultColor forState:UIControlStateNormal];
    [buttonItem addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    self.maxWidth += itemWidth + self.ec_itemMargin;
    [self.buttonList addObject:buttonItem];
    [self addSubview:buttonItem];
    if (!self.buttonSelected) {
        [buttonItem setTitleColor:self.ec_itemSelectedColor forState:0];
        self.buttonStyle.frame = CGRectMake(buttonItem.frame.origin.x, self.buttonStyleY, buttonItem.frame.size.width, self.buttonStyleHeight);
        [self itemClick:buttonItem];
    }
}

- (CGFloat)itemWidthFromSegmentStyle:(NSString *)item {
    CGFloat itemWidth = [self textWidthWithFontSize:self.ec_itemFontSize Text:item];
    CGFloat resultItemWidht;
    switch (self.segmentStyle) {
        case ECSegmentLineStyle:
            resultItemWidht = itemWidth;
            break;
        case ECSegmentRectangleStyle:
            resultItemWidht = itemWidth + EC_ITEMPADDING * 2;
            break;
        case ECSegmentTextStyle:
            resultItemWidht = itemWidth;
            break;
    }
    return resultItemWidht;
}

- (void)itemClick:(id)sender {
    UIButton *button = sender;
    if (self.buttonSelected != button) {
        [self.buttonSelected setTitleColor:self.ec_itemDefaultColor forState:0];
        [button setTitleColor:self.ec_itemSelectedColor forState:0];
        self.buttonSelected = button;
        if (self.ec_itemClickBlock) {
            int selectedIndex = [self indexOfItemsWithItem:button.titleLabel.text];
            NSString *selectedItem = button.titleLabel.text;
            self.ec_itemClickBlock(selectedItem, selectedIndex);
        }
        
        if ([self.ec_delegate respondsToSelector:@selector(ec_selectSegmentWithIndex:)]) {
            [self.ec_delegate ec_selectSegmentWithIndex:[self indexOfItemsWithItem:button.titleLabel.text]];
        }
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.buttonStyle.frame = CGRectMake(button.frame.origin.x, self.buttonStyleY, button.frame.size.width, self.buttonStyleHeight);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:
                              0.3 animations:^{
                                  CGFloat buttonX = button.frame.origin.x;
                                  CGFloat buttonWidth = button.frame.size.width;
                                  CGFloat scrollerWidth = self.contentSize.width;
                                  // 移动到中间
                                  if (scrollerWidth > ECSCREEN_W && // Scroller的宽度大于屏幕宽度
                                      buttonX > ECSCREEN_W / 2.0f - buttonWidth / 2.0f && //按钮的坐标大于屏幕中间位置
                                      scrollerWidth > buttonX + ECSCREEN_W / 2.0f + buttonWidth / 2.0f // Scroller的宽度大于按钮移动到中间坐标加上屏幕一半宽度加上按钮一半宽度
                                      ) {
                                      self.contentOffset = CGPointMake(button.frame.origin.x - ECSCREEN_W / 2.0f + button.frame.size.width / 2.0f, 0);
                                  } else if (buttonX < ECSCREEN_W / 2.0f - buttonWidth / 2.0f) { // 移动到开始
                                      self.contentOffset = CGPointMake(0, 0);
                                  } else if (scrollerWidth - buttonX < ECSCREEN_W / 2.0f + buttonWidth / 2.0f || // Scroller的宽度减去按钮的坐标小于屏幕的一半，移动到最后
                                             buttonX + buttonWidth + self.ec_itemMargin == scrollerWidth) {
                                      if (scrollerWidth > ECSCREEN_W) {
                                          self.contentOffset = CGPointMake(scrollerWidth - ECSCREEN_W, 0); // 移动到末尾
                                      }
                                  }
                              }];
                         }];
    }
}

- (int)indexOfItemsWithItem:(NSString *)item {
    for (int i = 0; i < self.allItems.count; i++) {
        if ([item isEqualToString:self.allItems[i]]) {
            return i;
        }
    }
    return -1;
}

- (CGFloat)textWidthWithFontSize:(CGFloat)fontSize Text:(NSString *)text {
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    CGRect size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                       options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                    attributes:attr
                       context:nil];
    return size.size.width;
}

@end
