//
//  RSSEntry.m
//  Personal Capital
//
//  Created by Masih Tabrizi on 4/30/18.
//  Copyright © 2018 PC. All rights reserved.
//

#import "RSSEntry.h"

@implementation RSSEntry


//- (id)initWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate
//{
//    if ((self = [super init])) {
//        _blogTitle = [blogTitle copy];
//        _articleTitle = [articleTitle copy];
//        _articleUrl = [articleUrl copy];
//        _articleDate = [articleDate copy];
//    }
//    return self;
//}


- (id)init:(NSMutableString *)title description:(NSMutableString *)desc imageUrl:(NSMutableString *)image articleUrl:(NSMutableString *)link articleDate:(NSMutableString *)date {
    
    if ((self = [super init])) {
        self.title = [title copy];
        self.desc  = [desc copy];
        self.image = [image copy];
        self.link  = [link copy];
        // TODO: convert string to date
        self.date  = [date copy];
    }
    
    return self;
}


@end
