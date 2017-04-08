# FrankAlertActionSheetView
FrankAlertActionSheetView提示框样式封装，支持自定义动画、样式、以及系统【支持iOS8.0】Alert、ActionSheet，使用简单易用

使用方法说明：

<h4>为了增强界面的样式的定制性，使用在该类中提供了一些属性进行样式定制：</h4>

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



<h4>另外也提供了两种枚举，只是针对自定义View展示所提供的 动画、位置 样式：</h4>
/**

提示框展示效果 【对于 AlertStyle_CustomAlert 效果】

-ViewAnimateNone: 无动画
-ViewAnimateFromTop: 从顶部进入，底部退出
-ViewAnimateFromLeft: 从左侧进入，右侧退出
-ViewAnimateFromRight: 从右侧进入，左侧退出
-ViewAnimateFromBottom: 从底部进入，顶部底部退出
-ViewAnimateScale: 放大效果

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

-CustomViewPosition_Center: 居中【默认】
-CustomViewPosition_Top: 顶部
-CustomViewPosition_Bottom: 底部

*/

typedef NS_ENUM(NSInteger, CustomViewPosition) {

CustomViewPosition_Center = 0,
CustomViewPosition_Top,
CustomViewPosition_Bottom

};


<h4>该类主要提供了四个方法以供调用，分别是：</h4>

/**

用来调用系统 UIAlertController 样式

@param style 类型
@param title 标题
@param message 信息
@param completedClickBlock 按钮回调
@param cancelButtonTitle 取消按钮 标签 buttonIndex = -1
@param otherButtonTitles 其它按钮 标签 buttonIndex = 1，2，3...
@return 实例对象

*/

-(instancetype)initSystemAlertActionWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message completeBlock:(ClickedButtonBlock)completedClickBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**

展示自定义弹框视图

@param alertView 自定义视图
@param animateStyle 动画展示类型
@param position 视图位置
@return 实例对象

*/

-(instancetype)initCustomView:(UIView *)alertView animateStyle:(ViewAlertAnimateStyle)animateStyle position:(CustomViewPosition)position;


/**

类似微信 actionSheet 提示框，并且增加了标题、描述信息功能

@param title 标题
@param message 提示信息
@param cancelButtonTitle 取消按钮  标签 buttonIndex = -1
@param otherButtonTitles 其他操作按钮 标签 buttonIndex = 1，2，3...
@return 实例对象

*/

-(instancetype)initCustomActionSheetWithTitle:(NSString *)title message:(NSString *)message completeBlock:(ClickedButtonBlock)completedClickBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


/**
展示方法，提示框的展示都需要调用该方法

*/

-(void)show;

