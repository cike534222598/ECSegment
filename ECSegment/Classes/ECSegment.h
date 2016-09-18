//
//  ECSegment.h
//  ECSegment
//
//  Created by Jame on 15/10/20.
//  Copyright © 2015年 SSIC. All rights reserved.
//


#import <UIKit/UIKit.h>


#pragma mark ------PROTOCOL------
@protocol ECSegmentDelegate <NSObject>


@optional

- (void)ec_selectSegmentWithIndex:(NSInteger)selectIndex;

@end


#pragma mark ------ECSEGMENTSTYLE------
/**
 *  样式
 */
typedef enum {
    /**
     *  线条样式
     */
    ECSegmentLineStyle = 0,
    /**
     *  矩形样式
     */
    ECSegmentRectangleStyle = 1,
    /**
     *  文字样式
     */
    ECSegmentTextStyle = 2,
    /**
     *  图文样式
     */
//    ECSegmentImageAndTextStyle = 3
} ECSegmentStyle;




@interface ECSegment : UIScrollView

#pragma mark ------SEGMENT------
/**
 *  每一项颜色
 *
 *  默认 [r:102.0f,g:102.0f,b:102.0f]
 */
@property(nonatomic, strong) UIColor *ec_itemDefaultColor;
/**
 *  选中项颜色
 *
 *  ECSegmentLineStyle 默认 [r:202.0, g:51.0, b:54.0]
 *  ECSegmentRectangleStyle 默认[r:250.0, g:250.0, b:250.0]
 *  ECSegmentTextStyle 默认 [r:202.0, g:51.0, b:54.0]
 */
@property(nonatomic, strong) UIColor *ec_itemSelectedColor;
/**
 *  选中项样式颜色
 *
 *  默认 [r:202.0, g:51.0, b:54.0]
 */
@property(nonatomic, strong) UIColor *ec_itemStyleSelectedColor;
/**
 *  背景色
 *
 *  默认 [r:238.0, g:238.0, b:238.0]
 */
@property(nonatomic, strong) UIColor *ec_backgroundColor;
/**
 *  每一项字体大小
 *
 *  默认 14
 */
@property(nonatomic, assign) CGFloat ec_itemFontSize;
/**
 *  每一项间距
 *
 *  默认 20
 */
@property(nonatomic, assign) CGFloat ec_itemMargin;
/**
 *  项切换 Block
 */
@property(nonatomic, copy) void (^ec_itemClickBlock) (NSString *itemName, NSInteger itemIndex);
/**
 *  项切换 Delegate
 */
@property (nonatomic,unsafe_unretained) id <ECSegmentDelegate> ec_delegate;
/**
 *  获取当前选中项索引
 */
@property(nonatomic, readonly, getter=ec_selectedItemIndex) int ec_selectedItemIndex;
/**
 *  获取当前选中项
 */
@property(nonatomic, strong, readonly, getter=ec_selectedItem) NSString *ec_selectedItem;


#pragma mark ------ACTION------
/**
 *  工厂方法，创建不同样式的选择器
 */
+ (ECSegment *)ec_segmentWithFrame:(CGRect)frame style:(ECSegmentStyle)style;
/**
 *  初始化
 */
- (id)ec_initWithFrame:(CGRect)frame style:(ECSegmentStyle)style;
/**
 *  设置项目集合
 */
- (void)ec_setItems:(NSArray *)items;
/**
 *  获取项目集合
 */
- (NSArray *)ec_items;
/**
 *  根据索引触发单击事件
 */
- (void)ec_itemClickByIndex:(NSInteger)index;
/**
 *  添加一项
 */
- (void)ec_addItem:(NSString *)item;
/**
 *  根据索引移除一项
 */
- (void)ec_removeItemAtIndex:(NSInteger)index;
/**
 *  移除指定项
 */
- (void)ec_removeItem:(NSString *)item;

@end
