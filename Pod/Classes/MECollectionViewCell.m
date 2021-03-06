//
//  MECollectionViewCell.m
//  MakemojiSDK
//
//  Created by steve on 2/27/16.
//  Copyright © 2016 Makemoji. All rights reserved.
//

#import "MECollectionViewCell.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface MECollectionViewCell ()
@property (nonatomic) NSString * htmlString;
- (void)setHTMLString:(NSString *)html options:(NSDictionary*) options;
@end

@implementation MECollectionViewCell {
    NSUInteger _htmlHash; // preserved hash to avoid relayouting for same HTML
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initializer];
    }
    
    return self;
}


- (void)initializer {
    self.messageView = [[MEMessageView alloc] initWithFrame:CGRectZero];
    self.messageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.messageView];
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)cellMaxWidth:(CGFloat)width {
    return width;
}

-(CGFloat)heightWithInitialSize:(CGSize)size {
    CGSize newSize = CGSizeMake(size.width, size.height);
    return newSize.height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.superview)
    {
        return;
    }
    self.messageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
}

#pragma mark Properties

- (void)setHTMLString:(NSString *)html {
    [self setHTMLString:html options:nil];
}

- (void) setHTMLString:(NSString *)html options:(NSDictionary*) options {
    NSUInteger newHash = [html hash];
    if (newHash == _htmlHash) {
        return;
    }
    
    _htmlHash = newHash;
    self.htmlString = html;
    [self.messageView setHTMLString:html];
}

-(CGSize)suggestedFrameSizeToFitEntireStringConstraintedToWidth:(CGFloat)width {
    return [self.messageView suggestedFrameSizeToFitEntireStringConstraintedToWidth:width];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)copy:(id)sender {
    if(self.htmlString){
        NSString * htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"<p dir=\"auto\" style=\"margin-bottom:16px;font-family:'.SF UI Text';font-size:16px;\">" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"color:#ffffff;" withString:@"color:#000000;"];
        NSDictionary *dict = @{(NSString *)kUTTypeText: self.messageView.attributedString.string, (NSString *)kUTTypeHTML: htmlString};
        [[UIPasteboard generalPasteboard] setItems:@[dict]];
    } else {
        
    }
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(cut:))
        return NO;
    else if (action == @selector(copy:))
        return YES;
    else if (action == @selector(paste:))
        return NO;
    else if (action == @selector(select:) || action == @selector(selectAll:))
        return NO;
    else return [super canPerformAction:action withSender:sender];
}


@end
