Shader "_Mine/9.2.2.1" 
{
	Properties 
	{
		_Diffuse("Diffuse", Color) = (1,1,1,1)
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}

	SubShader 
	{

		Pass
		{
			Tags{"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			struct a2v
			{
				float4 vertex : POSITION;
				fixed3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed3 worldNormal : COLOR;
				fixed3 worldPos : COLOR1;
			};


			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);
				o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

				// reflect part:
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				fixed3 halfDir = normalize(worldLight + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

				fixed atten = 1.0;

				fixed3 color = ambient + (diffuse + specular) * atten;
				return fixed4(color, 1.0);
			}

			ENDCG
		}

		Pass{
			Tags{ "LightMode"="ForwardAdd"}
			Blend one one 

			CGPROGRAM
			#pragma multi_compile_fwdadd
			ENDCG
		}
	}

	Fallback "Diffuse"
}
