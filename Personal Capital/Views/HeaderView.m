//
//  HeaderView.m
//  Personal Capital
//
//  Created by Masih Tabrizi on 5/3/18.
//  Copyright © 2018 PC. All rights reserved.
//

#import "HeaderView.h"


@implementation HeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // image view
        // TODO: width and height have to come from the rss
        imageHeight = (self.bounds.size.width * 300)/780;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, imageHeight)];
        [self addSubview:self.imageView];
        
        // title label
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(15, imageHeight, self.bounds.size.width - 30, 50)];
        self.title.font = [UIFont fontWithName:@"Helvetica-Semibold" size:18];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.numberOfLines = 1;
        [self addSubview:self.title];
        
        // description label
        self.desc = [[UILabel alloc] initWithFrame:CGRectMake(15, imageHeight + 40, self.bounds.size.width - 30, 50)];
        self.desc.numberOfLines = 2;
        [self addSubview:self.desc];
    }
    return self;
}

-(void)setRSSFeed:(RSSEntry *)feed {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:feed.image]];
    self.imageView.image = [UIImage imageWithData:imageData];
    self.title.text = feed.title;
    // using attributedText to show html
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[feed.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.desc.attributedText = attrStr;
    
    // draw border
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, imageHeight + 90, self.bounds.size.width - 30, 50)];
    tableTitle.text = @"Previous Articles";
    [self addSubview:tableTitle];
    
    // Constraints
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:imageHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    // title
    self.title.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:imageHeight + 10]];
    
//    // desc
    self.desc.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_desc attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_desc attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_desc attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:imageHeight + 50]];
}
@end
