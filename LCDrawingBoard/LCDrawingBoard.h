//
//  LCDrawingBoard.h
//  Alex
//
//  Created by 刘川 on 17/1/19.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCDrawingBoard : UIView

//  设置绘制颜色
@property(nonatomic ,strong) UIColor * drawColor;

//  设置绘制线条宽度
@property (assign, nonatomic) CGFloat  drawWidth;

//  橡皮擦功能
-(void)drawErase;

//  回退到上一步
-(void)drawBack;

//  清屏
-(void)drawClearAll;

//  保存到相册
-(void)saveDrawToPhoneAlbum;

@end
