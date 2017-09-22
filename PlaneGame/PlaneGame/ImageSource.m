//
//  ImageSource.m
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import "ImageSource.h"

@interface ImageSource()

@property(strong, nonatomic)UIImage* bg;
@property(strong, nonatomic)UIImage* bullet1;
@property(strong, nonatomic)UIImage* bullet2;
@property(strong, nonatomic)UIImage* bullet3;
@property(strong, nonatomic)UIImage* gift1;
@property(strong, nonatomic)UIImage* gift2;

@property(strong, nonatomic)NSMutableArray* heroFly;
@property(strong, nonatomic)NSMutableArray* heroHit;
@property(strong, nonatomic)NSMutableArray* heroDead;

@property(strong, nonatomic)NSMutableArray* enemy1_fly;
@property(strong, nonatomic)NSMutableArray* enemy1_hit;
@property(strong, nonatomic)NSMutableArray* enemy1_Dead;

@property(strong, nonatomic)NSMutableArray* enemy2_fly;
@property(strong, nonatomic)NSMutableArray* enemy2_hit;
@property(strong, nonatomic)NSMutableArray* enemy2_Dead;

@property(strong, nonatomic)NSMutableArray* enemy3_fly;
@property(strong, nonatomic)NSMutableArray* enemy3_hit;
@property(strong, nonatomic)NSMutableArray* enemy3_Dead;

@end

@implementation ImageSource

-(id)init {
    NSAssert(NO, @"使用单例方法");
    return nil;
}

//单例模式
+(ImageSource*)shareImageSource {
    static ImageSource* share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ImageSource alloc]initSource];
    });
    return share;
}

//初始化加载图片
-(id)initSource {
    self = [super init];
    if(self) {
        self.bg = [UIImage imageNamed:@"background_2.png"];
        self.bullet1 = [UIImage imageNamed:@"bullet1.png"];
        self.bullet2 = [UIImage imageNamed:@"bullet2.png"];
        self.bullet3 = [UIImage imageNamed:@"bullet3.png"];
        self.gift1 = [UIImage imageNamed:@"enemy4_fly_1.png"];
        self.gift2 = [UIImage imageNamed:@"enemy5_fly_1.png"];
        
        self.heroFly = [self getImagesWithName:@"hero_fly" WithLen:2];
        self.heroHit = [self getImagesWithName:@"hero_blowup" WithLen:2];
        self.heroDead = [self getImagesWithName:@"hero_blowup" WithLen:4];
        
        self.enemy1_fly = [self getImagesWithName:@"enemy1_fly" WithLen:1];
        self.enemy1_hit = [self getImagesWithName:@"enemy1_blowup" WithLen:2];
        self.enemy1_Dead = [self getImagesWithName:@"enemy1_blowup" WithLen:4];
        
        self.enemy2_fly = [self getImagesWithName:@"enemy3_fly" WithLen:1];
        self.enemy2_hit = [self getImagesWithName:@"enemy3_blowup" WithLen:2];
        self.enemy2_Dead = [self getImagesWithName:@"enemy3_blowup" WithLen:4];
        
        self.enemy3_fly = [self getImagesWithName:@"enemy2_fly" WithLen:2];
        self.enemy3_hit = [self getImagesWithName:@"enemy2_blowup" WithLen:2];
        self.enemy3_Dead = [self getImagesWithName:@"enemy2_blowup" WithLen:7];
    }
    return self;
}
//获得图片数组
-(NSMutableArray*)getImagesWithName:(NSString*)name WithLen:(int)len {
    NSMutableArray* images = [[NSMutableArray alloc]init];
    for(int i=1; i<=len; i++) {
        NSString* imageName = [NSString stringWithFormat:@"%@_%d.png", name, i];
        UIImage* image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    return images;
}

//获得图片
-(UIImage*)getImageWithImageType:(ImageType)imageType {
    switch (imageType) {
        case Bg:
            return self.bg;
        case Bullet1:
            return self.bullet1;
        case Bullet2:
            return self.bullet2;
        case Bullet3:
            return self.bullet3;
        case Gift1:
            return self.gift1;
        case Gift2:
            return self.gift2;

        default:
            return nil;
    }
}
//获得图片数组
-(NSMutableArray*)getImagesWithImagesType:(ImagesType)imagesType {
    switch (imagesType) {
        case HeroFly:
            return self.heroFly;
        case HeroHit:
            return self.heroHit;
        case HeroDead:
            return self.heroDead;
        
        case Enemy1_Fly:
            return self.enemy1_fly;
        case Enemy1_Hit:
            return self.enemy1_hit;
        case Enemy1_Dead:
            return self.enemy1_Dead;
            
        case Enemy2_Fly:
            return self.enemy2_fly;
        case Enemy2_Hit:
            return self.enemy2_hit;
        case Enemy2_Dead:
            return self.enemy2_Dead;
        
        case Enemy3_Fly:
            return self.enemy3_fly;
        case Enemy3_Hit:
            return self.enemy3_hit;
        case Enemy3_Dead:
            return self.enemy3_Dead;
        
            
        default:
            return  nil;
    }
}
@end
