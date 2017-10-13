//
//  HTAdjustView.m
//  HTAdjustViewDemo
//
//  Created by chenghong on 2017/8/18.
//  Copyright © 2017年 HT. All rights reserved.
//

#import "HTAdjustView.h"

@interface HTAdjustView ()

@property (nonatomic, strong) UIImageView *adjustView;  // 调节按钮
@property (nonatomic, strong) UIImageView *adjustBackView;  // 背景视图
@property (nonatomic, assign) BOOL prepareToMove;  // 调节按钮是否可以移动
@property (nonatomic, strong) UIButton *valueBtn;  // 当前值
@property (nonatomic, strong) UIButton *nameBtn;  // 名称
@property (nonatomic, copy) NSString *unit;  // 单位
@property (nonatomic, assign) CGFloat maxValue;  // 上限值
@property (nonatomic, assign) CGFloat minValue;  // 下限值
@property (nonatomic, assign) CGFloat maxValueY;  // 最大值位置的y坐标
@property (nonatomic, assign) CGFloat minValueY;  // 最小值位置的y坐标
@property (nonatomic, assign) CGFloat displayValue;  // 当前用于展示的值
@property (nonatomic, strong) UIImageView *adjustProgressView;  // 进度条
@property (nonatomic, strong) UIImageView *scaleView;  // 刻度视图

@end

@implementation HTAdjustView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化视图
        [self loadViews];
    }
    
    return self;
}

// 初始化视图
- (void)loadViews {
    self.valueBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.05, 0, self.frame.size.width * 0.9, self.frame.size.height * 0.1)];
    [self.valueBtn setTitle:@"N/A" forState:UIControlStateNormal];
    [self.valueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.valueBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.valueBtn setBackgroundImage:[UIImage imageNamed:@"valueBg"] forState:UIControlStateNormal];
    self.valueBtn.enabled = NO;
    [self addSubview:self.valueBtn];
    
    self.adjustBackView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.35, self.frame.size.height * 0.15, self.frame.size.width * 0.1, self.frame.size.height * 0.7)];
    self.adjustBackView.image = [UIImage imageNamed:@"adjustBg"];
    [self addSubview:self.adjustBackView];
    
    self.scaleView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.55, self.frame.size.height * 0.15, self.frame.size.width * 0.1, self.frame.size.height * 0.7)];
    self.scaleView.image = [UIImage imageNamed:@"scaleBg"];
    [self addSubview:self.scaleView];
    
    self.adjustProgressView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.adjustBackView.frame.size.width, self.adjustBackView.frame.size.height)];
    self.adjustProgressView.image = [UIImage imageNamed:@"progressBg"];
    [self.adjustBackView addSubview:self.adjustProgressView];
    self.adjustBackView.layer.masksToBounds = YES;
    
    self.adjustView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.2, self.frame.size.width * 0.2)];
    [self.adjustView setCenter:self.adjustBackView.center];
    self.adjustView.image = [UIImage imageNamed:@"adjustBtn"];
    [self addSubview:self.adjustView];
    
    self.nameBtn = [[UIButton alloc] initWithFrame:CGRectMake(1, self.frame.size.height * 0.9, self.frame.size.width - 2, self.frame.size.height * 0.1 - 1)];
    [self.nameBtn setBackgroundImage:[UIImage imageNamed:@"nameBg"] forState:UIControlStateNormal];
    [self.nameBtn setTitle:@"N/A" forState:UIControlStateNormal];
    [self.nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nameBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.nameBtn.enabled = NO;
    [self addSubview:self.nameBtn];
    
    self.minValueY = self.adjustBackView.frame.origin.y + self.adjustBackView.frame.size.height - self.adjustView.frame.size.height/2;
    self.maxValueY = self.adjustBackView.frame.origin.y + self.adjustView.frame.size.height/2;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    // 触摸位置在有效范围内，则可以移动调节按钮
    if (touchPoint.x <= self.adjustView.frame.origin.x + self.adjustView.frame.size.width + 10 && touchPoint.x >= self.adjustView.frame.origin.x - 10 &&  touchPoint.y <= self.adjustView.frame.origin.y + self.adjustView.frame.size.height + 10 && touchPoint.y >= self.adjustView.frame.origin.y - 10) {
        
        self.prepareToMove = YES;
    }
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.prepareToMove == YES) {
        // 移动调节按钮
        CGPoint touchLocation = [[touches anyObject] locationInView:self];
        CGPoint preTouchLocation = [[touches anyObject] previousLocationInView:self];
        CGFloat moveDistance = touchLocation.y - preTouchLocation.y;
        
        CGFloat totalValueHeight = self.minValueY - self.maxValueY;
        
        CGFloat currentCenterY = self.adjustView.center.y + moveDistance;
        
        if (currentCenterY < self.maxValueY) {
            currentCenterY = self.maxValueY;
        } else if (currentCenterY > self.minValueY) {
            currentCenterY = self.minValueY;
        }
        
        [self.adjustView setCenter:CGPointMake(self.adjustView.center.x, currentCenterY)];
        // 进度条跟随调节按钮变化
        self.adjustProgressView.frame = CGRectMake(0, currentCenterY - self.adjustBackView.frame.origin.y, self.adjustProgressView.frame.size.width, self.adjustProgressView.frame.size.height);
        
        // 根据上下限计算展示值
        CGFloat ratio = (self.minValueY - currentCenterY)/totalValueHeight;
        self.displayValue = ratio * (self.maxValue - self.minValue) + self.minValue;
        NSString *valueStr = [NSString stringWithFormat:@"%.1f%@", self.displayValue, self.unit];
        [self.valueBtn setTitle:valueStr forState:UIControlStateNormal];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.prepareToMove = NO;
}

// 设置名称、展示值、单位、上限值、下限值
- (void)setName:(NSString *)name
          value:(CGFloat)value
           unit:(NSString *)unit
       maxValue:(CGFloat)maxValue
       minValue:(CGFloat)minValue {
    [self.nameBtn setTitle:name forState:UIControlStateNormal];
    self.displayValue = value;
    [self.valueBtn setTitle:[NSString stringWithFormat:@"%.1f%@", value, unit] forState:UIControlStateNormal];
    self.unit = unit;
    self.maxValue = maxValue;
    self.minValue = minValue;
    
    CGFloat ratio = (value - self.minValue)/(self.maxValue - self.minValue);
    CGFloat currentCenterY = self.minValueY - (self.minValueY - self.maxValueY) * ratio;
    [self.adjustView setCenter:CGPointMake(self.adjustView.center.x, currentCenterY)];
    
    self.adjustProgressView.frame = CGRectMake(0, currentCenterY - self.adjustBackView.frame.origin.y, self.adjustProgressView.frame.size.width, self.adjustProgressView.frame.size.height);
}

@end
