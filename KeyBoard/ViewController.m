//
//  ViewController.m
//  KeyBoard
//
//  Created by 魏唯隆 on 2017/4/21.
//  Copyright © 2017年 魏唯隆. All rights reserved.
//

#import "ViewController.h"
#import "InputKeyBoardView.h"
#import "NumInputView.h"

#define KSWidth [UIScreen mainScreen].bounds.size.width
#define KSHight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    
    [self _createTFView];
}

- (void)_createTFView {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, KSWidth - 40, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"省";
    [self.view addSubview:textField];
    
    int verticalCount = 5;
    CGFloat kheight = KSWidth/10 + 8;
    InputKeyBoardView *keyBoardView = [[InputKeyBoardView alloc] initWithFrame:CGRectMake(0, KSHight - kheight * verticalCount, KSWidth, kheight * verticalCount) withClickKeyBoard:^(NSString *character) {
        textField.text = [NSString stringWithFormat:@"%@%@", textField.text, character];
    } withDelete:^{
        if(textField.text.length > 0){
            textField.text = [textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)];
        }
    }];
    textField.inputView = keyBoardView;
    
    
    UITextField *numTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, KSWidth - 40, 40)];
    numTextField.borderStyle = UITextBorderStyleRoundedRect;
    numTextField.placeholder = @"字母数字";
    [self.view addSubview:numTextField];
    
    NumInputView *numInputView = [[NumInputView alloc] initWithFrame:CGRectMake(0, KSHight - kheight * verticalCount, KSWidth, kheight * verticalCount) withClickKeyBoard:^(NSString *character) {
        numTextField.text = [NSString stringWithFormat:@"%@%@", numTextField.text, character];
    } withDelete:^{
        if(numTextField.text.length > 0){
            numTextField.text = [numTextField.text substringWithRange:NSMakeRange(0, numTextField.text.length - 1)];
        }
    }];
    numTextField.inputView = numInputView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
