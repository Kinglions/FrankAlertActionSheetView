//
//  FrankAlertActionSheetView.m
//  FrankAlertActionSheetView
//
//  Created by Frank on 17/4/7.
//  Copyright © 2017年 Frank. All rights reserved.
//

#import "FrankAlertActionSheetView.h"

#import "AlertController.h"
#import <objc/runtime.h>

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height


/**
 提示框类型
 
 - AlertStyle_SystemAlert: 系统提示框
 - AlertStyle_SystemActionSheet: 系统ActionSheet
 - AlertStyle_CustomAlert: 自定义提示视图
 - AlertStyle_ActionSheet: ActionSheet
 
 */
typedef NS_ENUM(NSInteger,AlertStyle) {
    
    AlertStyle_SystemAlert=0,
    AlertStyle_SystemActionSheet,
    AlertStyle_CustomAlert,
    AlertStyle_CustomActionSheet,
    
};



@interface FrankAlertActionSheetView ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

/* ----------------使用系统提示框设置属性------------------- */
@property(nonatomic,strong)AlertController * alert;
@property(nonatomic,strong)UIViewController * viewController;
/* ----------------------------------- */


/* ----------------使用自定义视图提示框设置属性------------------- */
/**
 自定义视图 手势
 */
@property (nonatomic,strong)UITapGestureRecognizer *alertTap;
/**
 自定义视图的位置
 */
@property (nonatomic,assign)CustomViewPosition c_position;
/* ----------------------------------- */



/* ----------------ActionSheet设置属性------------------- */
/**
 ActionSheet 手势
 */
@property (nonatomic,strong)UITapGestureRecognizer *sheetTap;

/**
 标题
 */
@property (copy,nonatomic)NSString * title;
/**
 描述信息
 */
@property (copy,nonatomic)NSString * message;
/**
 取消按钮标题
 */
@property (copy,nonatomic)NSString * cancelTitle;
/**
 数据源
 */
@property (strong,nonatomic)NSArray *dataArray;
/**
 自定义actionSheet的tableView
 */
@property (strong,nonatomic)UITableView *actionSheetTableView;
/**
 tableView高度
 */
@property (nonatomic,assign) CGFloat recodeTableViewHeight;
/**
 tableView组头高度
 */
@property (nonatomic,assign) CGFloat recodeSectionHeaderHeight;

/* ----------------------------------- */


/**
 展示类型
 */
@property (nonatomic,assign) AlertStyle viewStyle;


/**
 提示框视图
 */
@property (nonatomic,strong) UIView *alertView;
/**
 自定义视图的高
 */
@property (nonatomic,assign)CGFloat alertView_H;
/**
 自定义视图的高
 */
@property (nonatomic,assign)CGFloat alertView_W;




/**
 点击选择执行按钮回调
 */
@property (nonatomic,copy)ClickedButtonBlock clickedBtnBlock;

/**
 动画类型 【对于 actionSheet 无效】
 */
@property (nonatomic,assign) ViewAlertAnimateStyle viewAnimateStyle;

@end

@implementation FrankAlertActionSheetView

/**
 UIAlertController 系统提示框
 
 @param style 类型
 @param title 标题
 @param message 信息
 @param completedClickBlock 按钮回调
 @param cancelButtonTitle 取消按钮
 @param otherButtonTitles 其它按钮
 @return 实例对象
 */
