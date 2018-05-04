//
//  HeaderView.h
//  Personal Capital
//
//  Created by Masih Tabrizi on 5/3/18.
//  Copyright © 2018 PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSEntry.h"

@interface HeaderView : UIView {
    CGFloat imageHeight;
}

@property (nonatomic) UILabel *title;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *desc;

-(void)setRSSFeed:(RSSEntry *)feed;

@end
