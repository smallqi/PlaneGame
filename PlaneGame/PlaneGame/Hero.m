//
//  Hero.m
//  PlaneGame
//
//  Created by BlackApple on 2017/9/15.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "Hero.h"
#import "ImageSource.h"
#import "GameData.h"
#import "Bullet.h"

@implementation Hero

-(id)initWithFlyAnima:(NSMutableArray *)flys WithHitAnima:(NSMutableArray *)hits WithDeadAnima:(NSMutableArray *)deads {
    self = [super initWithFlyAnima:flys WithHitAnima:hits WithDeadAnima:deads];
    if(self) {
        _state = false;
        self.fireTimeFrame = 20;
        _bulletType = 1;
        
    }
    return self;
}
//受到攻击
-(void)getHitWithPower:(int)power{
    //如果无敌，不变
    if(self.state)
        return;
    [super getHitWithPower:power];
}

//fire
-(Bullet*)fire {
    
    switch (_bulletType) {
        default:
        case 1:
        {
            Bullet* bullet = [[Bullet alloc]initWithImage:[[ImageSource shareImageSource]getImageWithImageType:Bullet1]];
            //设置位置
            float x = self.LUposition.x + (self.size.width-bullet.size.width)/2;
            [bullet setPosition:CGPointMake(x, self.LUposition.y)];
            //设置速度力量
            bullet.power = [[GameData alloc]initWithLevel:1]->bullet1.power;
            bullet.speed = [[GameData alloc]initWithLevel:1]->bullet1.speed;
            
            return bullet;
        }
            break;
        case 2:
            return nil;
            break;
        
    }
}
@end
