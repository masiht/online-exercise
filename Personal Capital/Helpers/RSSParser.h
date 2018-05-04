//
//  RSSParser.h
//  Personal Capital
//
//  Created by Masih Tabrizi on 5/1/18.
//  Copyright © 2018 PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSParser : NSObject <NSXMLParserDelegate>
- (void)startParsing;
@end
