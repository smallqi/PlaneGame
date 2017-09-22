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
                game.gameLoopTime = 0.05;
                game.enemy1CreatNum = 5;
                game.enemy1CreatFrame = 10;
                game.enemy2CreatNum = 2;
                game.enemy2CreatFrame = 20;
                
                //主角的数据
                hero.hp = 2;
                hero.speed = 1;
                hero.fireTimeFrame = 2;
                hero.collider = CGSizeMake(60, 80);
                //敌人1的数据
                enemy1.hp = 1;
                enemy1.speed = 7;
                enemy1.minSpeed = 5;
                enemy1.maxSpeed = 12;
                enemy1.fireTimeFrame = 3600/game.gameLoopTime;
                enemy1.collider =  CGSizeMake(38, 28);
                //敌人2的数据
                enemy2.hp = 10;
                enemy2.speed = 7;
                enemy2.minSpeed = 5;
                enemy2.maxSpeed = 7;
                enemy2.fireTimeFrame = 30;
                enemy2.collider =  CGSizeMake(46, 62);
                //子弹的数据
                bullet1.power = 1;
                bullet1.speed = 20;
                bullet1.collider = CGSizeMake(6, 14);
                //敌人子弹的数据
                bullet3.power = 1;
                bullet3.speed = 20;
                bullet3.collider = CGSizeMake(6, 14);
                break;
            case 2:
                
                break;
        }
    }
    return self;
}

+(GameData*)shareWithLevel:(int)level {
    //为不同等级分别单例一个对象
    static GameData *gameData1, *gameData2;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gameData1 = [[GameData alloc]initWithLevel:1];
        gameData2 = [[GameData alloc]initWithLevel:2];
    });
    switch (level) {
        default:
        case 1:
            return gameData1;
        case 2:
            return gameData2;
    }
}

@end
