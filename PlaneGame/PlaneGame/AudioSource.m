//
//  AudioSoure.m
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "AudioSource.h"

@implementation AudioSource
{
    //背景音乐
    AVAudioPlayer* BGPlayer;
    //射击
    SystemSoundID shootSoundID;
    //爆炸
    SystemSoundID explloreSoundID;
    //死亡
    SystemSoundID heroSoundID;
}

-(id)init {
    self = [super init];
    if(self) {
        //背景
        NSURL* bgURL = [[NSBundle mainBundle]URLForResource:@"game_music" withExtension:@"mp3"];
        BGPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:bgURL error:nil];
        BGPlayer.numberOfLoops = -1;//循环播放
        //采用系统播放音乐速度比AV块,可以重叠
        //射击
        NSURL* shootURL = [[NSBundle mainBundle]URLForResource:@"bullet" withExtension:@"mp3"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)shootURL, &shootSoundID);
        //爆炸
        NSURL* exploreURL = [[NSBundle mainBundle]URLForResource:@"enemy1_down" withExtension:@"mp3"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)exploreURL, &explloreSoundID);
        //死亡
        NSURL* heroDeadURL = [[NSBundle mainBundle]URLForResource:@"game_over" withExtension:@"mp3"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)heroDeadURL, &heroSoundID);
    }
    return self;
}

//单例模式
+(AudioSource* )share {
    static AudioSource* shareSource;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareSource = [[AudioSource alloc]init];
    });
    return shareSource;
}

//播放背景音乐
-(void)playBGMusic {
    [BGPlayer play];
}
//停止背景音乐
-(void)stopBGMusic {
    [BGPlayer stop];
}
//射击
-(void)playShootMusic {
    AudioServicesPlaySystemSound(shootSoundID);
}
/*
-(void)stopShootMusic {
    [shootPlayer stop];
}
*/
//爆炸
-(void)playExploreMusic {
    AudioServicesPlaySystemSound(explloreSoundID);
}
/*
-(void)stopExploreMusic {
    [explorePlayer stop];
}
*/
//主角死亡
-(void)playHeroDead {
    AudioServicesPlaySystemSound(heroSoundID);
}
/*
-(void)stopHeroDead {
    [heroDeadPlayer stop];
}
*/

@end
