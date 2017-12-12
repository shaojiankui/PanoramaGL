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

#import "PLObjectBaseProtected.h"
#import "PLJSONLoader.h"
#import "PLView.h"
#import "PLIView.h"

@interface PLJSONLoader(Private)

-(void)loadJSON:(NSString *)jsonString;
-(NSString *)getResourcePath;
-(NSString *)getFilePath:(NSString *)filename urlbase:(NSString *)urlbase;
-(PLTexture *)createTexture:(NSString *)filename urlbase:(NSString *)urlbase;
-(void)loadCubicPanoramaTexture:(NSObject<PLIPanorama> *)panorama face:(PLCubeFaceOrientation)face images:(NSDictionary *)images property:(NSString *)property urlbase:(NSString *)urlbase;
-(PLTexture *)createHotspotTexture:(NSString *)filename urlbase:(NSString *)urlbase;

@end

@implementation PLJSONLoader

#pragma mark -
#pragma mark init methods

//-(id)init
//{
//    return nil;
//}

-(id)initWithString:(NSString *)string
{
    if(self = [super init])
        [self loadJSON:string];
    return self;
}

-(id)initWithPath:(NSString *)path
{
    if(self = [super init])
    {
        NSError *error = nil;
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if(jsonString)
        {
            [self loadJSON:jsonString];
            [jsonString release];
        }
        else
            [NSException raise:@"PanoramaGL" format:@"path is incorrect"];
    }
    return self;
}

-(void)initializeValues
{
    [super initializeValues];
    hotspotTextures = [[NSMutableDictionary alloc] init];
}

+(id)loaderWithString:(NSString *)string
{
    return [[[PLJSONLoader alloc] initWithString:string] autorelease];
}

+(id)loaderWithPath:(NSString *)path
{
    return [[[PLJSONLoader alloc] initWithPath:path] autorelease];
}

#pragma mark -
#pragma mark utility methods
-(id)paseJSON:(NSString*)jsonString{
    
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error=nil;
    id jsontObject=[NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingAllowFragments
                                                     error:&error];
    if (jsontObject !=nil && error==nil) {
        if ([jsontObject isKindOfClass:[NSDictionary class]]) {
            //NSLog(@"NSDictionary JsonObject ->%@",(NSDictionary *)JsonObject);
        }
        else if ([jsontObject isKindOfClass:[NSArray class]]) {
            //NSLog(@"NSArray JsonObject ->%@",(NSArray *)JsonObject);
        }else{
            //NSLog(@"JsonObject not NSDictionary||NSArray Class");
        }
    }
    return jsontObject;
}
-(void)loadJSON:(NSString *)jsonString
{
    if(jsonString)
    {
        NSObject *jsonObject = [self paseJSON:jsonString];
        if(jsonObject && [jsonObject isKindOfClass:[NSDictionary class]])
        {
            json = (NSDictionary *)[jsonObject retain];
            return;
        }
    }
    else
        [NSException raise:@"PanoramaGL" format:@"JSON string is empty"];  
    [NSException raise:@"PanoramaGL" format:@"JSON parse failed"];    
}

-(NSString *)getResourcePath
{
    return [[NSBundle mainBundle] resourcePath];
}

-(NSString *)getFilePath:(NSString *)filename urlbase:(NSString *)urlbase
{
    BOOL isFullURL = ([filename rangeOfString:@"res://"].location != NSNotFound);
    return (isFullURL ? filename : [NSString stringWithFormat:@"%@/%@", urlbase, filename]);
}

-(PLTexture *)createTexture:(NSString *)filename urlbase:(NSString *)urlbase
{
    if(filename)
        return [PLTexture textureWithImage:[PLImage imageWithPath:[self getFilePath:filename urlbase:urlbase]]];
    return nil;
}

-(void)loadCubicPanoramaTexture:(NSObject<PLIPanorama> *)panorama face:(PLCubeFaceOrientation)face images:(NSDictionary *)images property:(NSString *)property urlbase:(NSString *)urlbase
{
    if([[images allKeys] containsObject:property])
    {
        PLTexture *texture = [self createTexture:[images objectForKey:property] urlbase:urlbase];
        if(texture)
            [(PLCubicPanorama *)panorama setTexture:texture face:face];
        else
            [NSException raise:@"PanoramaGL" format:@"images.%@ property wrong value", property];
    }
    else
        [NSException raise:@"PanoramaGL" format:@"images.%@ property not exists", property];
}

