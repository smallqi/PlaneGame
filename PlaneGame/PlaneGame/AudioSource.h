//
//  AudioSource.h
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioSource : NSObject
//单例模式
+(AudioSource* )share;

//播放背景音乐
-(void)playBGMusic;
//停止背景音乐
-(void)stopBGMusic;
//射击
-(void)playShootMusic;
//-(void)stopShootMusic;
//爆炸
-(void)playExploreMusic;
//-(void)stopExploreMusic;
//主角死亡
-(void)playHeroDead;
//-(void)stopHeroDead;

@end
