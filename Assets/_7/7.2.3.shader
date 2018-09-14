// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'


Shader "_Mine/7.2.3" 
{
	Properties 
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
		_BumpMap("Normal Map", 2D) = "bump" {}
		_BumpScale("Bump Scale", Float) = 1.0
	}

	SubShader 
	{
		Pass
		{
			Tags{"LightMode" = "ForwardBase"}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float _BumpScale;
			fixed4 _Specular;
			float _Gloss;

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float3 tangent : TANGENT;
				float4 textcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 lightDir : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
				float4 uv : TEXCOORD2;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);

				o.uv.xy = v.textcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.zw = v.textcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;

				float binormal = cross( normalize(v.normal), normalize(v.tangent.xyz) ) * v.tangent.w;

				float3x3 rotation = float3x3(v.tangent.xyz, binormal, v.normal);
				o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex).xyz);
				o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex).xyz);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 worldLight = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldNormal = normalize(i.worldNormal);

				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLight));

				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 halfDir = normalize(worldLight + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

				fixed3 color = ambient + diffuse +  specular;
				return fixed4(color, 1.0);
			}

			ENDCG
		}
	}

	Fallback "Specular"
}
