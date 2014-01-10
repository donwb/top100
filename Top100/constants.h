//
//  constants.h
//  Top100
//
//  Created by Don Browning on 12/22/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#ifndef Top100_constants_h
#define Top100_constants_h

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define ACTIVE_COLOR [UIColor colorWithRed:0.733 green:0.733 blue:0.733 alpha:1]
#define INACTIVE_COLOR [UIColor colorWithRed:0.329 green:0.329 blue:0.329 alpha:1]

#define BOLD_FONT [UIFont boldSystemFontOfSize:15]
#define NORMAL_FONT [UIFont systemFontOfSize:15]

// [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
// #067AB5
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UI_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UI_RGB(r,g,b) UI_RGBA(r, g, b, 1.0f)


#endif
