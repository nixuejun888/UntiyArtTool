// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ni/Built-In/虚化流线"
{
	Properties
	{
		_zhouxiang("X轴Y轴（0，1）", Range( 0 , 1)) = 1
		_fangxiangqiehuan("渐变方向切换", Range( 0 , 1)) = 1
		[HDR]_jianbianyanse("渐变颜色", Color) = (0.3101193,0.5698268,0.9528302,1)
		[HDR]_xiantiaoyanse("线条颜色", Color) = (0.282353,0.4745098,0.7490196,1)
		_xiantiaoduanshu("线条段数", Float) = 1
		_xiantiaokuandu("线条宽度", Float) = 44.98
		_xiantiaoliudongsudu("线条流动速度", Float) = 0.3
		_jianbianfanwei1("渐变范围", Float) = 0.2
		_zhengtitoumingdu("整体透明度", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _jianbianyanse;
		uniform float4 _xiantiaoyanse;
		uniform float _zhouxiang;
		uniform float _fangxiangqiehuan;
		uniform float _xiantiaoduanshu;
		uniform float _xiantiaoliudongsudu;
		uniform float _xiantiaokuandu;
		uniform float _jianbianfanwei1;
		uniform float _zhengtitoumingdu;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _jianbianyanse.rgb;
			float lerpResult6 = lerp( i.uv_texcoord.x , i.uv_texcoord.y , _zhouxiang);
			float lerpResult147 = lerp( lerpResult6 , ( 1.0 - lerpResult6 ) , _fangxiangqiehuan);
			float mulTime14 = _Time.y * _xiantiaoliudongsudu;
			o.Emission = ( _xiantiaoyanse * pow( ( abs( ( frac( ( ( lerpResult147 * _xiantiaoduanshu ) + mulTime14 ) ) - 0.5 ) ) * 2.0 ) , _xiantiaokuandu ) ).rgb;
			o.Alpha = ( saturate( (-_jianbianfanwei1 + (lerpResult147 - 0.0) * (1.0 - -_jianbianfanwei1) / (1.0 - 0.0)) ) * _zhengtitoumingdu );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
1945;78;1920;1019;-1901.75;916.4372;1.671803;True;True
Node;AmplifyShaderEditor.RangedFloatNode;7;-513.8172,3.117769;Inherit;False;Property;_zhouxiang;X轴Y轴（0，1）;0;0;Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-292.6971,-199.2849;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;6;186.7929,-56.21099;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;148;285.1389,-549.307;Inherit;False;Property;_fangxiangqiehuan;渐变方向切换;1;0;Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;121;526.645,-16.00281;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;700.8084,273.2644;Inherit;False;Property;_xiantiaoliudongsudu;线条流动速度;6;0;Create;False;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;727.2789,112.4137;Inherit;False;Property;_xiantiaoduanshu;线条段数;4;0;Create;False;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;147;772.913,-216.9124;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;1039.991,42.17336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;895.8967,277.2451;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;1124.948,252.2534;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;22;1280.472,279.3919;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;1214.819,-1175.28;Inherit;False;Property;_jianbianfanwei1;渐变范围;7;0;Create;False;0;0;0;False;0;False;0.2;0.188;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;1438.677,290.2785;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;157;1445.542,-1168.492;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;25;1607.422,324.3094;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;1755.361,278.0977;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;156;1668.343,-1123.04;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;1659.781,528.502;Inherit;False;Property;_xiantiaokuandu;线条宽度;5;0;Create;False;0;0;0;False;0;False;44.98;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;26;1977.088,402.1659;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;2019.35,200.57;Inherit;False;Property;_xiantiaoyanse;线条颜色;3;1;[HDR];Create;False;0;0;0;False;0;False;0.282353,0.4745098,0.7490196,1;5.35131,3.66947,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;111;1992.078,-943.4576;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;1979.931,-382.7778;Inherit;False;Property;_zhengtitoumingdu;整体透明度;8;0;Create;False;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;2463.744,292.0054;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;2555.146,-479.5948;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;2498.11,-159.1587;Inherit;False;Property;_jianbianyanse;渐变颜色;2;1;[HDR];Create;False;0;0;0;False;0;False;0.3101193,0.5698268,0.9528302,1;0,0.9551587,7.601456,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;3481.657,-573.9544;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ni/Built-In/虚化流线;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;0;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;3;1
WireConnection;6;1;3;2
WireConnection;6;2;7;0
WireConnection;121;0;6;0
WireConnection;147;0;6;0
WireConnection;147;1;121;0
WireConnection;147;2;148;0
WireConnection;12;0;147;0
WireConnection;12;1;16;0
WireConnection;14;0;15;0
WireConnection;17;0;12;0
WireConnection;17;1;14;0
WireConnection;22;0;17;0
WireConnection;24;0;22;0
WireConnection;157;0;62;0
WireConnection;25;0;24;0
WireConnection;29;0;25;0
WireConnection;156;0;147;0
WireConnection;156;3;157;0
WireConnection;26;0;29;0
WireConnection;26;1;27;0
WireConnection;111;0;156;0
WireConnection;48;0;30;0
WireConnection;48;1;26;0
WireConnection;50;0;111;0
WireConnection;50;1;52;0
WireConnection;2;0;39;0
WireConnection;2;2;48;0
WireConnection;2;9;50;0
ASEEND*/
//CHKSM=456607F9B820093FEF7E8DDC20A8825C99BE9914