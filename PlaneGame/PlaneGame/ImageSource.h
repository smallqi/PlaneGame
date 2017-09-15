//
//  ImageSource.h
//  PlaneGame
//
//  Created by BlackApple on 2017/9/13.
//  Copyright © 2017年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

//图片种类
typedef enum ImageType {
    Bg = 0,
    Bullet1,
    Bullet2,
    Gift1,
    Gift2
}ImageType;
//动画种类
typedef enum ImagesType {
    HeroFly = 0,
    HeroHit,
    HeroDead,
    
    Enemy1_Fly = 3,
    Enemy1_Hit,
    Enemy1_Dead,
    
    Enemy2_Fly = 6,
    Enemy2_Hit,
    Enemy2_Dead,
    
    Enemy3_Fly = 9,
    Enemy3_Hit,
    Enemy3_Dead,
}ImagesType;

@interface ImageSource : NSObject

//实例方法
+(ImageSource*)shareImageSource;
//获得图片
-(UIImage*)getImageWithImageType:(ImageType)imageType;
//获得图片数组
-(NSMutableArray*)getImagesWithImagesType:(ImagesType)imageType;

@end