-(PLTexture *)createHotspotTexture:(NSString *)filename urlbase:(NSString *)urlbase
{
    if(filename)
    {
        BOOL isFullURL = ([filename rangeOfString:@"res://"].location != NSNotFound);
        NSString *url = (isFullURL ? filename : [NSString stringWithFormat:@"%@/%@", urlbase, filename]);
        if([[hotspotTextures allKeys] containsObject:url])
            return [hotspotTextures objectForKey:url];
        else
        {
            PLTexture *texture = [PLTexture textureWithImage:[PLImage imageWithPath:url]];
            [hotspotTextures setValue:texture forKey:url];
            return texture;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark load methods

-(void)load:(UIView<PLIView> *)view
{
    if(json)
    {
        NSString *urlbase = [json objectForKey:@"urlBase"];
        if(urlbase && [urlbase isKindOfClass:[NSString class]] && [urlbase rangeOfString:@"res://"].location != NSNotFound)
        {
            NSString *path = [urlbase stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            path = [path stringByReplacingOccurrencesOfString:@"res://" withString:@""];
            if(path && [path length] > 0)
                urlbase = [NSString stringWithFormat:@"%@/%@", [self getResourcePath], path];
            else
                urlbase = [self getResourcePath];
        }
        else
            [NSException raise:@"PanoramaGL" format:@"urlBase property not exists"];
        if(!urlbase)
            [NSException raise:@"PanoramaGL" format:@"urlBase property is wrong"];
        NSString *type = [json objectForKey:@"type"];
        NSObject<PLIPanorama> *panorama = nil;
        PLPanoramaType panoramaType = PLPanoramaTypeUnknow;
        if(type && [type isKindOfClass:[NSString class]])
        {
            
            if([type isEqualToString:@"spherical"])
            {
                panoramaType = PLPanoramaTypeSpherical;
                panorama = [[PLSphericalPanorama alloc] init];
            }
            else if([type isEqualToString:@"spherical2"])
            {
                panoramaType = PLPanoramaTypeSpherical2;
                panorama = [[PLSpherical2Panorama alloc] init];
            }
            else if([type isEqualToString:@"cubic"])
            {
                panoramaType = PLPanoramaTypeCubic;
                panorama = [[PLCubicPanorama alloc] init];
            }else if([type isEqualToString:@"ratio"])
            {
                panoramaType = PLPanoramaTypeSphericalRatio;
                panorama = [[PLSphericalRatioPanorama alloc] init];
            }
            if(!panorama)
                [NSException raise:@"PanoramaGL" format:@"Panorama type is wrong"];
        }
        else
            [NSException raise:@"PanoramaGL" format:@"type property not exists"];
        NSDictionary *images = [json objectForKey:@"images"];
        if(images && [images isKindOfClass:[NSDictionary class]])
        {
            if([[images allKeys] containsObject:@"preview"])
            {
                NSString *preview = [images objectForKey:@"preview"];
                [panorama setPreviewImage:[PLImage imageWithPath:[NSString stringWithFormat:@"%@/%@", urlbase, preview]]];
            }
            if(panoramaType == PLPanoramaTypeSpherical)
            {
                if([[images allKeys] containsObject:@"image"])
                {
                    PLTexture *imageTexture = [self createTexture:[images objectForKey:@"image"] urlbase:urlbase];
                    if(imageTexture)
                        [(PLSphericalPanorama *)panorama setTexture:imageTexture];
                    else
                        [NSException raise:@"PanoramaGL" format:@"images.image property wrong value"];
                }
                else
                    [NSException raise:@"PanoramaGL" format:@"images.image property not exists"];
            }
            else if(panoramaType == PLPanoramaTypeSpherical2)
            {
                if([[images allKeys] containsObject:@"image"])
                {
                    [(PLSpherical2Panorama *)panorama setImage:[PLImage imageWithPath:[self getFilePath:[images objectForKey:@"image"] urlbase:urlbase]]];
                }
                else
                    [NSException raise:@"PanoramaGL" format:@"images.image property not exists"];
            }
            else if(panoramaType == PLPanoramaTypeSphericalRatio)
            {
                if([[images allKeys] containsObject:@"image"])
                {
                    [(PLSphericalRatioPanorama *)panorama setImage:[PLImage imageWithPath:[self getFilePath:[images objectForKey:@"image"] urlbase:urlbase]] ifNoPowerOfTwoConvertUpDimension:NO];
                }
                else
                    [NSException raise:@"PanoramaGL" format:@"images.image property not exists"];
            }
            else if(panoramaType == PLPanoramaTypeCubic)
            {
                [self loadCubicPanoramaTexture:panorama face:PLCubeFaceOrientationFront images:images property:@"front" urlbase:urlbase];
                [self loadCubicPanoramaTexture:panorama face:PLCubeFaceOrientationBack images:images property:@"back" urlbase:urlbase];
                [self loadCubicPanoramaTexture:panorama face:PLCubeFaceOrientationLeft images:images property:@"left" urlbase:urlbase];
                [self loadCubicPanoramaTexture:panorama face:PLCubeFaceOrientationRight images:images property:@"right" urlbase:urlbase];
                [self loadCubicPanoramaTexture:panorama face:PLCubeFaceOrientationUp images:images property:@"up" urlbase:urlbase];
                [self loadCubicPanoramaTexture:panorama face:PLCubeFaceOrientationDown images:images property:@"down" urlbase:urlbase];
            }
            else if(panoramaType == PLPanoramaTypeCylindrical)
            {
                if([[images allKeys] containsObject:@"image"])
                {
                    PLTexture *imageTexture = [self createTexture:[images objectForKey:@"image"] urlbase:urlbase];
                    if(imageTexture)
                        [(PLCylindricalPanorama *)panorama setTexture:imageTexture];
                    else
                        [NSException raise:@"PanoramaGL" format:@"images.image property wrong value"];
                }
                else
                    [NSException raise:@"PanoramaGL" format:@"images.image property not exists"];
            }
            
        }
        else
            [NSException raise:@"PanoramaGL" format:@"images property not exists"];
        
        NSDictionary *camera = [json objectForKey:@"camera"];
        if(camera && [camera isKindOfClass:[NSDictionary class]])
        {
            NSArray *cameraKeys = [camera allKeys];
            if([cameraKeys containsObject:@"athmin"] && [cameraKeys containsObject:@"athmax"] && [cameraKeys containsObject:@"atvmin"] && [cameraKeys containsObject:@"atvmax"] && [cameraKeys containsObject:@"hlookat"] && [cameraKeys containsObject:@"vlookat"])
            {
                PLCamera *currentCamera = panorama.currentCamera;
                int athmin = [(NSNumber *)[camera objectForKey:@"athmin"] intValue];
                int athmax = [(NSNumber *)[camera objectForKey:@"athmax"] intValue];
                int atvmin = [(NSNumber *)[camera objectForKey:@"atvmin"] intValue];
                int atvmax = [(NSNumber *)[camera objectForKey:@"atvmax"] intValue];
                int hlookat = [(NSNumber *)[camera objectForKey:@"hlookat"] intValue];
                int vlookat = [(NSNumber *)[camera objectForKey:@"vlookat"] intValue];
                currentCamera.pitchRange = PLRangeMake(atvmin, atvmax);
                currentCamera.yawRange = PLRangeMake(athmin, athmax);
                [currentCamera setInitialLookAtWithPitch:vlookat yaw:hlookat];
            }
            else
                [NSException raise:@"PanoramaGL" format:@"camera properties are wrong"];
        }
        NSArray *hotspots = [json objectForKey:@"hotspots"];
        if(hotspots && [hotspots isKindOfClass:[NSArray class]])
        {
            NSUInteger hotspotsCount = [hotspots count];
            for(NSUInteger i = 0; i < hotspotsCount; i++)
            {
                NSDictionary *hotspot = [hotspots objectAtIndex:i];
                if(hotspot && [hotspot isKindOfClass:[NSDictionary class]])
                {
                    NSArray *hotspotKeys = [hotspot allKeys];
                    if([hotspotKeys containsObject:@"id"] && [hotspotKeys containsObject:@"image"] && [hotspotKeys containsObject:@"atv"] && [hotspotKeys containsObject:@"ath"] && [hotspotKeys containsObject:@"width"] && [hotspotKeys containsObject:@"height"])
                    {
                        PLTexture *hotspotTexture = [self createHotspotTexture:[hotspot objectForKey:@"image"] urlbase:urlbase];
                        int identifier = [(NSNumber *)[hotspot objectForKey:@"id"] intValue];
                        int atv = [(NSNumber *)[hotspot objectForKey:@"atv"] intValue];
                        int ath = [(NSNumber *)[hotspot objectForKey:@"ath"] intValue];
                        float width = [(NSNumber *)[hotspot objectForKey:@"width"] floatValue];
                        float height = [(NSNumber *)[hotspot objectForKey:@"height"] floatValue];
                        PLHotspot *currentHotspot = [PLHotspot hotspotWithId:identifier texture:hotspotTexture atv:atv ath:ath];
                        [currentHotspot setWidth:width];
                        [currentHotspot setHeight:height];
                        [panorama addHotspot:currentHotspot];
                    }
                }
            }
        }
        [view setPanorama:panorama];
        if([[json allKeys] containsObject:@"sensorialRotation"] && [(NSNumber *)[json objectForKey:@"sensorialRotation"] boolValue])
            [view startSensorialRotation];
        [view startAnimation];
        [panorama release];
    }
}

#pragma mark -
#pragma mark dealloc methods

-(void)dealloc
{
    if(json)
        [json release];
    if(hotspotTextures)
        [hotspotTextures release];
    [super dealloc];
}

@end
