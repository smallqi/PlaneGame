//
//  Enemy.h
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Plane.h"

typedef enum EnemyType{
    EnemyType1 = 0,
    EnemyType2
}EnemyType;

@interface Enemy : Plane

@property EnemyType type;

@end
