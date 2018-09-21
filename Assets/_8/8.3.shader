Shader "_Mine/8.3"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("MainTex", Color) = (1,1,1,1)
		_Cutoff("Alpha Cutoff" Range(0,1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="AlphaTest" "IgnoreProjector"="True" "RanderType"="TransparentCutout" }
		Pass{
			Tags {"LightMode"="ForwardBase"}
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			fixed _Cutoff;

			

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
			};

			v2f vert(a2v v){
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = UnityObjectToWorldPos(v.vertex).xyz;
				o.uv = TRANSFORM_TEX(v.texcoord. _MainTex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				return _Color;
			}




			ENDCG

		}

		
	}
}
