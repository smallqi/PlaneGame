//
//  Gift.h
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Gift : UIImageView

@property CGSize collider;
@property(readonly) CGPoint LUposition;
@property(readonly) CGSize size; //图片大小
@property(readonly) int giftType;

@property int stayTime; //在屏幕存在时间

//设置位置
-(void)setPosition:(CGPoint)position;

@end
