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


+ (NSString *) convertToShortNumber:(NSString *) number {
    NSString *retval;
    
    @try {
        NSNumberFormatter *f = [[NSNumberFormatter alloc]init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSString *s = [f stringFromNumber:number];
        
        NSArray *numberComponents = [s componentsSeparatedByString:@","];
        
        switch (numberComponents.count) {
            case 0:
                retval = s;
                break;
            case 2:
                retval = numberComponents[0];
                break;
            case 3:
                retval = [[numberComponents[0] stringByAppendingString:@","]
                          stringByAppendingString:numberComponents[1]];
            default:
                break;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        return retval;
    }
}

+ (NSString *) friendlyStringFromFloat:(float) floatVal {
    NSNumber *n = [NSNumber numberWithFloat:floatVal];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setMaximumFractionDigits:2];
    
    return [formatter stringFromNumber:n];
}


@end
