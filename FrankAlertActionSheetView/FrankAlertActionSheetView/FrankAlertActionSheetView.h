//
//  FrankAlertActionSheetView.h
//  FrankAlertActionSheetView
//
//  Created by Frank on 17/4/7.
//  Copyright © 2017年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 展示按钮点击回调
 
 @param indexString 点击按钮展示内容
 @param buttonIndex 按钮标签
 */
typedef void(^ClickedButtonBlock) (NSString * indexString,NSInteger buttonIndex);
/**
 关闭提示框
 */
typedef void(^CloseAlertViewBlock) ();

/**
 提示框展示效果 【对于 AlertStyle_CustomAlert 效果】
 
 - ViewAnimateNone: 无动画
 - ViewAnimateFromTop: 从顶部进入，底部退出
 - ViewAnimateFromLeft: 从左侧进入，右侧退出
 - ViewAnimateFromRight: 从右侧进入，左侧退出
 - ViewAnimateFromBottom: 从底部进入，顶部底部退出
 - ViewAnimateScale: 放大效果
 */
typedef NS_ENUM(NSInteger, ViewAlertAnimateStyle) {
    
    ViewAnimateNone = 0,
    ViewAnimateFromTop,
    ViewAnimateFromLeft,
    ViewAnimateFromRight,
    ViewAnimateFromBottom,
    ViewAnimateScale
    
};
/**
 自定义视图的位置
 
 - CustomViewPosition_Center: 居中【默认】
 - CustomViewPosition_Top: 顶部
 - CustomViewPosition_Bottom: 底部
 */
typedef NS_ENUM(NSInteger, CustomViewPosition) {
    
    CustomViewPosition_Center = 0,
    CustomViewPosition_Top,
    CustomViewPosition_Bottom
    
};



@interface FrankAlertActionSheetView : UIView

/**
 标题颜色
 */
@property(nonatomic,strong)UIColor * titleColor;
/**
 提示框按钮标题颜色
 */
@property(nonatomic,strong)UIColor * buttonTitleColor;
/**
 提示信息颜色
 */
@property(nonatomic,strong)UIColor * messageColor;
/**
 标题字号
 */
@property(nonatomic,assign)CGFloat titleFont;
/**
 提示信息字号
 */
@property(nonatomic,assign)CGFloat messageFont;

/**
 关闭提示回调
 */
@property (nonatomic,copy)CloseAlertViewBlock closedBlock;


/**
 UIAlertController 系统提示框
 
 @param style 类型
 @param title 标题
 @param message 信息
 @param completedClickBlock 按钮回调
 @param cancelButtonTitle 取消按钮 标签 buttonIndex = -1
 @param otherButtonTitles 其它按钮 标签 buttonIndex = 1，2，3...
 @return 实例对象
 */
- (instancetype)initSystemAlertActionWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message completeBlock:(ClickedButtonBlock)completedClickBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 展示自定义弹框视图
 
 @param alertView 自定义视图
 @param animateStyle 动画展示类型
 @param position 视图位置
 
 @return 实例对象
 */
- (instancetype)initCustomView:(UIView *)alertView animateStyle:(ViewAlertAnimateStyle)animateStyle position:(CustomViewPosition)position;


/**
 actionSheet 提示框
 
 @param title 标题
 @param message 提示信息
 @param cancelButtonTitle 取消按钮  标签 buttonIndex = -1
 @param otherButtonTitles 其他操作按钮 标签 buttonIndex = 1，2，3...
 @return 实例对象
 */
- (instancetype)initCustomActionSheetWithTitle:(NSString *)title message:(NSString *)message completeBlock:(ClickedButtonBlock)completedClickBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


/**
 展示
 */
- (void)show;


@end

#pragma mark ----- 调用系统 Alert 、 ActionSheet

/**
 自定义 ActionSheet 的 cell
 */
@interface ActionSheetCell : UITableViewCell

@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UILabel *infoLabel;

/**
 设置cell 数据
 
 @param title 标题
 @param hidden 时候需要隐藏顶部视图
 */
-(void)resetupCellWithTitle:(NSString *)title hiddenTopView:(BOOL)hidden;

@end

