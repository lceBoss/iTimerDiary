//
//  LCEDiary.h
//  iTimerDiary
//
//  Created by tarena on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCEDiary : NSObject

@property (nonatomic, strong) NSMutableArray *diaryArray;
@property (nonatomic, strong) NSMutableDictionary *diaryDic;
@property (nonatomic, strong) NSString *soundFilePath;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSString *paper_icon;
@property (nonatomic, strong) NSString *kind_icon;
@property (nonatomic, strong) NSString *weather_icon;
@property (nonatomic, strong) NSString *date;

@end
