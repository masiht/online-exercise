//
//  RSSParser.m
//  Personal Capital
//
//  Created by Masih Tabrizi on 5/1/18.
//  Copyright © 2018 PC. All rights reserved.
//

#import "RSSParser.h"
#import "RSSEntry.h"

static NSString *URL = @"https://www.personalcapital.com/blog/feed/?cat=3,891,890,68,284";

@interface RSSParser () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    
    // parser temprary variables
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *image;
    NSMutableString *description;
    NSMutableString *date;
    NSMutableString *link;
    NSString *element;
}
@end

@implementation RSSParser


/**
 this method starts parsing the xml in background thread
 */
- (void)startParsing {

    //switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        feeds = [[NSMutableArray alloc] init];
        parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:URL]];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
    });
}

#pragma mark - NSXMLParserDelegate

////////////////////////////////////////////////////////////////////////
//// LOADING RESPONSE
// a better practice is to CACHE this response if this is coming from server in case of losing connection at least we can show last time results. You may also want to cache the images after loading, a good library to help us do that is Haneke!

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    if ([element isEqualToString:@"item"]) {
        item        = [[NSMutableDictionary alloc] init];
        title       = [[NSMutableString alloc] init];
        link        = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
        date        = [[NSMutableString alloc] init];
        image       = [[NSMutableString alloc] init];
    }
    if ([element isEqualToString:@"media:content"]) {
        image = [attributeDict objectForKey:@"url"];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) { [title appendString:string]; }
    else if ([element isEqualToString:@"link"]) { [link appendString:string]; }
    else if ([element isEqualToString:@"description"]) { [description appendString:string]; }
    else if ([element isEqualToString:@"pubDate"]) { [date appendString:string]; }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [feeds addObject:[[RSSEntry alloc] init:title description:description imageUrl:image articleUrl:link articleDate:date]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    // send notification along side the feed objects
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RSSParsingDone" object:feeds];
}

@end
