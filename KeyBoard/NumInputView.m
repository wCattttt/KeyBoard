//
//  NumInputView.m
//  KeyBoard
//
//  Created by 魏唯隆 on 2017/4/24.
//  Copyright © 2017年 魏唯隆. All rights reserved.
//

#define KSWidth [UIScreen mainScreen].bounds.size.width
#define KSHight [UIScreen mainScreen].bounds.size.height

//#define KHorizontalCount 10 // 水平

#import "NumInputView.h"

@implementation NumInputView
{
    NSArray *_data;
    int _horizontalCount;
    int _verticalCount;
    
    NSMutableArray *_drawRects;     // 绘制按钮对应CGRect
    
    ClickKeyBoard _clickKeyBoard;   // 点击键盘block
    ClickDelete _clickDelete;
    
//    UIView *_toolView;      // 工具条视图
    
    int _index;
}

- (instancetype)initWithFrame:(CGRect)frame withClickKeyBoard:(ClickKeyBoard)clickKeyBoard withDelete:(ClickDelete)clickDelete{
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
    _index = 0;
    
    _horizontalCount = 10;
    
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    
    _drawRects = @[].mutableCopy;
    
    NSArray *nums = @[@"学",@"电",@"消",@"边",@"通",@"森",@"金",@"警",
                           @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",
                           @"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",
                           @"A",@"S",@"D",@"F",@"G",@"H",@"j",@"K",@"L",
                           @"确认",@"省",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@"删除",];
    _data = nums;
    
}

#pragma mark 绘制
- (void)drawRect:(CGRect)rect {
    _verticalCount = (int)_data.count/_horizontalCount;
    if(_data.count%_horizontalCount > 0){
        _verticalCount += 1;
    }
    
    CGFloat itemHeight = rect.size.height / _verticalCount;
    CGFloat itemWidth;
    for (int line=0; line<5; line++) {
        switch (line) {
            case 0:
                _horizontalCount = 8;
                itemWidth = rect.size.width / _horizontalCount;
                [self diffDraw:itemWidth withHeight:itemHeight withLine:line];
                break;
                
            case 1:
                _horizontalCount = 10;
                itemWidth = rect.size.width / _horizontalCount;
                [self diffDraw:itemWidth withHeight:itemHeight withLine:line];
                break;
                
            case 2:
                _horizontalCount = 10;
                itemWidth = rect.size.width / _horizontalCount;
                [self diffDraw:itemWidth withHeight:itemHeight withLine:line];
                break;
                
            case 3:
                _horizontalCount = 9;
                itemWidth = rect.size.width / _horizontalCount;
                [self diffDraw:itemWidth withHeight:itemHeight withLine:line];
                break;
                
            case 4:
                _horizontalCount = 10;
                itemWidth = rect.size.width / _horizontalCount;
                [self diffDraw:itemWidth withHeight:itemHeight withLine:line];
                break;
                
        }
    }
    
}

- (void)diffDraw:(CGFloat)itemWidth withHeight:(CGFloat)itemHeight withLine:(int)line {
    for (int n=0; n<_horizontalCount; n++) {
        UIImage *image = [UIImage imageNamed:@"keyboard02"];
        CGRect frame = CGRectMake(itemWidth * n, itemHeight * line, itemWidth, itemHeight);
        if(_index < _data.count){
            [self drawImage:image withRect:frame withText:_data[_index]];
            [_drawRects addObject:[NSValue valueWithCGRect:frame]];
        }
        _index ++;
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
        itemWidth = KSWidth/_horizontalCount;
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
            else if([clickKey isEqualToString:@"省"]){
                //                _clickDelete();
            }else {
                _clickKeyBoard(clickKey);
            }
        }
    }];
}

@end
