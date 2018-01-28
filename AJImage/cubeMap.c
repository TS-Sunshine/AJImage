//
//  cubeMap.c
//  AJImage
//
//  Created by 安静的为你歌唱 on 2018/1/24.
//  Copyright © 2018年 安静地为你歌唱. All rights reserved.
//

#include "cubeMap.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

struct CubeMap {
    int length;
    float dimension;
    float *data;
};
void rgbToHSV(float *rgb, float *hsv) {
    float min, max, delta;
    float r = rgb[0], g = rgb[1], b = rgb[2];
    float *h = hsv, *s = hsv + 1, *v = hsv + 2;
    
    min = fmin(fmin(r, g), b );
    max = fmax(fmax(r, g), b );
    *v = max;
    delta = max - min;
    if( max != 0 )
        *s = delta / max;
    else {
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;
    else if( g == max )
        *h = 2 + ( b - r ) / delta;
    else
        *h = 4 + ( r - g ) / delta;
    *h *= 60;
    if( *h < 0 )
        *h += 360;
}

struct CubeMap createCubeMap(float minHueAngle, float maxHueAngle) {
    const unsigned int size = 64;
    struct CubeMap map;
    map.length = size * size * size * sizeof (float) * 4;
    map.dimension = size;
    float *cubeData = (float *)malloc (map.length);
    float rgb[3], hsv[3], *c = cubeData;
    
    for (int z = 0; z < size; z++){
        rgb[2] = ((double)z)/(size-1); // 蓝
        for (int y = 0; y < size; y++){
            rgb[1] = ((double)y)/(size-1); // 绿
            for (int x = 0; x < size; x ++){
                rgb[0] = ((double)x)/(size-1); // 红
                rgbToHSV(rgb,hsv);
                float alpha = (hsv[0] > minHueAngle && hsv[0] < maxHueAngle) ? 0.0f: 1.0f;
                
                c[0] = rgb[0] * alpha;
                c[1] = rgb[1] * alpha;
                c[2] = rgb[2] * alpha;
                c[3] = alpha;
                c += 4;
            }
        }
    }
    map.data = cubeData;
    return map;
}

