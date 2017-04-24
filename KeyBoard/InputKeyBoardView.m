//
//  InputKeyBoardView.m
//  KeyBoard
//
//  Created by 魏唯隆 on 2017/4/21.
//  Copyright © 2017年 魏唯隆. All rights reserved.
//

#import "InputKeyBoardView.h"

#define KSWidth [UIScreen mainScreen].bounds.size.width
#define KSHight [UIScreen mainScreen].bounds.size.height

#define KHorizontalCount 10 // 水平

@implementation InputKeyBoardView
{
    NSArray *_data;

    int _verticalCount;
    
    NSMutableArray *_drawRects;     // 绘制按钮对应CGRect
    
    ClickKeyBoard _clickKeyBoard;   // 点击键盘block
    ClickDelete _clickDelete;   // 点击键盘block
    
//    UIView *_toolView;      // 工具条视图
}

- (instancetype)initWithFrame:(CGRect)frame withClickKeyBoard:(ClickKeyBoard)clickKeyBoard withDelete:(ClickDelete)clickDelete {
    self = [super initWithFrame:frame];
    if(self){
//        _data = data;
        _clickKeyBoard = clickKeyBoard;
        _clickDelete = clickDelete;
        
        [self _initView];
    }
    return self;
}

- (void)_initView {
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    
    _drawRects = @[].mutableCopy;
    
    NSArray *provinces = @[@"京",@"津",@"沪",@"冀",@"豫",@"云",@"辽",@"黑",@"湘",@"皖",
                           @"鲁",@"新",@"苏",@"浙",@"赣",@"鄂",@"桂",@"甘",@"晋",@"蒙",
                           @"陕",@"吉",@"闽",@"贵",@"粤",@"川",@"青",@"藏",@"琼",@"宁",
                           @"渝",@"森",@"统",@"军",@"空",@"海",@"北",@"沈",@"兰",@"济",
                           @"确认",@"ABC",@"南",@"广",@"成",@"使",@"领",@"警",@"删除",];
    _data = provinces;
}

#pragma mark 绘制
- (void)drawRect:(CGRect)rect {
    _verticalCount = (int)_data.count/KHorizontalCount;
    if(_data.count%KHorizontalCount > 0){
        _verticalCount += 1;
    }

    CGFloat itemWidth = rect.size.width / KHorizontalCount;
    CGFloat itemHeight = rect.size.height / _verticalCount;
    
    int index = 0;
    for(int i=0; i<_verticalCount; i++){
        for(float n=0; n<KHorizontalCount; n++){
            CGRect frame = CGRectMake(itemWidth * n, itemHeight * i, itemWidth, itemHeight);
            UIImage *image = [UIImage imageNamed:@"keyboard02"];
            if(index < _data.count){
                NSString *chart = _data[index];
                if(chart.length == 2){
                    frame = CGRectMake(frame.origin.x, frame.origin.y, itemWidth + itemWidth/2, itemHeight);
                    n += 0.5;
                }
                [self drawImage:image withRect:frame withText:chart];
                [_drawRects addObject:[NSValue valueWithCGRect:frame]];
                index ++;
            }else {
                [self drawImage:image withRect:frame withText:@""];
            }
        }
    }

}
- (void)drawImage:(UIImage *)image withRect:(CGRect)rect withText:(NSString *)text {
    CGRect keyBoardRect = CGRectMake(rect.origin.x + 2, rect.origin.y + 2, rect.size.width - 4, rect.size.height - 4);
    
    CGSize imageSize = CGSizeMake(rect.size.width, rect.size.height);
    if(text == nil || text.length <= 0){
        return;
    }
    [image drawInRect:keyBoardRect];
    UIGraphicsBeginImageContext(imageSize);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentCenter;
    UIFont *font;
    CGFloat itemWidth;
    if(text.length > 1){
        itemWidth = KSWidth/KHorizontalCount;
        font = [UIFont systemFontOfSize:15 weight:0.5];
    }else {
        itemWidth = 24;
        font = [UIFont systemFontOfSize:16];
    }
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : style,
                                 NSForegroundColorAttributeName : [UIColor blackColor]
                                 };
    CGFloat itemHeight = 20;
    CGRect textFrame = CGRectMake((rect.size.width - itemWidth)/2, (rect.size.height - itemHeight)/2, itemWidth, itemHeight);
    [text drawInRect:textFrame withAttributes:attributes];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [newImage drawInRect:keyBoardRect];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    
    [_drawRects enumerateObjectsUsingBlock:^(NSValue *rectValue, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(rectValue.CGRectValue, location)) {
            NSString *clickKey = _data[idx];
            if([clickKey isEqualToString:@"删除"]){
                _clickDelete();
            }else if([clickKey isEqualToString:@"确认"]){
//                _clickDelete();
            }
            else if([clickKey isEqualToString:@"ABC"]){
//                _clickDelete();
            }else {
                _clickKeyBoard(clickKey);
            }
        }
    }];
}

@end
