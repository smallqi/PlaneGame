//
//  GameData.h
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//游戏数据
typedef struct Game{
    int bgSpeed;
    float gameLoopTime;
    int enemy1CreatFrame;
    int enemy1CreatNum;
    int enemy2CreatFrame;
    int enemy2CreatNum;
    int dropGiftChance; //以10为底
    
}Game;
//飞机数据
typedef struct PlaneData{
    int hp;
    int speed;
    int minSpeed;
    int maxSpeed;
    CGSize collider;
    int fireTimeFrame;
}PlaneData;
//子弹
typedef struct BulletData{
    int power;
    int speed;
    CGSize collider;
}BulletData;

@interface GameData : NSObject
{
@public
    Game game;
    PlaneData hero;
    PlaneData enemy1;
    PlaneData enemy2;
    BulletData bullet1;
    BulletData bullet3;
}

+(GameData*)shareWithLevel:(int)level;

@end
