
#define MAX_VALUE 1e10
#define EPSILON 0.00001
#define PI 3.1415926
#define DEG_TO_RAD(deg) deg * PI / 180.0
#define RAD_TO_DEG(rad) rad * 180.0 / PI
#define MARCHING_LOOP 128

vec3 rotate(vec3 p, float angle, vec3 axis) {
    vec3 a = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float r = 1.0 - c;
    mat3 m = mat3(
        a.x * a.x * r + c,
        a.y * a.x * r + a.z * s,
        a.z * a.x * r - a.y * s,
        a.x * a.y * r - a.z * s,
        a.y * a.y * r + c,
        a.z * a.y * r + a.x * s,
        a.x * a.z * r + a.y * s,
        a.y * a.z * r - a.x * s,
        a.z * a.z * r + c
    );
    return m * p;
}

vec3 myRotate(vec3 p, float angle, vec3 axis) {
    vec3 nAxis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    mat3 mat = mat3(0);
    return mat * p;
}

// 球体オブジェクト
float dfSphere(vec3 p, float s) {
    return length(p) - s;
}

// ボックスオブジェクト
float dfBox(vec3 p, vec3 b) {
    vec3 d = abs(p) - b;
    float dMax = max(d.x,max(d.y,d.z));
    return length(max(d, 0.0)) + min(dMax, 0.0);
}

// Union
// プリミティブA,Bの合成(A | B)
float dfUnion(float a, float b) {
    return min(a, b);
}

// Subtraction
// プリミティブAからBを減算する(A & !B)
float dfSubtraction(float a, float b) {
    return max(-a, b);
}

// Intersection
// プリミティブAとBの重なっている部分を表示(A & B)
float dfIntersection(float a, float b) {
    return max(a, b);
}

// 距離比較
float dfCompare(float a, float b) {
    return (a < b) ? a : b;
}

// 距離関数
float map(vec3 p) {
    float result = MAX_VALUE;
    result = dot(p + vec3(0, 10, 0), vec3(0, 1, 0));

    result = dfCompare(result, dfBox(rotate(p + vec3(-3, 0, 3), DEG_TO_RAD(45.0), vec3(1, 0, 0)), vec3(1, 1, 1)));
    result = dfCompare(result, dfBox(rotate(p + vec3( 3, 0, 3), DEG_TO_RAD(45.0), vec3(0, 1, 0)), vec3(1, 1, 1)));
    result = dfCompare(result, dfBox(rotate(p + vec3( 0, 0, 3), DEG_TO_RAD(45.0), vec3(0, 0, 1)), vec3(1, 1, 1)));
    return result;
}

// 法線生成関数
vec3 mapNormal(vec3 p) {
    return normalize(
        vec3(
            map(p + vec3(EPSILON, 0.0,     0.0    )) - map(p + vec3(-EPSILON,  0.0,       0.0    )),
            map(p + vec3(0.0,     EPSILON, 0.0    )) - map(p + vec3( 0.0,     -EPSILON,   0.0    )),
            map(p + vec3(0.0,     0.0,     EPSILON)) - map(p + vec3( 0.0,      0.0,      -EPSILON))));
}

// メイン
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 pixelPos = (fragCoord.xy * 2. - iResolution.xy) / min(iResolution.x, iResolution.y);	// ピクセル座標を-1.0～1.0に収める
	
    vec3 lightDir   = vec3(-0.5,  0.5,  0.5);   // ライト向き
    vec3 cameraPos  = vec3( 0.0,  3.0,  5.0);   // カメラ座標
    vec3 cameraDir  = vec3( 0.0, -0.3, -1.0);	// カメラ向き
    vec3 cameraUp   = vec3( 0.0,  1.0,  0.0);   // カメラ上方向ベクトル
    vec3 cameraSide = cross(cameraDir, cameraUp);	// 横方向ベクトル
    float forcus = 1.0;
    
    // ピクセル座標に対応したレイを生成
    vec3 ray = normalize(cameraSide * pixelPos.x + cameraUp * pixelPos.y + cameraDir * forcus);
    
    float distance = 0.0;   // レイの先端座標(rPos)とオブジェクトの距離
    float rLen = 0.0;       // カメラ座標からレイの先端座標までの距離
    vec3 rPos = cameraPos;  // レイの先端座標
    
    // マーチングループ
    vec4 result = vec4(1.0);
    for (int i = 0; i < MARCHING_LOOP; i++) {
        rPos = cameraPos + ray * rLen;
        distance = map(rPos);

        // 衝突判定(距離が0に限りなく近ければ衝突したと判断)
        if (abs(distance) < 0.001) {
            // カラー決定.
    	    result = vec4(mapNormal(rPos), 1.0);
        }

        rLen += distance;
    }

    fragColor = result;
}
