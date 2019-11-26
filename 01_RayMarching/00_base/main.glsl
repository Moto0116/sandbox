#define MAX_VALUE 1e10
#define EPSILON 0.00001
#define MARCHING_LOOP 128

// 球体の距離関数
float dfSphere(vec3 p, float r) {
    return length(p) - r;
}

// 距離関数
float map(vec3 p) {
    float result = MAX_VALUE;
    result = dfSphere(p, 1.);
    return result;
}

// エントリ関数
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 pixelPos = (fragCoord.xy * 2. - iResolution.xy) / min(iResolution.x, iResolution.y);	// 原点を画面中心に
	
    vec3 cameraPos  = vec3( 0.0,  0.0,  5.0);   // カメラ座標
    vec3 cameraDir  = vec3( 0.0,  0.0, -1.0);	// カメラ向き
    vec3 cameraUp   = vec3( 0.0,  1.0,  0.0);   // カメラ上方向ベクトル
    vec3 cameraSide = cross(cameraDir, cameraUp);	// 横方向ベクトル
    
    // ピクセル座標に対応したレイを生成
    vec3 ray = normalize(cameraSide * pixelPos.x + cameraUp * pixelPos.y + cameraDir);
    
    float rDistance = 0.0;  // レイの先端座標(rPos)とオブジェクトの距離
    float rLen = 0.0;       // カメラ座標からレイの先端座標までの距離
    vec3 rPos = cameraPos;  // レイの先端座標
    
    // マーチングループ
    vec4 result = vec4(0.0);
    for (int i = 0; i < MARCHING_LOOP; i++) {
        rPos = cameraPos + ray * rLen;
        rDistance = map(rPos);

        // 衝突判定(距離が0に限りなく近ければ衝突したと判断)
        if (abs(rDistance) < EPSILON) {
            // カラー決定
    	    result = vec4(1.0);
            break;
        }

        rLen += rDistance;
    }

    fragColor = result;
}
