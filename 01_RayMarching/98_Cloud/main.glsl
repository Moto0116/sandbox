
 #define MAX_VALUE 1e10
 #define EPSILON 0.00001
 #define SAMPLE_COUNT 64

//-------------------------------------------------

// オフセット行列
mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64);

// 乱数の生成(完全な疑似乱数ではなく与えられた値に対してい一意な値が求まる)
float hash(float n)
{
    return fract(sin(n) * 43758.5453);
}

// 入力vec3に対してfloatで値を返すノイズ関数
float noise(in vec3 x)
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f * f * (3.0 - 2.0 * f);

    float n = p.x + p.y * 57.0 + 113.0 * p.z;

    float res = mix(mix(mix(hash(n +   0.0), hash(n +   1.0), f.x),
                        mix(hash(n +  57.0), hash(n +  58.0), f.x), f.y),
                    mix(mix(hash(n + 113.0), hash(n + 114.0), f.x),
                        mix(hash(n + 170.0), hash(n + 171.0), f.x), f.y), f.z);
    return res;
}

// FractalBrownianMotion
float fbm(vec3 p)
{
    float f;
    f  = 0.5000 * noise(p); p = m * p * 2.02;
    f += 0.2500 * noise(p); p = m * p * 2.03;
    f += 0.1250 * noise(p);
    return f;
}

//-------------------------------------------------

// 球体の距離関数
float dfSphere(vec3 p, float r) {
    return length(p) - r;
}

// 距離比較
float dfCompare(float a, float b) {
    return (a < b) ? a : b;
}

// 距離関数
float map(vec3 p) {
    float result = MAX_VALUE;
    result = dfCompare(0.1 - length(p) * 0.05 + fbm(p * 0.3), result);
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

    vec3 cameraPos  = vec3( 0.0,  0.0,  -20.0);   // カメラ座標
    vec3 cameraDir  = vec3( 0.0,  0.0,  1.0);   // カメラ向き
    vec3 cameraUp   = vec3( 0.0,  1.0,  0.0);   // カメラ上方向ベクトル
    vec3 cameraSide = cross(cameraDir, cameraUp); // 横方向ベクトル

    // ピクセル座標に対応したレイを生成
    vec3 ray = normalize(cameraSide * pixelPos.x + cameraUp * pixelPos.y + cameraDir);

    // サンプリングパラメータ
    float rStepMax = 40.;   // レイ更新時ステップの最大値
    float rStep = rStepMax / float(SAMPLE_COUNT); // レイ更新時のステップ値

    float rLen = 0.0;       // カメラ座標からレイの先端座標までの距離
    vec3 rPos = cameraPos;  // レイの先端座標

    float T = 1.0;  // 透過率
    float absorption = 120.0;   // 光の吸収率

    // マーチングループ
    vec4 result = vec4(0.0);
    for (int i = 0; i < SAMPLE_COUNT; i++) {
        rPos = cameraPos + ray * rLen;  // レイを伸ばしてレイの先端座標を更新
        
        float rDensity = map(rPos); // 雲の密度値
        if (rDensity > 0.0) // 密度値が0より大きい場合は雲の内部と判断
        {
            float tmp = rDensity / float(SAMPLE_COUNT);

            T *= 1.0 - (tmp * absorption);
            if (T <= 0.01)
            {
                break;
            }

            float opaity = 50.0;
            float k = opaity * tmp * T;
            vec4 cloudColor = vec4(1.0);
            vec4 col1 = cloudColor * k;
            vec4 col2 = vec4(0.0);

            result += col1 + col2;

        }

        rLen += rStep;
    }
    
    // 空の色を加算する
    result.rgb += mix(
        vec3(0.3, 0.3, 0.7), 
        vec3(0.7, 0.7, 1.0), 
        1.0 - (pixelPos.y + 1.0));

    fragColor = result;
}
