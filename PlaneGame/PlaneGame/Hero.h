//
//  Hero.h
//  PlaneGame
//
//  Created by BlackApple on 2017/9/15.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plane.h"

@interface Hero : Plane

@property(readonly)BOOL state; //是否处于无敌状态
@property int fireTimeFrame; //发射子弹的间距
@property int bulletType; //子弹类型

//发射多发子弹
-(NSMutableArray*)fireWithGameFrames:(int)gameFrames;

@end
