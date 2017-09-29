//
//  ViewController.m
//  PanoramaGL
//
//  Created by Jakey on 15/8/13.
//  Copyright © 2015年 Jakey. All rights reserved.
//

#import "ViewController.h"
#define kIdMin 1
#define kIdMax 1000

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.plView.delegate = self;
    [self selectPanorama:0];
    //JSON loader example (see json.data, json_s2.data and json_cubic.data)
    //[plView load:[PLJSONLoader loaderWithPath:[[NSBundle mainBundle] pathForResource:@"json_cubic" ofType:@"data"]]];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(IBAction)segmentedControlIndexChanged:(id)sender
{
    [self selectPanorama:self.segmentedControl.selectedSegmentIndex];
}

-(void)selectPanorama:(NSInteger)index
{
   PLRotation ro = PLRotationMake(0.0, 0.0, 0.0);
    
    [self.plView.camera resetCurrentC:ro Pitch:ro.pitch yaw:ro.yaw];

    
    NSObject<PLIPanorama> *panorama = nil;
    //尺寸必须符合
    //Spherical2 panorama example (supports up 4096x2048 texture)
    if(index == 0)
    {
        panorama = [PLSpherical2Panorama panorama];
        [(PLSpherical2Panorama *)panorama setImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_sphere2" ofType:@"jpg"]]];
    }

    //Spherical panorama example (supports up 2048x1024 texture)
    else if(index == 1)
    {
        panorama = [PLSphericalPanorama panorama];
        [(PLSphericalPanorama *)panorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_sphere" ofType:@"jpg"]]]];
    }
    //尺寸不必须符合，比例符合2;1即可
    else if(index == 5)
    {
        panorama = [PLSphericalRatioPanorama panorama];
	    [(PLSphericalRatioPanorama *)panorama setImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_sphere2" ofType:@"jpg"]]];

    }
    //Cubic panorama example (supports up 2048x2048 texture per face)
    else if(index == 2)
    {
        PLCubicPanorama *cubicPanorama = [PLCubicPanorama panorama];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_f" ofType:@"jpg"]]] face:PLCubeFaceOrientationFront];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_b" ofType:@"jpg"]]] face:PLCubeFaceOrientationBack];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_l" ofType:@"jpg"]]] face:PLCubeFaceOrientationLeft];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_r" ofType:@"jpg"]]] face:PLCubeFaceOrientationRight];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_u" ofType:@"jpg"]]] face:PLCubeFaceOrientationUp];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_d" ofType:@"jpg"]]] face:PLCubeFaceOrientationDown];
        panorama = cubicPanorama;
    }
    //Car
    else if(index == 4)
    {
        PLCubicPanorama *cubicPanorama = [PLCubicPanorama panorama];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"front" ofType:@"jpg"]]] face:PLCubeFaceOrientationFront];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"back" ofType:@"jpg"]]] face:PLCubeFaceOrientationBack];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"left" ofType:@"jpg"]]] face:PLCubeFaceOrientationLeft];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"right" ofType:@"jpg"]]] face:PLCubeFaceOrientationRight];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"up" ofType:@"jpg"]]] face:PLCubeFaceOrientationUp];
        [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"down" ofType:@"jpg"]]] face:PLCubeFaceOrientationDown];
        panorama = cubicPanorama;
    }

    
    
    //Cylindrical panorama example (supports up 1024x1024 texture)
    else if(index == 3)
    {
        panorama = [PLCylindricalPanorama panorama];
        ((PLCylindricalPanorama *)panorama).isHeightCalculated = NO;
        [(PLCylindricalPanorama *)panorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_sphere" ofType:@"jpg"]]]];
    }
    //Add a hotspot
    PLTexture *hotspotTexture = [PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"hotspot" ofType:@"png"]]];
    PLHotspot *hotspot = [PLHotspot hotspotWithId:(kIdMin + random() % ((kIdMax + 1) - kIdMin)) texture:hotspotTexture atv:0.0f ath:0.0f width:0.08f height:0.08f];
    [panorama addHotspot:hotspot];
    [self.plView setPanorama:panorama];
}

//Hotspot event
-(void)view:(UIView<PLIView> *)pView didClickHotspot:(PLHotspot *)hotspot screenPoint:(CGPoint)point scene3DPoint:(PLPosition)position
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hotspot" message:[NSString stringWithFormat:@"You select the hotspot with ID %zd", hotspot.identifier] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    //You can load a panorama view
    /*
     PLSpherical2Panorama *panorama = [PLSpherical2Panorama panorama];
     [panorama setImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano_sphere2" ofType:@"jpg"]]];
     [pView setPanorama:panorama];
     */
}
@end
