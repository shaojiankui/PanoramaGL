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

#pragma mark -
#pragma mark utility consts

#define kPI				3.14159265358979323846f
#define kFloatMinValue -1000000.0f
#define kFloatMaxValue  FLT_MAX

#pragma mark -
#pragma mark object consts

#define kObjectDefaultAlpha	1.0f

#pragma mark -
#pragma mark buffer consts

#define kUseDepthBuffer 0

#pragma mark -
#pragma mark texture consts

#define kTextureMaxWidth	1024
#define kTextureMaxHeight	1024

#pragma mark -
#pragma mark cube consts

#define kCubeFrontFaceIndex		0
#define kCubeBackFaceIndex		1
#define kCubeLeftFaceIndex		2
#define kCubeRightFaceIndex		3
#define kCubeTopFaceIndex		4
#define kCubeBottomFaceIndex	5

#pragma mark -
#pragma mark sphere consts

#define kDefaultSphereDivs          30

#pragma mark -
#pragma mark hemisphere consts

#define kDefaultHemisphereDivs          20
#define kDefaultHemispherePreviewDivs   30

#pragma mark -
#pragma mark cylinder consts

#define kDefaultCylinderDivs                60
#define kDefaultCylinderHeight              3.0f
#define kDefaultCylinderHeightCalculated	NO

#pragma mark -
#pragma mark rotation consts

#define kDefaultRotateSensitivity				110.0f
#define kDefaultAnimationTimerInterval			1.0f/30.0f
#define kDefaultAnimationTimerIntervalByFrame	1.0f/30.f
#define kDefaultAnimationFrameInterval			1

#define kDefaultRotateMinRange -180.0f
#define kDefaultRotateMaxRange  180.0f

#define kDefaultYawMinRange -180.f
#define kDefaultYawMaxRange  180.f

#define kDefaultPitchMinRange -90.0f
#define kDefaultPitchMaxRange  90.0f

#pragma mark -
#pragma mark fov (field of view) consts

#define kDefaultFov -0.2f
#define kDefaultFovSensitivity -1.0f

#define kFovMinValue -1.0f
#define kFovMaxValue  1.0f

#define kDefaultFovMinValue -0.2f
#define kDefaultFovMaxValue  kFovMaxValue

#define kDefaultFovFactorMinValue 0.8f
#define kDefaultFovFactorMaxValue 1.20f

#define kFovFactorOffsetValue			1.0f
#define kFovFactorNegativeOffsetValue	(kFovFactorOffsetValue - kDefaultFovFactorMinValue)
#define kFovFactorPositiveOffsetValue	(kDefaultFovFactorMaxValue - kFovFactorOffsetValue)

#define kDefaultFOVFactorCorrectedMinValue	0.774f
#define kDefaultFOVFactorCorrectedMaxValue	1.108f

#define kFOVFactorCorrectedNegativeOffsetValue	(kFovFactorOffsetValue - kDefaultFOVFactorCorrectedMinValue)
#define kFOVFactorCorrectedPositiveOffsetValue	(kDefaultFOVFactorCorrectedMaxValue - kFovFactorOffsetValue)

#define kDefaultMinDistanceToEnableFov 8

#define kDefaultFovControlIncreaseDistance 1600.0f

#define kDefaultFovMinCounter 5

#pragma mark -
#pragma mark reset consts

#define kDefaultNumberOfTouchesForReset 4

#pragma mark -
#pragma mark inertia consts

#define kDefaultInertiaInterval 3

#pragma mark -
#pragma mark accelerometer consts

#define kDefaultAccelerometerSensitivity	7.0f
#define kDefaultAccelerometerInterval		1.0f/60.0f
#define kAccelerometerSensitivityMinValue	1.0f
#define kAccelerometerSensitivityMaxValue	10.0f
#define kAccelerometerMultiplyFactor		100.0f

#pragma mark -
#pragma mark scrolling consts

#define kDefaultMinDistanceToEnableScrolling 50

#pragma mark -
#pragma mark perspective consts

#define kPerspectiveValue	290.0f
#define kPerspectiveZNear	0.01f
#define kPerspectiveZFar	100.0f

#pragma mark -
#pragma mark scene-elements consts

#define kRatio 1.0f

#pragma mark -
#pragma mark shake consts

#define kShakeThreshold 100.0f
#define kShakeDiffTime	100

#pragma mark -
#pragma mark control consts

#define kZoomControlMinWidth			64
#define kZoomControlMinHeight			40
#define kZoomControlWidthPercentage		0.21f
#define kZoomControlHeightPercentage	0.08f

#pragma mark -
#pragma mark transition consts

#define kDefaultStepFade			0.05f

#pragma mark -
#pragma mark hotspot consts

#define kDefaultHotspotSize			0.05f
#define kDefaultHotspotAlpha		0.8f
#define kDefaultHotspotOverAlpha	1.0f