- (instancetype)initSystemAlertActionWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message completeBlock:(ClickedButtonBlock)completedClickBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    
    if(self = [super initWithFrame:[UIScreen mainScreen].bounds]){
        
        self.viewStyle = AlertStyle_SystemAlert;
        
        UIViewController * viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        if([viewController isKindOfClass:[UINavigationController class]]){
            viewController = ((UINavigationController *)viewController).topViewController;
        }
        
        self.viewController = viewController;
        
        self.alert = [AlertController alertControllerWithTitle:title message:message preferredStyle:style];
        
        // 定义一个指向可选参数列表的指针
        va_list args;
        // 获取第一个可选参数的地址，此时参数列表指针指向函数参数列表中的第一个可选参数
        va_start(args, otherButtonTitles);
        if(otherButtonTitles)
        {
            NSInteger actionindex = 1;
            AlertAction * action = [AlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if(completedClickBlock){
                    completedClickBlock(otherButtonTitles,actionindex);
                }
            }];
            
            [self.alert addAction:action];
            
            // 遍历参数列表中的参数，并使参数列表指针指向参数列表中的下一个参数
            NSString *nextArg;
            while((nextArg = va_arg(args, NSString *)))
            {
                actionindex += 1;
                
                AlertAction * action = [AlertAction actionWithTitle:nextArg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if(completedClickBlock){
                        completedClickBlock(nextArg,actionindex);
                    }
                }];
                
                [self.alert addAction:action];
            }
        }
        // 结束可变参数的获取(清空参数列表)
        va_end(args);
        
        
        if (cancelButtonTitle)
        {
            AlertAction * cancelAction = [AlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                if(completedClickBlock){
                    completedClickBlock(cancelButtonTitle,-1);
                }
            }];
            
            [self.alert addAction:cancelAction];
        }
    }
    
    return self;
}


- (instancetype)initCustomView:(UIView *)alertView animateStyle:(ViewAlertAnimateStyle)animateStyle position:(CustomViewPosition)position{
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        self.viewStyle = AlertStyle_CustomAlert;
        self.alertView = alertView;
        
        self.alertView_H = alertView.bounds.size.height;
        
        self.alertView_W = alertView.bounds.size.width;
        
        // 注意顺序
        self.c_position = position;
        self.viewAnimateStyle = animateStyle;//默认无动画
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
        
        self.alertTap = tap;
        
        tap.delegate = self;
        
        [self addGestureRecognizer:tap];
        
    }
    
    return self;
    
}

/* ----------------ActionSheet设置属性------------------- */

/**
 actionSheet 提示框
 
 @param title 标题
 @param message 提示信息
 @param cancelButtonTitle 取消按钮
 @param otherButtonTitles 其他操作按钮
 @return 实例对象
 */
- (instancetype)initCustomActionSheetWithTitle:(NSString *)title message:(NSString *)message completeBlock:(ClickedButtonBlock)completedClickBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    
    if(self = [super initWithFrame:[UIScreen mainScreen].bounds]){
        
        self.viewStyle = AlertStyle_CustomActionSheet;
        self.title = title;
        self.message = message;
        __weak typeof(self) weakSelf = self;
        
        
        self.clickedBtnBlock = completedClickBlock;
        NSMutableArray * indexTextArray = [NSMutableArray arrayWithCapacity:0];
        // 定义一个指向可选参数列表的指针
        va_list args;
        // 获取第一个可选参数的地址，此时参数列表指针指向函数参数列表中的第一个可选参数
        va_start(args, otherButtonTitles);
        if(otherButtonTitles)
        {
            NSInteger actionindex = 1;
            
            [indexTextArray addObject:otherButtonTitles];
            
            // 遍历参数列表中的参数，并使参数列表指针指向参数列表中的下一个参数
            NSString *nextArg;
            while((nextArg = va_arg(args, NSString *)))
            {
                actionindex += 1;
                
                [indexTextArray addObject:nextArg];
            }
        }
        // 结束可变参数的获取(清空参数列表)
        va_end(args);
        
        cancelButtonTitle = cancelButtonTitle ?:@"取消";
        self.cancelTitle = cancelButtonTitle;
        [indexTextArray addObject:cancelButtonTitle];
        
        self.dataArray =indexTextArray;
        self.recodeSectionHeaderHeight = [self getSectionHeaderHeight];
        self.actionSheetTableView.dataSource = self;
        self.actionSheetTableView.delegate = self;
        
        weakSelf.actionSheetTableView.frame = CGRectMake(0, Screen_Height, Screen_Width, 0);
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.actionSheetTableView.frame = CGRectMake(0, Screen_Height - weakSelf.recodeTableViewHeight, Screen_Width, weakSelf.recodeTableViewHeight);
            
        }];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
        self.sheetTap = tap;
        
        tap.delegate = self;
        
        [self addGestureRecognizer:tap];
        
    }
    
    return self;
}
/**
 懒加载tableView
 */
