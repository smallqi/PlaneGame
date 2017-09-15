//
//  GameData.m
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "GameData.h"

@implementation GameData

-(id)initWithLevel:(int)level {
    self = [super init];
    if(self) {
        switch (level) {
            default:
            case 1:
                //游戏数据
                game.bgSpeed = 5;
                game.gameLoopTime = 0.1;
                game.maxFrame = 1000;
                game.enemyCreatNum = 4;
                game.enemyCreatFrame = 10;
                //主角的数据
                hero.hp = 2;
                hero.speed = 1;
                hero.fireTimeFrame = 2;
                hero.collider = CGSizeMake(60, 80);
                //敌人1的数据
                enemy1.hp = 1;
                enemy1.speed = 7;
                enemy1.fireTimeFrame = 1001;
                enemy1.collider =  CGSizeMake(38, 28);
                //子弹的数据
                bullet1.power = 1;
                bullet1.speed = 20;
                bullet1.collider = CGSizeMake(6, 14);
                break;
            case 2:
                
                break;
        }
    }
    return self;
}
@end
