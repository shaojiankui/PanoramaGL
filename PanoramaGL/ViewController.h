//
//  ViewController.h
//  PanoramaGL
//
//  Created by Jakey on 15/8/13.
//  Copyright © 2015年 Jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLView.h"
#import "PLJSONLoader.h"


//1.drawViewInternally crash
//https://code.google.com/p/panoramagl/issues/detail?id=18


@interface ViewController : UIViewController <PLViewDelegate>

@property(nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, weak) IBOutlet PLView *plView;

-(void)selectPanorama:(NSInteger)index;

-(IBAction)segmentedControlIndexChanged:(id)sender;

@end