-(UITableView *)actionSheetTableView{
    if (!_actionSheetTableView) {
        _actionSheetTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        // 按钮 + 标题
        CGFloat showTableViewHeight = self.dataArray.count * 44 + 10 + self.recodeSectionHeaderHeight;
        
        if (showTableViewHeight > Screen_Height/4 * 3) {
            
            showTableViewHeight = Screen_Height/4 * 3;
            _actionSheetTableView.scrollEnabled = YES;
        }else{
            _actionSheetTableView.scrollEnabled = NO;
        }
        self.recodeTableViewHeight = showTableViewHeight;
        
        [_actionSheetTableView registerClass:[ActionSheetCell class] forCellReuseIdentifier:@"cellID"];
        _actionSheetTableView.separatorStyle = UITableViewCellAccessoryNone;
        _actionSheetTableView.showsVerticalScrollIndicator = NO;
        [self addSubview:_actionSheetTableView];
        
    }
    
    return _actionSheetTableView;
}

/**
 获取组头高度
 */
- (CGFloat)getSectionHeaderHeight
{
    CGFloat strHeight = 0;
    if (self.message.length > 0) {
        
        CGSize maxSize=CGSizeMake(Screen_Width-30, 99999);
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:self.messageFont]};
        strHeight = [self.message boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
    }
    
    if (self.title.length > 0) {
        
        strHeight += 44;
    }
    
    return strHeight + 10;
}
-(CGFloat)messageFont{
    
    if (_messageFont < 10 || _messageFont > 20) {
        
        return 16.f;
    }
    
    return _messageFont;
}
-(CGFloat)titleFont{
    
    if (_titleFont < 10 || _titleFont > 20) {
        return 17.f;
    }
    
    return _titleFont;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.recodeSectionHeaderHeight)];
    // 记录 message 的其实y值
    CGFloat y = 0;
    if (self.title.length > 0) {
        
        y = 44;
        UILabel * titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, y)];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = self.titleColor?:[UIColor blackColor];
        titleL.text = self.title;
        titleL.font = [UIFont systemFontOfSize:self.titleFont];
        titleL.contentMode = UIViewContentModeCenter;
        [view addSubview:titleL];
        UIView * sepV = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width/4, 43,Screen_Width/2 , 1)];
        sepV.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0  blue:246.0/255.0  alpha:1.0];
        [view addSubview:sepV];
        
    }
    if (self.message.length > 0) {
        
        UILabel * messageL = [[UILabel alloc]initWithFrame:CGRectMake(15, y, Screen_Width-30, self.recodeSectionHeaderHeight-y)];
        messageL.textAlignment = NSTextAlignmentCenter;
        messageL.textColor = self.messageColor?:[UIColor blackColor];
        messageL.text = self.message;
        messageL.numberOfLines = 0;
        messageL.font = [UIFont systemFontOfSize:self.messageFont];
        [view addSubview:messageL];
        UIView * sepV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view.bounds)-1,Screen_Width, 1)];
        sepV.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0  blue:246.0/255.0  alpha:1.0];
        [view addSubview:sepV];
    }
    
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ActionSheetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0  blue:246.0/255.0  alpha:1.0];
    
    BOOL hidden = indexPath.row == self.dataArray.count-1 ? NO:YES;
    
    cell.infoLabel.textColor = self.buttonTitleColor?:[UIColor blackColor];
    
    [cell resetupCellWithTitle:self.dataArray[indexPath.row] hiddenTopView:hidden];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count - 1) {
        return 54;
    }
    
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.recodeSectionHeaderHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.clickedBtnBlock) {
        
        NSString * cancel = self.dataArray.lastObject;
        
        NSInteger i = 0;
        
        if ([cancel isEqualToString:self.cancelTitle]) {
            
            if (indexPath.row == self.dataArray.count - 1) {
                
                i = -1;
                
            }else{
                
                i = indexPath.row + 1;
            }
            
            
        }else{
            
            i = indexPath.row + 1;
        }
        
        self.clickedBtnBlock(self.dataArray[indexPath.row],i);
    }
    
    [self dismissView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <= 0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
}
/* ----------------ActionSheet设置属性------------------- */

