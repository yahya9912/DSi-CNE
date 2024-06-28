//SHADERTOY PORT FIX
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
//****MAKE SURE TO remove the parameters from mainImage.
//SHADERTOY PORT FIX

int invert = 1; // 0 means no original color 1 means invert

void mainImage( ){
    vec4 color = texture(iChannel0, fragCoord.xy/iResolution.xy);
    if(invert == 0) {
        fragColor = color;
    } else {
    fragColor = vec4(1.0-color.rgb,1.0);
    }
}