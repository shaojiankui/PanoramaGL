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

#import "PLIView.h"

@protocol PLIRenderer;

@interface PLViewBase : UIView <PLIView, UIAccelerometerDelegate, PLTransitionDelegate> 
{
    #pragma mark -
    #pragma mark member variables
@private
	NSObject<PLIRenderer> *renderer;
	NSObject<PLIPanorama> *scene;
	
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
	
	BOOL isBlocked;
	
	CGPoint startPoint, endPoint;
	CGPoint startFovPoint, endFovPoint;
	
	BOOL isValidForFov;
	float fovDistance;
	NSUInteger fovCounter;
	
	BOOL isAccelerometerEnabled, isAccelerometerLeftRightEnabled, isAccelerometerUpDownEnabled;
	float accelerometerSensitivity;
	NSTimeInterval accelerometerInterval;
	
	BOOL isScrollingEnabled, isValidForScrolling, isScrolling;
	NSUInteger minDistanceToEnableScrolling;
	
	BOOL isInertiaEnabled, isValidForInertia;
	NSTimer *inertiaTimer;
	NSTimeInterval inertiaInterval;
	float inertiaStepValue;
	
	BOOL isResetEnabled, isShakeResetEnabled;
	uint8_t numberOfTouchesForReset;
	
	PLShakeData shakeData;
	float shakeThreshold;
	
	BOOL isValidForTouch;
	
	NSObject<PLViewDelegate> *delegate;
	
	BOOL displayLinkSupported, isDisplayLinkSupported;
	id displayLink;
	NSUInteger animationFrameInterval;
	BOOL isAccelerometerActivated;
	BOOL isAnimating;
    
    CMMotionManager *motionManager;
    NSTimer *motionTimer;
    CLLocationManager *locationManager;
    int lastAccelerometerPitch;
    float accelerometerPitch;
    float firstMagneticHeading, magneticHeading;
    PLSensorType sensorType;
    BOOL isSensorialRotationRunning;
	
	BOOL isValidForTransition;
	NSString * isValidForTransitionString;
	PLTransition *currentTransition;
	
	PLTouchStatus touchStatus;
	
	BOOL isPointerVisible;
}

@end