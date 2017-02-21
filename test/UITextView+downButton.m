//
//  UITextView+downButton.m
//  LangSha
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "UITextView+downButton.h"

@implementation UITextView (downButton)
- (void)addDoneButtonAboveKeyBoard {
    UIToolbar* keyboardToolbar_ = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth([UIScreen mainScreen].bounds), 38.0f)];
    keyboardToolbar_.barStyle = UIBarStyleDefault;
    
    //左空格
    UIBarButtonItem *leftflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //右空格
    UIBarButtonItem *rightflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard:)];
    
    [keyboardToolbar_ setItems:[NSArray arrayWithObjects:leftflexible,doneBarItem,rightflexible, nil]];
    self.inputAccessoryView = keyboardToolbar_;
}
- (void)resignKeyboard:(UIBarButtonItem *)item {
    [self resignFirstResponder];
}



@end
