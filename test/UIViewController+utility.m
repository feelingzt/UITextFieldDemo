//
//  UIViewController+utility.m
//  Sfingernail
//
//  Created by Arvin on 14/11/27.
//  Copyright (c) 2014年 Arvin. All rights reserved.
//

#import "UIViewController+utility.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import "UITextField+ChangeKeyBoard.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

char* const ASSOCIATION_originY_KB = "ASSOCIATION_originY_KB";
char* const ASSOCIATION_actView_KB = "ASSOCIATION_actView_KB";
char* const ASSOCIATION_editViews_KB = "ASSOCIATION_editViews_KB";


@implementation UIViewController (utility)

#pragma mark runtime的关联对象：在分类里创造出三个成员变量originY_KB、originY_KB、editViews_KB
- (void)setOriginY_KB:(NSNumber *)originY_KB{
    [self willChangeValueForKey:[NSString stringWithCString:ASSOCIATION_originY_KB encoding:NSUTF8StringEncoding]];
    objc_setAssociatedObject(self, ASSOCIATION_originY_KB, originY_KB, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:[NSString stringWithCString:ASSOCIATION_originY_KB encoding:NSUTF8StringEncoding]];
}
- (NSNumber *)originY_KB{
    return objc_getAssociatedObject(self, ASSOCIATION_originY_KB);
}



- (void)setActView_KB:(UIView *)actView_KB{
    [self willChangeValueForKey:[NSString stringWithCString:ASSOCIATION_actView_KB encoding:NSUTF8StringEncoding]];
    objc_setAssociatedObject(self, ASSOCIATION_actView_KB, actView_KB, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:[NSString stringWithCString:ASSOCIATION_actView_KB encoding:NSUTF8StringEncoding]];
}
- (UIView *)actView_KB{
    return objc_getAssociatedObject(self, ASSOCIATION_actView_KB);
}


- (void)setEditViews_KB:(NSArray *)editViews_KB{
    [self willChangeValueForKey:[NSString stringWithCString:ASSOCIATION_editViews_KB encoding:NSUTF8StringEncoding]];
    objc_setAssociatedObject(self, ASSOCIATION_editViews_KB, editViews_KB, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:[NSString stringWithCString:ASSOCIATION_editViews_KB encoding:NSUTF8StringEncoding]];
}
- (NSArray *)editViews_KB{
    return objc_getAssociatedObject(self, ASSOCIATION_editViews_KB);
}


#pragma mark 相关方法
//-(void)textFiledAddDoneBtn:(NSArray*)ary{
//    for (UITextField *tem in ary) {
//        [tem addDoneButtonAboveKeyBoard];
//    }
//}

- (void)resignKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.actView_KB = nil;
    self.originY_KB = nil;
    self.editViews_KB = nil;
}

//注册键盘出现和消失事件
- (void)registerKeyboardNotifications:(UIView *)actView EditViews:(NSArray *)editViews{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapBackground_KB:)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    self.view.userInteractionEnabled = YES;
    
    if (actView) {
        self.actView_KB = actView;
    } else {
        self.actView_KB = self.view;
    }
    if (editViews) {
        self.editViews_KB = editViews;
    }
}

//tapBackground_KB:
- (void)tapBackground_KB:(UIGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

//keyboardWillShown:
- (void)keyboardWillShown:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [value CGRectValue].size.height;
    NSNumber *seconds = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [self keyBoardShow:keyboardHeight interval:[seconds floatValue]];
}

//keyboardWillBeHidden:
- (void)keyboardWillBeHidden:(NSNotification*)notification{
    NSNumber *seconds = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [self keyBoardHide:[seconds floatValue]];
}


- (void)keyBoardShow:(CGFloat)keyboardHeight interval:(CGFloat)duration
{
    UIView *editView = nil;
    for (UIView *view in self.editViews_KB) {
        if (view.isFirstResponder) {
            editView = view;
            break;
        }
    }
    if (!editView) {
        //存在多个监听者时，没找到好办法区分不同监听者，简单返回算了
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect dstFrame = [editView convertRect:editView.bounds toView:window];
    CGFloat deltaY = window.frame.size.height - keyboardHeight - CGRectGetMaxY(dstFrame);
    if (deltaY < 0) {
        self.originY_KB = [NSNumber numberWithFloat:CGRectGetMinY(self.actView_KB.frame)];
        if ([self.actView_KB isKindOfClass:[UIScrollView class]]) {
            UIScrollView *tempScr = (UIScrollView *)self.actView_KB;
            CGPoint point = tempScr.contentOffset;
            point.y -= deltaY;
            [tempScr setContentOffset:point animated:YES];
        }else {
            [UIView animateWithDuration:duration animations:^{
                CGRect frame = self.actView_KB.frame;
                frame.origin.y += deltaY;
                self.actView_KB.frame = frame;
            }completion:nil];
        }
        
    }
}


- (void)keyBoardHide:(CGFloat)duration
{
    if (self.originY_KB) {
        [UIView animateWithDuration:duration animations:^{
            if ([self.actView_KB isKindOfClass:[UIScrollView class]]) {
                UIScrollView *tempScr = (UIScrollView *)self.actView_KB;
                [tempScr setContentOffset:CGPointMake(0, 0) animated:YES];
            }else {
                //CGRect frame = self.actView_KB.frame;
                //frame.origin.y = self.originY_KB.floatValue;
                //self.actView_KB.frame = frame;
                
                //在部分scrollview上的view内的txtfield又问题
                if (self.navigationController.navigationBar.hidden==YES) {
                    self.actView_KB.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }else{
                    self.actView_KB.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
                }
            }
        }completion:^(BOOL finished) {
            self.originY_KB = nil;
        }];
    }
}


@end
