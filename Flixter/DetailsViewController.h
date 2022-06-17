//
//  DetailsViewController.h
//  Flixter
//
//  Created by Emily Ito Okabe on 6/16/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

// has to be public so it can hand off info to me
@property (strong, nonatomic) NSDictionary *movieInfo;

@end

NS_ASSUME_NONNULL_END
