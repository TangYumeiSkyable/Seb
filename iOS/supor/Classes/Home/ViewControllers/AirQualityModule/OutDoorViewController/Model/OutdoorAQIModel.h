//
//  OutdoorAQIModel.h
//  supor
//
//  Created by 刘杰 on 2018/3/26.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutdoorAQIModel : NSObject

@property (nonatomic, strong) NSString *AQIName;
@property (nonatomic, strong) NSString *AQIValue;
@property (nonatomic, strong) NSString *AQIDescription;
@property (nonatomic, assign) BOOL      isSelected;
@property (nonatomic, strong) NSString *airLevelText;
@property (nonatomic, strong) NSString *airLevelImageName;

- (NSMutableArray *)retreatmentWithDictionary:(NSDictionary *)dataDictionary;

@end



