//
//  ViewController.h
//  LCDrawingBoardExample
//
//  Created by 刘川 on 2018/5/9.
//  Copyright © 2018年 Alex. All rights reserved.
//


#import "LCViewController.h"
#import "LCDrawingBoard.h"

@interface LCViewController ()

@property (weak, nonatomic) IBOutlet LCDrawingBoard *drawView;

@end

@implementation LCViewController

//  设置画笔的宽度
- (IBAction)lineWidthSlider:(UISlider *)sender {
    self.drawView.drawWidth = sender.value*50;
}

//  后退
- (IBAction)backClick:(id)sender {
    [self.drawView drawBack];
}

//  橡皮
- (IBAction)eraseClick:(UIButton *)sender {
    //获取按钮文字
    NSString * btnTitle = [sender titleForState:UIControlStateNormal];
    if ([btnTitle isEqualToString:@"绘制"]) {
        [sender setTitle:@"橡皮" forState:UIControlStateNormal];
        
    }else{
        [sender setTitle:@"绘制" forState:UIControlStateNormal];
    }
    [self.drawView drawErase];
   
    
}

//  清屏
- (IBAction)clearClick:(id)sender {
    [self.drawView drawClearAll];
}

//  保存
- (IBAction)saveClick:(id)sender {
    [self.drawView saveDrawToPhoneAlbum];
}

- (IBAction)randomcolorClick:(id)sender {
    self.drawView.drawColor=[self getRandomColor];
}

//  加载
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置默认颜色
    self.drawView.drawColor = [UIColor redColor];
    //设置默认宽度
    self.drawView.drawWidth = 10;
}

//  设置线条随机颜色
-(UIColor*)getRandomColor{
    
    CGFloat r = arc4random()%256/255.0;
    CGFloat g = arc4random()%256/255.0;
    CGFloat b = arc4random()%256/255.0;
    UIColor * color = [UIColor colorWithRed:r green:g blue:b alpha:1];
    return color;
}


@end
