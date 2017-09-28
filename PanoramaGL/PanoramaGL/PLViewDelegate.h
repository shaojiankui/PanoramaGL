/*
 * PanoramaGL library
 * Version 0.1
 * Copyright (c) 2010 Javier Baez <javbaezga@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "PLStructs.h"
#import "PLTransition.h"
#import "PLHotspot.h"

@protocol PLIView;

@protocol PLViewDelegate

@optional

#pragma mark -
#pragma mark touch methods

-(void)view:(UIView<PLIView> *)pView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)view:(UIView<PLIView> *)pView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)view:(UIView<PLIView> *)pView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

-(BOOL)view:(UIView<PLIView> *)pView shouldBeginTouching:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)view:(UIView<PLIView> *)pView didBeginTouching:(NSSet *)touches withEvent:(UIEvent *)event;
-(BOOL)view:(UIView<PLIView> *)pView shouldTouch:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)view:(UIView<PLIView> *)pView didTouch:(NSSet *)touches withEvent:(UIEvent *)event;
-(BOOL)view:(UIView<PLIView> *)pView shouldEndTouching:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)view:(UIView<PLIView> *)pView didEndTouching:(NSSet *)touches withEvent:(UIEvent *)event;

#pragma mark -
#pragma mark accelerometer methods
//-(BOOL)view:(UIView<PLIView> *)pView shouldAccelerate:(UIAcceleration *)acceleration withAccelerometer:(UIAccelerometer *)accelerometer;
//-(void)view:(UIView<PLIView> *)pView didAccelerate:(UIAcceleration *)acceleration withAccelerometer:(UIAccelerometer *)accelerometer;

-(BOOL)view:(UIView<PLIView> *)pView shouldAccelerate:(CMAccelerometerData *)accelerometerData;
-(void)view:(UIView<PLIView> *)pView didAccelerate:(CMAccelerometerData *)accelerometerData;

#pragma mark -
#pragma mark inertia methods

-(BOOL)view:(UIView<PLIView> *)pView shouldBeginInertia:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(void)view:(UIView<PLIView> *)pView didBeginInertia:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(BOOL)view:(UIView<PLIView> *)pView shouldRunInertia:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(void)view:(UIView<PLIView> *)pView didRunInertia:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(void)view:(UIView<PLIView> *)pView didEndInertia:(CGPoint)starPoint endPoint:(CGPoint)endPoint;

#pragma mark -
#pragma mark reset methods

-(BOOL)viewShouldReset:(UIView<PLIView> *)pView;
-(void)viewDidReset:(UIView<PLIView> *)pView;

#pragma mark -
#pragma mark zooming methods

-(BOOL)viewShouldBeginZooming:(UIView<PLIView> *)pView;
-(void)view:(UIView<PLIView> *)pView didBeginZooming:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(BOOL)view:(UIView<PLIView> *)pView shouldRunZooming:(float)distance isZoomIn:(BOOL)isZoomIn isZoomOut:(BOOL)isZoomOut;
-(void)view:(UIView<PLIView> *)pView didRunZooming:(float)distance isZoomIn:(BOOL)isZoomIn isZoomOut:(BOOL)isZoomOut;
-(void)view:(UIView<PLIView> *)pView didEndZooming:(float)distance isZoomIn:(BOOL)isZoomIn isZoomOut:(BOOL)isZoomOut;

#pragma mark -
#pragma mark moving methods

-(BOOL)view:(UIView<PLIView> *)pView shouldBeginMoving:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(void)view:(UIView<PLIView> *)pView didBeginMoving:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(BOOL)view:(UIView<PLIView> *)pView shouldRunMoving:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(void)view:(UIView<PLIView> *)pView didRunMoving:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(void)view:(UIView<PLIView> *)pView didEndMoving:(CGPoint)starPoint endPoint:(CGPoint)endPoint;

#pragma mark -
#pragma mark scrolling methods

-(BOOL)view:(UIView<PLIView> *)pView shouldBeingScrolling:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(void)view:(UIView<PLIView> *)pView didBeginScrolling:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(BOOL)view:(UIView<PLIView> *)pView shouldScroll:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(void)view:(UIView<PLIView> *)pView didScroll:(CGPoint)starPoint endPoint:(CGPoint)endPoint;
-(void)view:(UIView<PLIView> *)pView didEndScrolling:(CGPoint)starPoint endPoint:(CGPoint)endPoint;

#pragma mark -
#pragma mark transition methods

-(void)view:(UIView<PLIView> *)pView didBeginTransition:(PLTransition *)transition;
-(void)view:(UIView<PLIView> *)pView didProcessTransition:(PLTransition *)transition progressPercentage:(NSUInteger)progressPercentage;
-(void)view:(UIView<PLIView> *)pView didEndTransition:(PLTransition *)transition;

#pragma mark -
#pragma mark camera methods

-(BOOL)view:(UIView<PLIView> *)pView didRotateCamera:(PLCamera *)camera rotation:(PLRotation)rotation;

#pragma mark -
#pragma mark hotspot methods

-(void)view:(UIView<PLIView> *)pView didOverHotspot:(PLHotspot *)hotspot screenPoint:(CGPoint)point scene3DPoint:(PLPosition)position;
-(void)view:(UIView<PLIView> *)pView didOutHotspot:(PLHotspot *)hotspot screenPoint:(CGPoint)point scene3DPoint:(PLPosition)position;
-(void)view:(UIView<PLIView> *)pView didClickHotspot:(PLHotspot *)hotspot screenPoint:(CGPoint)point scene3DPoint:(PLPosition)position;

@end
