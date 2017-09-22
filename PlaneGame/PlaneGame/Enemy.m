//
//  Enemy.m
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "Enemy.h"
#import "Bullet.h"
#import "ImageSource.h"

@implementation Enemy

//fire
-(Bullet*)fireWithGameFrames:(int)gameFrames {
   
    if(gameFrames - self.myframes < [GameData shareWithLevel:1]->enemy2.fireTimeFrame)
        return nil;
    self.myframes = gameFrames;
    Bullet* bullet = [[Bullet alloc]initWithImage:[[ImageSource shareImageSource]getImageWithImageType:Bullet3]];
    //设置位置
    float x = self.LUposition.x + (self.size.width-bullet.size.width)/2;
    [bullet setPosition:CGPointMake(x, self.LUposition.y + self.size.height)];
    //设置速度力量
    bullet.power = [GameData shareWithLevel:1]->bullet3.power;
    bullet.speed = [GameData shareWithLevel:1]->bullet3.speed;
            
    return bullet;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
