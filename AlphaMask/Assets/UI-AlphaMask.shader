// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "UI/AlphaMask"
{
	Properties
	{
		_MainTex("Sprite Texture", 2D) = "white" {}
		_AlphaTex("AlphaTex", 2D) = "white"{}
	}

		SubShader
		{
			Tags
			{
				"Queue" = "Transparent"
				"RenderType" = "Transparent"
			}

			Cull Off
			Lighting Off
			ZWrite Off
			ZTest[unity_GUIZTestMode]
			Blend SrcAlpha OneMinusSrcAlpha

			Pass
			{
				Name "Default"
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0

				#include "UnityCG.cginc"
				#include "UnityUI.cginc"

				#pragma multi_compile __ UNITY_UI_CLIP_RECT
				#pragma multi_compile __ UNITY_UI_ALPHACLIP

				struct appdata_t
				{
					float4 vertex   : POSITION;
					float4 color    : COLOR;
					float2 texcoord : TEXCOORD0;
					float2 texcoordalpha : TEXCOORD1;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 vertex   : SV_POSITION;
					fixed4 color : COLOR;
					float2 texcoord  : TEXCOORD0;
					float2 texcoordalpha : TEXCOORD1;
				};

				sampler2D _MainTex;
				fixed4 _Color;
				float4 _MainTex_ST;

				sampler2D _AlphaTex;
				float4 _AlphaTex_ST;

				float4 _AlphaPos;
				float _Width;
				float _Height;
				v2f vert(appdata_t v)
				{
					v2f OUT;
					OUT.vertex = UnityObjectToClipPos(v.vertex);
					OUT.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
					OUT.color = v.color;
					float2 uv = float2((v.vertex.x - _AlphaPos.x) / (_Width), (v.vertex.y - _AlphaPos.y) / _Height);
					OUT.texcoordalpha = TRANSFORM_TEX(uv, _MainTex);
					return OUT;
				}

				fixed4 frag(v2f IN) : SV_Target
				{
					half4 color = (tex2D(_MainTex, IN.texcoord)) * IN.color;
					half4 alpcolor = tex2D(_AlphaTex, IN.texcoordalpha + float2(0.5,0.5));
					color.a *= alpcolor.a;
					return color;
				}
			ENDCG
			}
		}
}
