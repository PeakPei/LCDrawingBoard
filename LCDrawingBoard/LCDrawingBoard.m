//
//  LCDrawingBoard.m
//  Alex
//
//  Created by 刘川 on 17/1/19.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import "LCDrawingBoard.h"

@interface LCDrawingBoard ()

//  创建数组,用于记录每次画笔线条所有point
@property (strong,nonatomic) NSMutableArray * drawLines;
//  创建一个字典数组,用于记录每条线的属性值
@property (strong,nonatomic)NSMutableArray * drawAttributes;
//  是否橡皮擦
@property (assign, nonatomic,getter=isErase) BOOL erase;
//  线条宽度
@property (assign, nonatomic) CGFloat eraseWidth;

@end

@implementation LCDrawingBoard


/** 橡皮 */
-(void)drawErase{
    self.erase=!self.isErase;
}

/** 后退 */
-(void)drawBack{
    //清空数组最后一条线属性和位置
    [self.drawLines removeLastObject];
    [self.drawAttributes removeLastObject];
    [self setNeedsDisplay];
}

/** 清屏 */
-(void)drawClearAll{
    //清空数组和属性,重绘制
    [self.drawLines removeAllObjects];
    [self.drawAttributes removeAllObjects];
    [self setNeedsDisplay];
}

/** 保存到相册 */
-(void)saveDrawToPhoneAlbum{
    
    //创建一个图片上下文
    UIGraphicsBeginImageContext(self.frame.size);
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //截取当天画板的内容
    [self.layer renderInContext:ctx];
    //获取图片
    UIImage * drawImage = UIGraphicsGetImageFromCurrentImageContext();
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(drawImage, nil, nil, nil);
}


/** 初始化 */
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

/** 开始绘制 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //  获取画笔起始point
    CGPoint BeganPoint = [self getCurrentPointWith:touches];
    //  创建一个可变数组用于记录单次线条
    NSMutableArray * PointArr = [NSMutableArray array];
    //  将开始位置添加到数组中
    [PointArr addObject:[NSValue valueWithCGPoint:BeganPoint]];
    //  将每一次绘制的路径添加到大数组中
    [self.drawLines addObject:PointArr];
    //  创建一个字典,用于保存每一个线条的属性
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    //  判断是否是橡皮状态,判断线条和橡皮的宽度,颜色
    if (self.isErase) {
        dict[@"color"]=self.backgroundColor;
    }else{
        dict[@"color"]=self.drawColor;
    }
    dict[@"width"]=@(self.drawWidth);
    dict[@"erase"]=@(self.isErase);
    //  添加到属性数组中
    [self.drawAttributes addObject:dict];
    //  绘制
    [self setNeedsDisplay];
}

/** 画笔移动 */
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //  获取画笔移动point
    CGPoint movePoint = [self getCurrentPointWith:touches];
    //  将移动坐标添加到当前移动的小数组
    [[self.drawLines lastObject]addObject:[NSValue valueWithCGPoint:movePoint]];
    //  重绘
    [self setNeedsDisplay];
}

/** 绘制 */
-(void)drawRect:(CGRect)rect{

    //  获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //  先遍历大数组,用于绘制线条
    for (int i =0; i<self.drawLines.count; i++) {
        NSArray * pointArr = self.drawLines[i];
        //  获取每个线的属性
        NSDictionary * dict = self.drawAttributes[i];
        
        //  遍历每条划线的数组,获取点坐标,进行绘制
            for (int i=0; i<pointArr.count; i++) {
                CGPoint point = [pointArr[i]CGPointValue];
                //  判断是否是画笔开始则添加点
                if (i==0) {
                    CGContextMoveToPoint(ctx, point.x, point.y);
                }else{
                    //  如果不是则添加线条
                    CGContextAddLineToPoint(ctx, point.x, point.y);
                }
                CGContextSetLineWidth(ctx, [dict[@"width"]floatValue]);
                UIColor * color = dict[@"color"];
                [color set];
            }
             CGContextStrokePath(ctx);
        }
    }


/** 获取当前点击point */
-(CGPoint)getCurrentPointWith:(NSSet<UITouch *> *)touches{
    UITouch * touch = [touches anyObject];
    CGPoint currPoint = [touch locationInView:self];
    return currPoint;
}

#pragma -mark 懒加载
-(NSMutableArray *)drawLines{
    if (_drawLines == nil) {
        _drawLines = [NSMutableArray array];
    }
    return _drawLines;
}

-(NSMutableArray *)drawAttributes{
    if (_drawAttributes == nil) {
        _drawAttributes = [NSMutableArray array];
    }
    return _drawAttributes;
}

@end






