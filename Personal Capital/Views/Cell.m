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
        
        // Constraints
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:imageHeight]];
        // imageview and contentView should always have the same width
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        
        self.title.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5.0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_title]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_title)]];
    }
    return self;
}

@end
