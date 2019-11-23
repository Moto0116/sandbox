
<!---レイマーチングに関しての説明等--->

# レイマーチング  
  
  レイマーチングとはレイトレーシングと呼ばれるレンダリング技法の一つ。  
  一般的なラスタライズ法 レイトレース法とは違いポリゴンを使用せず、"距離関数"と呼ばれる数式をもとにしてオブジェクトをレンダリングするのが特徴。  
  上記特徴によって他のレンダリング法では難しい、オブジェクトの変形や合成を得意としていて[このような]())ものをコードオンリーで表示できる。(ただし描画負荷がかなり大きい)  

<!---環境設定に関する説明--->

# 環境

1. Visual Studio Code  
    1. [Shader languages support for VS Code](https://marketplace.visualstudio.com/items?itemName=slevesque.shader)  
        Version: 1.1.4  
        　hlsl glsl 等のシェーダー言語のコードハイライトや自動補間を行う  

    1. [Shader Toy](https://marketplace.visualstudio.com/items?itemName=stevensona.shader-toy)  
        Version: 0.9.0  
        　"shadertoy"と同様のglslシェーダーライブプレビュー機能をVSCode内で使用できる  
        　(※[本家](https://www.shadertoy.com)はGPUのスペックが低ければ重くてブラウザが死ぬ可能性があるのでリンク先に飛ぶ際は注意)  

<!---レイマーチングの使用事例--->

# 使用例  

  某空戦ゲーム
    ミドルウェア"TrueSky"がレイマーチングを使用している(空のライティングや雲の表現等？)  

  某RPGゲーム  
    雲海の表現にレイマーチングを使用  

<!---GLSLテストが可能なウェブサイト--->

## その他のGLSLテストが可能なウェブサイト  

  1. [GLSL Sandbox](http://glslsandbox.com/)  
        three.jsの作者が作ったサイト  
        基本機能は"shadertoy"とほぼ一緒だがブラウズ機能がしょぼいのと作品が良くも悪くも多いイメージ  
        クオリティがピンキリ 見たい作品が見つからなかったり  
        最初に触ってみる分にはかなり敷居が低いと思う  

  1. [vertexshaderart](https://www.vertexshaderart.com/)  
        "shadertoy"と"GLSL Sandbox"とは別に頂点シェーダーに特化したサイト  

  1. [Shdr Editor](http://shdr.bkcore.com/)  
        頂点シェーダーとフラグメントシェーダー(ピクセルシェーダー)両方書けるサイト  
        使ったことはないので触り心地はよくわからない  

<!---
    資料作成用のメモ
    参考URL
--->

# memo  
[iq live](http://iquilezles.org/live/index.htm)  
[qiitaでみっけたやつ](https://qiita.com/doxas/items/5a7b6dedff4bc2ce1586)  
[RayMarchingの図解](https://www.praph.tokyo/tags/Raymarching)  


<!---
    2019/11/24
--->
