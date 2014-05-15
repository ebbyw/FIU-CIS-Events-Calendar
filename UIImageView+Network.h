//
//  UIImage+Network.h
//  Fireside
//
//  Created by Soroush Khanlou on 8/25/12.
//  Modified by Ebby Wahman on 5/11/14
//

#import <UIKit/UIKit.h>
@class EventSpeaker;

@interface UIImageView(Network)

@property (nonatomic, copy) NSURL *imageURL;

- (void) loadImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder speaker:(EventSpeaker*)speaker;

@end
