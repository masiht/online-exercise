//
//  RSSEntry.h
//  Personal Capital
//
//  Created by Masih Tabrizi on 4/30/18.
//  Copyright © 2018 PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSEntry : NSObject {
    
}

@property NSMutableString *title;
@property NSMutableString *desc;
@property NSMutableString *image;
@property NSMutableString *date;
@property NSMutableString *link;


//- (id)initWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate;

- (id)init:(NSMutableString *)title description:(NSMutableString *)desc imageUrl:(NSMutableString *)image articleUrl:(NSMutableString *)link articleDate:(NSMutableString *)date;

@end
