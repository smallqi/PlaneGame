//
//  Control.h
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Control : UIView

@property int score;
@property int bombNum;
@property int frames;//用帧数记录游戏时间

-(void)updateScoreLabel;
-(void)updateBombLabel;
-(void)updateTimeLabel;

@end
