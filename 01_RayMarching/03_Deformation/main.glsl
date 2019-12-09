
#define MAX_VALUE 1e10
#define EPSILON 0.00001
#define MARCHING_LOOP 256

// 球体の距離関数
float dfSphere(vec3 p, float r) {
    return length(p) - r;
}

// ボックスの距離関数
float dfBox(vec3 p, vec3 b)
{
    vec3 q = abs(p) - b;
    return 
        length(max(q, 0.0)) + 
        min(max(q.x, max(q.y, q.z)), 0.0);
}

// 距離比較
float dfCompare(float a, float b) {
    return (a < b) ? a : b;
}

// 距離関数
float map(vec3 p) {
    float result = MAX_VALUE;

    // // でこぼこ球体表示
    // vec3 sp = p + vec3(-12., 0, 0);
    // const float n = 0.85;
    // float d1 = dfSphere(sp, 10.);
    // float d2 = sin(sp.x * n) * sin(sp.y * n) * sin(sp.z * n);
    // result = dfCompare(result, (d1 + d2));
    // // 通常の球体表示
    // sp = p + vec3(12., 0, 0);
    // result = dfCompare(result, dfSphere(sp, 10.));

    // 変形したボックス表示
    vec3 bp = p + vec3(-10., 0, 0);
    const float k = 0.6;
    float c = cos(k * bp.y);
    float s = sin(k * bp.y);
    mat2  m = mat2(c, -s, s, c);
    vec2 xz = m * bp.xz;
    vec3  q = vec3(xz.x, bp.y, xz.y);
    result = dfCompare(result, dfBox(q, vec3(3, 15, 1)) - .3);
    // 通常のボックス表示
    bp = p + vec3(10., 0, 0);
    result = dfCompare(result, dfBox(bp, vec3(3, 15, 1)) - .3);

    return result;
}

// 法線生成関数
vec3 mapNormal(vec3 p) {
    return normalize(
        vec3(
            map(p + vec3(EPSILON, 0.0,     0.0    )) - map(p + vec3(-EPSILON,  0.0,      0.0    )),
            map(p + vec3(0.0,     EPSILON, 0.0    )) - map(p + vec3( 0.0,     -EPSILON,  0.0    )),
            map(p + vec3(0.0,     0.0,     EPSILON)) - map(p + vec3( 0.0,      0.0,     -EPSILON))));
}

// エントリ関数
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 pixelPos = (fragCoord.xy * 2. - iResolution.xy) / min(iResolution.x, iResolution.y); // 原点を画面中心に

    vec3 cameraPos  = vec3( 0.0,  0.0, 30.0);   // カメラ座標
    vec3 cameraDir  = vec3( 0.0,  0.0, -1.0);   // カメラ向き
    vec3 cameraUp   = vec3( 0.0,  1.0,  0.0);   // カメラ上方向ベクトル
    vec3 cameraSide = cross(cameraDir, cameraUp); // 横方向ベクトル

    vec3 lightDir = normalize(vec3(1.0, 1.0, 1.0));
    vec3 lightColor = vec3(1.0);

    // ピクセル座標に対応したレイを生成
    vec3 ray = normalize(cameraSide * pixelPos.x + cameraUp * pixelPos.y + cameraDir);

    float rDistance = 0.0;  // レイの先端座標(rPos)とオブジェクトの距離
    float rLen = 0.0;       // カメラ座標からレイの先端座標までの距離
    vec3 rPos = cameraPos;  // レイの先端座標

    // マーチングループ
    vec4 result = vec4(0.0);
    for (int i = 0; i < MARCHING_LOOP; i++) {
        rPos = cameraPos + ray * rLen;  // レイを伸ばしてレイの先端座標を更新
        rDistance = map(rPos);  // 距離関数でオブジェクトとの距離を取得

        // 衝突判定(距離が0に限りなく近ければ衝突したと判断)
        if (abs(rDistance) < EPSILON) {
            // カラー決定
            result = vec4(max(dot(lightDir, mapNormal(rPos)), 0.0) * lightColor, 1.0);
            break;
        }

        rLen += rDistance;  // レイの長さを更新
    }

    fragColor = result;
}
  