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

#import "PLViewBase.h"
#import "PLIInitializeObject.h"

@interface PLViewBase(Protected) <PLIInitializeObject, CLLocationManagerDelegate>

#pragma mark -
#pragma mark properties

@property(nonatomic, assign, getter=animationTimer, setter=setAnimationTimer:) NSTimer *animationTimer;
@property(nonatomic, assign, getter=displayLink, setter=setDisplayLink:) id displayLink;
@property(nonatomic, readonly, getter=scene) NSObject<PLIScene> *scene;
@property(nonatomic, readonly, getter=renderer) NSObject<PLIRenderer> *renderer;

#pragma mark -
#pragma mark property methods

-(NSTimer *)animationTimer;
-(void)setAnimationTimer:(NSTimer *)timer;

-(id)displayLink;
-(void)setDisplayLink:(id)displayLink;

-(NSObject<PLIScene> *)scene;

-(NSObject<PLIRenderer> *)renderer;

//-(BOOL)setAccelerometerDelegate:(id <UIAccelerometerDelegate>)accelerometerDelegate;

-(void)startAccelerometer;

-(void)setIsValidForTransition:(BOOL)value;

#pragma mark -
#pragma mark fov methods

-(BOOL)calculateFov:(NSSet *)touches;

#pragma mark -
#pragma mark action methods

-(BOOL)executeDefaultAction:(NSSet *)touches eventType:(PLTouchEventType)type;
-(BOOL)executeResetAction:(NSSet *)touches;

#pragma mark -
#pragma mark accelerometer methods

-(void)activateAccelerometer;
-(void)deactiveAccelerometer;

#pragma mark -
#pragma mark animation methods

-(void)stopOnlyAnimation;
-(void)stopAnimationInternally;

#pragma mark -
#pragma mark inertia methods

-(void)startInertia;
-(void)stopInertia;
-(void)inertia;

#pragma mark -
#pragma mark touch methods

-(BOOL)isTouchInView:(NSSet *)touches;
-(CGPoint)getLocationOfFirstTouch:(NSSet *)touches;

#pragma mark -
#pragma mark draw methods

-(void)drawViewInternally;
-(void)drawViewInternallyNTimes:(NSUInteger)times;

#pragma mark -
#pragma mark shake methods

-(BOOL)resetWithShake:(CMAcceleration)acceleration;

@end
