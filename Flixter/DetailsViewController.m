//
//  DetailsViewController.m
//  Flixter
//
//  Created by Emily Ito Okabe on 6/16/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;


@end

@implementation DetailsViewController
// 5 On viewDidLoad, use the information I received to populate my views
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.backdropView = self.movieInfo[@"backdrop_path"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movieInfo[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    //cell.textLabel.text = movie[@"title"];
    
    NSData * posterImageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: fullPosterURLString]];
    self.posterView.image = [UIImage imageWithData: posterImageData];
    
    
    NSString *backdropURLString = self.movieInfo[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    //cell.textLabel.text = movie[@"title"];
    
    NSData * backdropImageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: fullBackdropURLString]];
    self.backdropView.image = [UIImage imageWithData: backdropImageData];
    
    
    //[imageData release];
    /*
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    self.posterView.image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image Name"]] ;
    [self.posterView setImageWithURL:posterURL];
    
     */
    
    
    self.titleLabel.text = self.movieInfo[@"title"];
    self.summaryLabel.text = self.movieInfo[@"overview"];
    
    /*
     NSDictionary *movieInfo;
     
     
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    //[[UITableViewCell alloc] init];   // create new UITableViewCell
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    //cell.textLabel.text = movie[@"title"];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
     */
    
    // @"backdrop_path"
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
