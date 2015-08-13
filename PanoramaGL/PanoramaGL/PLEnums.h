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
#pragma mark enums definitions

typedef enum
{
    PLPanoramaTypeUnknow = 0,
	PLPanoramaTypeCubic,
	PLPanoramaTypeSpherical,
    PLPanoramaTypeSpherical2,
    PLPanoramaTypeCylindrical,
} PLPanoramaType;

typedef enum
{
    PLSensorTypeUnknow = 0,
	PLSensorTypeGyroscope,
	PLSensorTypeMagnetometer,
} PLSensorType;

typedef enum
{
    PLOpenGLVersionUnknow = 0,
    PLOpenGLVersion1_0,
	PLOpenGLVersion1_1,
	PLOpenGLVersion2_0,
} PLOpenGLVersion;

typedef enum
{
	PLTouchEventTypeBegan = 0,
	PLTouchEventTypeMoved,
	PLTouchEventTypeEnded
} PLTouchEventType;

typedef enum
{
	PLCubeFaceOrientationFront  = 0,
	PLCubeFaceOrientationBack   = 1,
	PLCubeFaceOrientationLeft   = 2,
	PLCubeFaceOrientationRight  = 3,
	PLCubeFaceOrientationTop    = 4,
	PLCubeFaceOrientationBottom = 5,
    PLCubeFaceOrientationUp     = 4,
	PLCubeFaceOrientationDown   = 5,
} PLCubeFaceOrientation;

typedef enum
{
	PLSpherical2FaceOrientationLeft = 0,
	PLSpherical2FaceOrientationRight,
    PLSpherical2FaceOrientationFront,
    PLSpherical2FaceOrientationBack,
} PLSpherical2FaceOrientation;

typedef enum
{
	PLTransitionTypeFadeIn = 0,
	PLTransitionTypeFadeOut
} PLTransitionType;

typedef enum
{
	PLTouchStatusNone = 0,
	PLTouchStatusMoved,
	PLTouchStatusEnded,
    PLTouchStatusBegan,
	PLTouchStatusFirstSingleTapCount,
	PLTouchStatusSingleTapCount,
	PLTouchStatusDoubleTapCount
} PLTouchStatus;

typedef enum 
{
	PLSceneElementTypeNone = 0,
	PLSceneElementTypePanorama,
	PLSceneElementTypeHotspot,
	PLSceneElementTypeObject
} PLSceneElementType;

typedef enum 
{
	PLHotspotTouchStatusOut = 0,
	PLHotspotTouchStatusOver,
	PLHotspotTouchStatusMove,
	PLHotspotTouchDown
} PLHotspotTouchStatus;

typedef enum
{
	PLTextureColorFormatUnknown =	0,
	PLTextureColorFormatRGBA8888 =	1,
	PLTextureColorFormatRGB565 =	2,
	PLTextureColorFormatRGBA4444 =	3
} PLTextureColorFormat;