/**
 设置动画类型
 */
-(void)setViewAnimateStyle:(ViewAlertAnimateStyle)viewAnimateStyle{
    
    _viewAnimateStyle = viewAnimateStyle;
    
    CGPoint point = [self getOriginCenterPoint];
    
    if (self.viewStyle == AlertStyle_CustomAlert) {
        
        if (viewAnimateStyle == ViewAnimateFromLeft) {
            
            self.alertView.frame = CGRectMake(- self.alertView_W, point.y - self.alertView_H/2 , self.alertView_W, self.alertView_H);
            
        } else if (viewAnimateStyle == ViewAnimateFromRight) {
            
            self.alertView.frame = CGRectMake(Screen_Width, point.y - self.alertView_H/2 , self.alertView_W, self.alertView_H);
            
        } else if (viewAnimateStyle == ViewAnimateFromTop) {
            
            self.alertView.frame = CGRectMake((Screen_Width - self.alertView_W) / 2, - self.alertView_H , self.alertView_W, self.alertView_H);
            
        } else if (viewAnimateStyle == ViewAnimateFromBottom) {
            
            self.alertView.frame = CGRectMake((Screen_Width - self.alertView_W) / 2, Screen_Height , self.alertView_W, self.alertView_H);
            
        } else if (viewAnimateStyle == ViewAnimateScale) {
            
            self.alertView.center = point;

            self.alertView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
            
        } else {
            
            self.alertView.center = point;
            
        }
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.alertView.alpha = 0;
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
        
        if (weakSelf.viewAnimateStyle == ViewAnimateScale) {
            
            weakSelf.alertView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }
        self.alertView.center = point;
        self.alertView.alpha = 1.f;

    } completion:^(BOOL finished) {
        
    }];
    
    [self addSubview:self.alertView];
    
}
/**
 根据位置关系重新设置 自定义视图位置
 */
-(CGPoint)getOriginCenterPoint{
    
    CGPoint point = CGPointZero;
    
    switch (self.c_position) {
        case CustomViewPosition_Top:
        {
            point = CGPointMake(self.center.x, self.alertView_H/2);
        }
            break;
        case CustomViewPosition_Center:
        {
            point = self.center;
        }
            break;
        case CustomViewPosition_Bottom:
        {
            point = CGPointMake(self.center.x, CGRectGetHeight(self.bounds) - self.alertView_H/2);
        }
            break;
            
        default:
            break;
    }
    
    return point;
}
#pragma mark --- UIGestureRecognizerDelegate ----
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 当点击自定义视图时，不触发手势效果 【使用 touchBegin 方法同样】
    if (gestureRecognizer == self.sheetTap) {
        
        if ([touch.view isDescendantOfView:self.actionSheetTableView]) {
            return NO;
        }
        
    } else {
        
        if ([touch.view isDescendantOfView:self.alertView] ) {
            return NO;
        }
        
    }
    
    return YES;
}
/**
 点击手势
 */
- (void)tapMethod:(UITapGestureRecognizer *)tap {
    
    if (self.closedBlock) {
        
        self.closedBlock();
    }
    
    if (self.viewStyle == AlertStyle_CustomAlert) {
        
        [self dismissAlertView];
        
    } else {
        
        [self dismissView];
        
    }
    
}
/**
 关闭 actionSheet
 */
- (void)dismissView{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        weakSelf.actionSheetTableView.frame = CGRectMake(0, Screen_Height, Screen_Width, weakSelf.recodeTableViewHeight);
        weakSelf.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        weakSelf.alertView.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        weakSelf.actionSheetTableView = nil;
        
        [weakSelf removeFromSuperview];
    }];
}
/**
 关闭 自定义提示视图
 */
