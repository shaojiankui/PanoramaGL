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

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

#import "PLEnums.h"
#import "PLMath.h"
#import "PLIPanorama.h"
#import "PLCamera.h"
#import "PLViewDelegate.h"
#import "PLILoader.h"

#import "PLTransition.h"
#import "PLTransitionDelegate.h"

@protocol PLIView <NSObject>

@required

#pragma mark -
#pragma mark properties

@property(nonatomic, retain) NSObject<PLIPanorama> *panorama;

@property(nonatomic, readonly, getter=getCamera) PLCamera *camera;

@property(nonatomic) NSTimeInterval animationInterval;
@property(nonatomic) NSUInteger animationFrameInterval;

@property(nonatomic) BOOL isBlocked;

@property(nonatomic) BOOL isAccelerometerEnabled, isAccelerometerLeftRightEnabled, isAccelerometerUpDownEnabled;
@property(nonatomic) float accelerometerSensitivity;
@property(nonatomic) NSTimeInterval accelerometerInterval;

@property(nonatomic) CGPoint startPoint, endPoint;
@property(nonatomic, readonly) CGPoint startFovPoint, endFovPoint;

@property(nonatomic) BOOL isScrollingEnabled;
@property(nonatomic) NSUInteger minDistanceToEnableScrolling;

@property(nonatomic) BOOL isInertiaEnabled;
@property(nonatomic) NSTimeInterval inertiaInterval;

@property(nonatomic) BOOL isResetEnabled, isShakeResetEnabled;
@property(nonatomic) uint8_t numberOfTouchesForReset;

@property(nonatomic, readonly) BOOL isValidForFov;

@property(nonatomic) float shakeThreshold;

@property(nonatomic) BOOL isDisplayLinkSupported;
@property(nonatomic, readonly) BOOL isAnimating, isSensorialRotationRunning;

@property(nonatomic, assign) NSObject<PLViewDelegate> *delegate;

@property(nonatomic, readonly, getter=getIsValidForTransition) BOOL isValidForTransition;

@property(nonatomic, readonly) PLTouchStatus touchStatus;
@property(nonatomic) BOOL isPointerVisible;

#pragma mark -
#pragma mark property methods

-(PLCamera *)getCamera;

-(void)setSceneAlpha:(float)value;

-(BOOL)getIsValidForTransition;

-(UIInterfaceOrientation)currentDeviceOrientation;

+(Class)layerClass;

#pragma mark -
#pragma mark reset methods

-(void)reset;
-(void)resetWithoutAlpha;
-(void)resetSceneAlpha;

#pragma mark -
#pragma mark draw methods

-(void)drawView;
-(void)drawViewNTimes:(NSUInteger)times;

#pragma mark -
#pragma mark render buffer methods

-(void)regenerateRenderBuffer;

#pragma mark -
#pragma mark animation methods

-(void)startAnimation;
-(void)stopAnimation;

#pragma mark -
#pragma mark sensorial rotation methods

-(void)startSensorialRotation;
-(void)stopSensorialRotation;

#pragma mark -
#pragma mark transition methods

-(BOOL)executeTransition:(PLTransition *)transition;

@optional

#pragma mark -
#pragma mark progressbar methods

-(BOOL)showProgressBar;
-(void)resetProgressBar;
-(BOOL)hideProgressBar;

#pragma mark -
#pragma mark clear methods

-(void)clear;

#pragma mark -
#pragma mark load methods

-(void)load:(NSObject<PLILoader> *)loader;

@end
