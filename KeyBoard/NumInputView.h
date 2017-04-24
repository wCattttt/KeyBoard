//
//  NumInputView.h
//  KeyBoard
//
//  Created by 魏唯隆 on 2017/4/24.
//  Copyright © 2017年 魏唯隆. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickKeyBoard)(NSString *character);
typedef void(^ClickDelete)(void);

@interface NumInputView : UIView

- (instancetype)initWithFrame:(CGRect)frame withClickKeyBoard:(ClickKeyBoard)clickKeyBoard withDelete:(ClickDelete)clickDelete;

@end
