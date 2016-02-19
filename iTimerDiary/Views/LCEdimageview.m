//
//  LCEdimageview.m
//  iTimerDiary
//
//  Created by tarena on 15/12/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LCEdimageview.h"
#import "LCEDrawImageViewController.h"
#import "LCEDrawigViewController.h"


@implementation LCEdimageview
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _move = CGPointMake(0, 0);
        _start = CGPointMake(0, 0);
        _lineWidth = 2;
        _color = [UIColor blackColor];
        _pathArray = [NSMutableArray array];
        
               
        //橡皮擦
        UIButton *clearbut = [UIButton buttonWithType:UIButtonTypeSystem];
        
        clearbut.frame = CGRectMake(self.frame.size.width-210, self.frame.size.height-110, 40, 40);
        
       // [clearbut setTitle:@"橡皮擦" forState:UIControlStateNormal];
        clearbut.backgroundColor = [UIColor clearColor];
        
        [clearbut setBackgroundImage:[UIImage imageNamed:@"select_rubber"] forState:UIControlStateNormal];
        
        [clearbut addTarget:self action:@selector(clearaction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:clearbut];
        //清屏
        UIButton *clearallbut = [UIButton buttonWithType:UIButtonTypeSystem];
        
        clearallbut.frame = CGRectMake(self.frame.size.width-140, self.frame.size.height-110, 40, 40);
        
        [clearallbut setBackgroundImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
        
        [clearallbut addTarget:self action:@selector(clearall) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:clearallbut];
        
    
        UIView *partinglineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-120, self.frame.size.width, 3)];
        
        partinglineView.backgroundColor = [UIColor lightGrayColor];
        
        [self insertSubview:partinglineView atIndex:0];
        
        UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-117, self.frame.size.width, 53)];
        
        backview.backgroundColor = [UIColor whiteColor];
        
        [self insertSubview:backview atIndex:0];
        self.frame = CGRectMake(0,64, self.frame.size.width, self.frame.size.height-64);
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawPicture:context]; //画图
}

- (void)drawPicture:(CGContextRef)context {
    
    
    for (NSArray * attribute in _pathArray) {
        //将路径添加到上下文中
        CGPathRef pathRef = (__bridge CGPathRef)(attribute[0]);
        CGContextAddPath(context, pathRef);
        //设置上下文属性
        [attribute[1] setStroke];
        CGContextSetLineWidth(context, [attribute[2] floatValue]);
        //绘制线条
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _path = CGPathCreateMutable(); //创建路径
    
    NSArray *attributeArry = @[(__bridge id)(_path),_color,[NSNumber numberWithFloat:_lineWidth]];
    
    [_pathArray addObject:attributeArry]; //路径及属性数组数组
    _start = [touch locationInView:self]; //起始点
    CGPathMoveToPoint(_path, NULL,_start.x, _start.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //    释放路径
    CGPathRelease(_path);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _move = [touch locationInView:self];
    //将点添加到路径上
    CGPathAddLineToPoint(_path, NULL, _move.x, _move.y);
    
    [self setNeedsDisplay];
    
}
-(void)clearaction{
    self.lineWidth = 8;
    self.color = [UIColor whiteColor];
}
-(void)clearall{
    [self.pathArray removeAllObjects];
    [self setNeedsDisplay];
    _lineWidth = 2;
    _color = [UIColor blackColor];
   
}

    @end