- (void)dismissAlertView {
    __weak typeof(self) weakSelf = self;
    
    CGPoint point = [self getOriginCenterPoint];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (weakSelf.viewAnimateStyle == ViewAnimateFromLeft) {
            
            weakSelf.alertView.frame = CGRectMake(Screen_Width, point.y - weakSelf.alertView_H / 2, weakSelf.alertView_W, weakSelf.alertView_H);
            
        } else if (weakSelf.viewAnimateStyle == ViewAnimateFromRight) {
            
            weakSelf.alertView.frame = CGRectMake(- weakSelf.alertView_W, point.y - weakSelf.alertView_H/2 , weakSelf.alertView_W, weakSelf.alertView_H);
            
        } else if (weakSelf.viewAnimateStyle == ViewAnimateFromBottom) {
            
            weakSelf.alertView.frame = CGRectMake((Screen_Width - weakSelf.alertView_W) / 2, Screen_Height , weakSelf.alertView_W, weakSelf.alertView_H);
            
        } else if (weakSelf.viewAnimateStyle == ViewAnimateFromTop) {
            
            weakSelf.alertView.frame = CGRectMake((Screen_Width - weakSelf.alertView_W) / 2, - weakSelf.alertView_H , weakSelf.alertView_W, weakSelf.alertView_H);
            
        } else if (weakSelf.viewAnimateStyle == ViewAnimateScale) {
            
            weakSelf.alertView.center = point;
            
            weakSelf.alertView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
            
        }
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        weakSelf.alertView.alpha = 0.f;

        
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
        
    }];
    
}
/**
 展示
 */
-(void)show{
    
    switch (self.viewStyle) {
        case AlertStyle_SystemAlert:
        case AlertStyle_SystemActionSheet:
        {
            /* 设置颜色及字号大小  */
            self.alert.titleFont = self.titleFont;
            self.alert.messageFont = self.messageFont;
            
            if (self.titleColor) {
                
                self.alert.titleColor = self.titleColor;
            }
            if (self.buttonTitleColor) {
                
                self.alert.tintColor = self.buttonTitleColor;
            }
            if (self.messageColor) {
                
                self.alert.messageColor = self.messageColor;
            }
            [self.viewController presentViewController:self.alert animated:YES completion:nil];
            [self.viewController.view bringSubviewToFront:self.alert.view];
            
        }
            break;
        case AlertStyle_CustomAlert:
        case AlertStyle_CustomActionSheet:
        {
            UIWindow *currentWindows = [[[UIApplication sharedApplication] delegate] window];
            
            UIViewController * viewController = [self getCurrentVC];
            /// 防止系统键盘弹出
            [viewController.view endEditing:YES];
            
            self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
            
            __weak typeof(self) weakSelf = self;
            [currentWindows addSubview:self];
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
            }];
            
            
        }
            break;
            
        default:
            break;
    }
    
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
-(void)dealloc{
    
    if (self.alertTap) {
        
        [self removeGestureRecognizer:self.alertTap];
    }
    if (self.sheetTap) {
        
        [self removeGestureRecognizer:self.sheetTap];
    }
    
}

@end



@implementation ActionSheetCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 10)];
        self.topView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0  blue:246.0/255.0  alpha:1.0];
        [self addSubview:self.topView];
        
        self.infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, Screen_Width, 44)];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.infoLabel];
        
        UIView * sepV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-1,Screen_Width , 1)];
        sepV.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0  blue:246.0/255.0  alpha:1.0];
        [self addSubview:sepV];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

/**
 设置cell 数据
 
 @param title 标题
 @param hidden 时候需要隐藏顶部视图
 */
-(void)resetupCellWithTitle:(NSString *)title hiddenTopView:(BOOL)hidden{
    
    self.infoLabel.text = title;
    self.topView.hidden = hidden;
    
    if (hidden) {
        self.infoLabel.frame = CGRectMake(0, 0, Screen_Width, CGRectGetHeight(self.infoLabel.bounds));
    }else{
        self.infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, Screen_Width, 44)];
    }
}


@end


