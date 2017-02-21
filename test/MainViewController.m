//
//  MainViewController.m
//  test
//
//  Created by uen on 17/2/21.
//  Copyright © 2017年 UEN. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+utility.h"
#import "UITextField+ChangeKeyBoard.h"

@interface MainViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray *tempArray = @[self.inputTextField,self.twoTextField];
    [self registerKeyboardNotifications:self.view EditViews:tempArray];
    for (UITextField *tempTextField in tempArray) {
        tempTextField.delegate = self;
        [tempTextField addDoneButtonAboveKeyBoard];
    }
     
}
     
#pragma mark UITextFieldDelegate
// 文本框失去first responder时执行，而点击完成也就是执行了first responder
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"点击完成，同时触发了该代理方法");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//引用计数为0的情况下，当内存回收时会调用dealloc(C++析构函数，做最后的内存清理工作)方法
- (void)dealloc {
    [self resignKeyboardNotifications];
}

@end
