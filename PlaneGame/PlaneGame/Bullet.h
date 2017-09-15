//
//  Bullet.h
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bullet : UIImageView

@property int power;
@property int speed;
@property CGSize collider;
@property(readonly) CGPoint LUposition;
@property(readonly) CGSize size; //图片大小

//设置位置
-(void)setPosition:(CGPoint)position;
//移动
-(void)moveWithDirect:(CGPoint)point;

@end
