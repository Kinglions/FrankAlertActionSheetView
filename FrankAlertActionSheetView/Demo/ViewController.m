//
//  ViewController.m
//  FrankAlertView
//
//  Created by Frank on 17/4/6.
//  Copyright © 2017年 Frank. All rights reserved.
//

#import "ViewController.h"
#import "FrankAlertActionSheetView.h"

@interface ViewController ()

/**
 位置关系
 */
@property (nonatomic,assign)CustomViewPosition position;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.position = CustomViewPosition_Top;
    
}

/**
 位置状态选择器改变
 */
- (IBAction)segmentControlValueChangedMethod:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            self.position = CustomViewPosition_Top;
        }
            break;
        case 1:
        {
            self.position = CustomViewPosition_Center;
        }
            break;
        case 2:
        {
            self.position = CustomViewPosition_Bottom;
        }
            break;
            
        default:
            break;
    }
}

/**
 自定义视图样式、动画
 */
- (IBAction)CustomAlertClick:(UIButton *)btn{
    
#pragma mark ----- 自定义的弹出view
    
    ViewAlertAnimateStyle animateSytle = ViewAnimateNone;
    
    switch (btn.tag) {
        case 0:
        {
            animateSytle = ViewAnimateNone;
        }
            break;
        case 1:
        {
            animateSytle = ViewAnimateFromTop;
        }
            break;
        case 2:
        {
            animateSytle = ViewAnimateFromLeft;
        }
            break;
        case 3:
        {
            animateSytle = ViewAnimateFromBottom;
        }
            break;
        case 4:
        {
            animateSytle = ViewAnimateFromRight;
        }
            break;
        case 5:
        {
            animateSytle = ViewAnimateScale;
        }
            break;
            
        default:
            break;
    }
    
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 15 * 2, 250)];
    
    alertView.backgroundColor = [UIColor whiteColor];
    
    alertView.layer.cornerRadius = 8;
    
    alertView.layer.masksToBounds = YES;
    
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:alertView.bounds];
    alertLabel.center = alertView.center;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    
    alertLabel.text = @"这是自定义的弹出view";
    
    alertLabel.font = [UIFont systemFontOfSize:20];
    
    alertLabel.numberOfLines = 0;
    
    [alertView addSubview:alertLabel];
    
    
    FrankAlertActionSheetView * alert = [[FrankAlertActionSheetView alloc]initCustomView:alertView animateStyle:animateSytle position:self.position];
    
    [alert show];
    
}

/**
 系统提示框
 */
- (IBAction)SystemAlertActionSheetClick:(UIButton *)btn{
    
    
    
    UIAlertControllerStyle alertSytle = UIAlertControllerStyleAlert;
    
    switch (btn.tag) {
        case 6:
        {
            alertSytle = UIAlertControllerStyleAlert;
        }
            break;
        case 7:
        {
            alertSytle = UIAlertControllerStyleActionSheet;
        }
            break;
            
        default:
            break;
    }
    
#pragma mark ----- 调用系统 Alert 、 ActionSheet
    FrankAlertActionSheetView * alert = [[FrankAlertActionSheetView alloc] initSystemAlertActionWithStyle:alertSytle title:@"标题" message:@"这是信息描述内容，这是信息描述内容，这是信息描述内容，这是信息描述内容，这是信息描述内容，这是信息描述内容，这是信息描述内容，这是信息描述内容，这是信息描述内容" completeBlock:^(NSString *indexString, NSInteger buttonIndex) {
        
        NSLog(@"------- %ld",(long)buttonIndex);
        
    } cancelButtonTitle:@"取消" otherButtonTitles:@"000",@"111",@"222",@"333", nil];
    
    // 自定义样式颜色、字号大小
    alert.messageFont = 14;
    alert.titleFont = 20;
    alert.titleColor = [UIColor redColor];
    alert.messageColor = [UIColor greenColor];
    alert.buttonTitleColor = [UIColor blackColor];
    
    [alert show];
    

}

/**
 自定义ActionSheet
 */
- (IBAction)CustomActionSheetClick:(UIButton *)btn{
    
#pragma mark ----- 调用系统 Alert 、 ActionSheet
    FrankAlertActionSheetView * alert = [[FrankAlertActionSheetView alloc]initCustomActionSheetWithTitle:@"标题" message:@"这是信息描述内容，这是信息描述内容，这是信息描述内容，这是信息描述内容，这是信息描述内容，这是信息描述内容，这是信息描述内容，这是信息描述内容，这是信息描述内容" completeBlock:^(NSString *indexString, NSInteger buttonIndex) {
        
        NSLog(@"------- %ld",(long)buttonIndex);
        
    } cancelButtonTitle:@"取消" otherButtonTitles:@"000",@"111",@"222",@"333", nil];
    alert.messageFont = 14;
    alert.titleColor = [UIColor blackColor];
    alert.messageColor = [UIColor redColor];
    alert.buttonTitleColor = [UIColor greenColor];
    [alert show];
}




@end
