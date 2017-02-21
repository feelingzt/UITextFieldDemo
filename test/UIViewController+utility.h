//
//  UIViewController+utility.h
//  Sfingernail
//
//  Created by Arvin on 14/11/27.
//  Copyright (c) 2014年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (utility) <UIGestureRecognizerDelegate>

//注册键盘出现事件监听
//@param actView 键盘出现时，产生相应动画的view。传入nil时默认为self.view
//@param editViews 会调用键盘的所有控件数组。不可为nil。若某个控件调用键盘未被加入，产生异常
- (void)registerKeyboardNotifications:(UIView *)actView EditViews:(NSArray *)editViews;

//取消注册
//请务必记得调用。用于取消监听，清理动态创建的相关属性
- (void)resignKeyboardNotifications;

//添加完成按钮
//-(void)textFiledAddDoneBtn:(NSArray*)ary;


@end
