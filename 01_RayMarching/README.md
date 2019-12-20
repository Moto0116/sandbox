
<!---この項目の概要--->
# 概要

RayMarchingに関して調査してまとめていく予定

<!---環境設定に関する説明--->

# 環境

1. Visual Studio Code  
    1. [Shader languages support for VS Code](https://marketplace.visualstudio.com/items?itemName=slevesque.shader)  
        Version: 1.1.4  
        　hlsl glsl 等のシェーダー言語のコードハイライトや自動補間を行う  

    1. [Shader Toy](https://marketplace.visualstudio.com/items?itemName=stevensona.shader-toy)  
        Version: 0.9.2  
        　"shadertoy"と同様のglslシェーダーライブプレビュー機能をVSCode内で使用できる  
        　(※[本家](https://www.shadertoy.com)はGPUのスペックが低ければ重くてブラウザが死ぬ可能性があるのでリンク先に飛ぶ際は注意)  

<!---目次--->

# 目次  

* [00_Primitive](00_Primitive/README.md)  
  * RayMarchingの概念説明
  * レイの定義  
  * プリミティブの描画  
  * 法線の定義  
* [01_Combination](01_Combination/README.md)  
  * プリミティブの合成  
* ~~02_Alteration~~
* [03_Deformation](03_Deformation/README.md)  
  * プリミティブの変形
