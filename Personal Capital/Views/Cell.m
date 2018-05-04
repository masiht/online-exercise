//
//  Cell.m
//  Personal Capital
//
//  Created by Masih Tabrizi on 5/3/18.
//  Copyright © 2018 PC. All rights reserved.
//

#import "Cell.h"

@implementation Cell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // image view
        // TODO: width and height have to come from the rss
        CGFloat imageHeight = (self.bounds.size.width * 300)/780;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, imageHeight)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];

        // title label
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(5, imageHeight, self.bounds.size.width - 10, 50)];
        [self.title setFont:[UIFont systemFontOfSize:12]];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.numberOfLines = 2;
        [self.contentView addSubview:self.title];
        
        // draw border
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return self;
}

@end
