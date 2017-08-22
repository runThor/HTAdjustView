//
//  HTAdjustView.h
//  HTAdjustViewDemo
//
//  Created by chenghong on 2017/8/18.
//  Copyright © 2017年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTAdjustView : UIView

- (void)setName:(NSString *)name
          value:(CGFloat)value
           unit:(NSString *)unit
       maxValue:(CGFloat)maxValue
       minValue:(CGFloat)minValue;

@end
