//
//  RatingsFormatUtils.h
//  Top100
//
//  Created by Don Browning on 1/12/14.
//  Copyright (c) 2014 Don Browning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RatingsFormatUtils : NSObject
+(NSString *)stringFromJSONDateString:(NSString *) dateString;
+(NSString *) formatHutFloat:(float) hutValue;
+(NSString *)convertToShortNumber:(NSString *)number;
+(NSString *) friendlyStringFromFloat:(float)floatVal;
@end
