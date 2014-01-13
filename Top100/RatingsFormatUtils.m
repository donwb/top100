//
//  RatingsFormatUtils.m
//  Top100
//
//  Created by Don Browning on 1/12/14.
//  Copyright (c) 2014 Don Browning. All rights reserved.
//

#import "RatingsFormatUtils.h"

@implementation RatingsFormatUtils
+(NSString *)stringFromJSONDateString:(NSString *)dateString {
    
    NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *friendlyDateFormatter = [[NSDateFormatter alloc]init];
    
	[rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
	[rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    [friendlyDateFormatter setDateFormat:@"MM'-'dd'-'yyyy' at 'hh':'mm a"];
    
	// Convert the RFC 3339 date time string to an NSDate.
	NSDate *fixedDate = [rfc3339DateFormatter dateFromString:dateString];
    NSString *result = [friendlyDateFormatter stringFromDate:fixedDate];
    
	return result;
}

+ (NSString *) formatHutFloat:(float) hutValue {
    int i = (int)hutValue;
    NSString *retValue = [NSString stringWithFormat:@"%d%%", i];
    return retValue;
}

@end
