//
//  AlertController.h
//  YnybzNursingBiz
//
//  Created by Frank on 16/9/19.
//  Copyright © 2016年 Frank.HAJK. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlertAction : UIAlertAction

@property (nonatomic,strong) UIColor *textColor; /**< 按钮title字体颜色 */

@end

@interface AlertController : UIAlertController

@property (nonatomic,strong) UIColor *tintColor; /**< 统一按钮样式 不写系统默认的蓝色 */
@property (nonatomic,strong) UIColor *titleColor; /**< 标题的颜色 */
@property (nonatomic,strong) UIColor *messageColor; /**< 信息的颜色 */

@property (nonatomic,assign) CGFloat titleFont; /**< 标题字号 */
@property (nonatomic,assign) CGFloat messageFont; /**< 信息字号 */


@end
