// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "_Mine/10.2.2"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_Cubemap ("Enviroment Cubemap", Cube) = "_Skybox" {}
		_Distortion("Distortion", Range(0,100)) = 10
		_RefractionAmount("Refract Amount", Range(0.0, 1.0)) = 1.0
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "RenderType"="Opaque" }

		GrabPass{"_RefractionTex"}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 scrPos : TEXCOORD0;
				float4 uv : TEXCOORD1;
				float4 TtoW0 : TEXCOORD2;
				float4 TtoW1 : TEXCOORD3;
				float4 TtoW2 : TEXCOORD4;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;	
			float4 _BumpMap_ST;
			samplerCUBE _Cubemap;
			float _Distortion;
			fixed _RefractionAmount;
			sampler2D _RefractionTex;
			float4 _RefractionTex_TexelSize;
			
			v2f vert (a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.scrPos = ComputeGrabScreenPos(o.pos);
				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed3 worldBionormal = cross(worldNormal, worldTangent) * v.tangent.w;

				o.TtoW0 = float4 (worldTangent.x ,worldBionormal.x, worldNormal.x, worldPos.x);
				o.TtoW1 = float4 (worldTangent.y ,worldBionormal.y, worldNormal.y, worldPos.y);
				o.TtoW2 = float4 (worldTangent.z ,worldBionormal.z, worldNormal.z, worldPos.z);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
				fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				fixed3 bump = UnPackNormal(tex2D(_BumpMap, i.uv.zw));
				float2 offset = bump.xy * _Distortion * _RefractionTex_TexelSize.xy;
				i.scrPos.xy = offset + i.scrPos.xy;
				fixed3 refrcol = tex2D(_RefractionTex, i.scrPos.xy/i.scrPos.w).rgb;

				
			}
			ENDCG
		}
	}
}
