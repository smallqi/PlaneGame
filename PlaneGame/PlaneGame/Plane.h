//
//  Plane.h
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bullet.h"
#import "GameData.h"

@interface Plane: UIImageView

@property int myframes;  //自身的帧数管理
@property int hp;
@property int speed;
@property CGSize collider;
@property(readonly) CGPoint LUposition;
@property(readonly) CGSize size; //图片大小

-(id)initWithFlyAnima:(NSMutableArray*)flys WithHitAnima:(NSMutableArray*)hits WithDeadAnima:(NSMutableArray*)deads;

//播放动画
-(void)playFly;
-(void)playHit;
-(void)playDead;

//设置位置
-(void)setPosition:(CGPoint)position;
//开火 need override
-(Bullet*)fireWithGameFrames:(int)gameFrames;
//受到攻击
-(void)getHitWithPower:(int)power;
//是否死亡
-(BOOL)isDead;
//移动
-(void)moveWithDirect:(CGPoint)point;

@end
