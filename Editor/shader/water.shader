// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ni/Built-In/water"
{
	Properties
	{
		_Normal1("Normal1", 2D) = "white" {}
		_LerpStrength("Lerp Strength", Range( 0 , 1)) = 0.5
		_Normal1Intensity("Normal1 Intensity", Float) = 1
		_Normal2Intensity("Normal2 Intensity", Float) = 1
		_Speeduv1uv2("Speed uv1 uv2", Vector) = (0,0,0,0)
		_UV1("UV1", Vector) = (1,1,1,1)
		_UV2("UV2", Vector) = (1,1,1,1)
		_Color("Color", Color) = (0.4764151,0.7947526,1,0)
		_FresnelPower("Fresnel Power", Range( 0 , 8)) = 0.88
		_Depth("Depth", Float) = 0
		_CameraDepthLength("Camera Depth Length", Float) = 1
		_CameraDepth("Camera Depth ", Float) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float eyeDepth;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _Normal1;
		uniform float4 _Speeduv1uv2;
		uniform float4 _UV1;
		uniform float _Normal1Intensity;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float4 _UV2;
		uniform float _Normal2Intensity;
		uniform float _LerpStrength;
		uniform float _Smoothness;
		uniform float4 _Color;
		uniform float _FresnelPower;
		uniform float _CameraDepthLength;
		uniform float _CameraDepth;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult6 = (float2(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g));
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_13_0 = (ase_worldPos).xz;
			float2 appendResult18 = (float2(( _Time.x * _Speeduv1uv2.x ) , ( _Time.x * _Speeduv1uv2.y )));
			float2 appendResult23 = (float2(_UV1.x , _UV1.y));
			float2 appendResult24 = (float2(_UV1.z , _UV1.w));
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth59 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth59 = saturate( abs( ( screenDepth59 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Depth ) ) );
			float2 appendResult28 = (float2(( _Time.x * _Speeduv1uv2.z ) , ( _Time.x * _Speeduv1uv2.w )));
			float2 appendResult33 = (float2(_UV2.x , _UV2.y));
			float2 appendResult34 = (float2(_UV2.z , _UV2.w));
			float3 lerpResult7 = lerp( UnpackScaleNormal( tex2D( _Normal1, ( ( ( temp_output_13_0 + appendResult18 ) * appendResult23 ) / appendResult24 ) ), ( _Normal1Intensity * distanceDepth59 ) ) , UnpackScaleNormal( tex2D( _Normal1, ( ( ( temp_output_13_0 + appendResult28 ) * appendResult33 ) / appendResult34 ) ), ( _Normal2Intensity * distanceDepth59 ) ) , _LerpStrength);
			float4 screenColor1 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( appendResult6 - ( (lerpResult7).xy * 0.1 ) ));
			float3 indirectNormal57 = WorldNormalVector( i , lerpResult7 );
			Unity_GlossyEnvironmentData g57 = UnityGlossyEnvironmentSetup( _Smoothness, data.worldViewDir, indirectNormal57, float3(0,0,0));
			float3 indirectSpecular57 = UnityGI_IndirectSpecular( data, 1.0, indirectNormal57, g57 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float2 appendResult50 = (float2(ase_vertexNormal.x , ase_vertexNormal.y));
			float3 appendResult55 = (float3(( appendResult50 - (lerpResult7).xy ) , ase_vertexNormal.z));
			float dotResult42 = dot( ase_worldViewDir , appendResult55 );
			float cameraDepthFade62 = (( i.eyeDepth -_ProjectionParams.y - _CameraDepth ) / _CameraDepthLength);
			float4 lerpResult37 = lerp( screenColor1 , ( float4( indirectSpecular57 , 0.0 ) + _Color ) , ( distanceDepth59 * pow( ( 1.0 - saturate( abs( dotResult42 ) ) ) , _FresnelPower ) * saturate( cameraDepthFade62 ) ));
			c.rgb = lerpResult37.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
7;48;1920;971;1854.21;1088.36;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;51;-3363.781,-415.9273;Inherit;False;1281.899;1148.25;uv;22;19;15;12;16;17;25;26;32;28;13;18;22;23;29;33;30;24;34;31;14;20;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;19;-3303.377,309.3284;Inherit;False;Property;_Speeduv1uv2;Speed uv1 uv2;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;10,5,30,30;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;15;-3304.892,97.60852;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-2994.102,480.1017;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;12;-3313.781,-93.79388;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-3006.646,69.58512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-3004.834,214.5383;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2993.645,357.6711;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;13;-2980.542,-87.51083;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;32;-2747.431,520.3229;Inherit;False;Property;_UV2;UV2;6;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.1,0.1,5,5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;22;-2927.081,-335.038;Inherit;False;Property;_UV1;UV1;5;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,6,6;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;28;-2813.534,379.0311;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-2811.512,116.0003;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-2501.657,447.3005;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;60;108.8768,-272.529;Inherit;False;Property;_Depth;Depth;9;0;Create;True;0;0;0;False;0;False;0;3.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;52;-1476.832,-732.0189;Inherit;False;1377;603.7651;normal;8;35;36;2;3;7;8;67;68;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-2638.2,-57.58348;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-2626.787,-365.9273;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-2634.534,200.0311;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1426.832,-490.0188;Inherit;False;Property;_Normal2Intensity;Normal2 Intensity;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-2674.787,-214.9273;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;59;338.3519,-305.7102;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-2430.882,-42.90773;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2433.534,190.0311;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-2465.242,577.8117;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1426.832,-618.0189;Inherit;False;Property;_Normal1Intensity;Normal1 Intensity;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1212.135,-599.7048;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;21;-2233.882,-46.90773;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1204.236,-445.5115;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;-2234.534,167.0311;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-994.832,-682.0189;Inherit;True;Property;_Normal1;Normal1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-994.832,-474.0188;Inherit;True;Property;_Normal2;Normal2;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-983.9584,-244.2538;Inherit;False;Property;_LerpStrength;Lerp Strength;1;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;-541.2034,-480.9503;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;43;-1041.103,-1369.518;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;53;-945.3518,-1091.823;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;50;-922.2075,-1193.327;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;56;-641.1113,-1263.186;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;39;-535.8554,-1440.225;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;55;-374.7427,-1182.51;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;42;-159.0148,-1388.498;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;44;61.63122,-1385.139;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;11;-1129.579,571.5018;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GrabScreenPosition;4;-1156.771,355.4323;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;180.331,-418.7693;Inherit;False;Property;_CameraDepth;Camera Depth ;11;0;Create;True;0;0;0;False;0;False;0;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1083.943,668.3823;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;46;245.5979,-1371.282;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;130.3154,-524.0939;Inherit;False;Property;_CameraDepthLength;Camera Depth Length;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-243.2665,-28.32626;Inherit;False;Property;_Smoothness;Smoothness;12;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-843.7071,319.0639;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CameraDepthFade;62;395.5096,-534.8027;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;47;474.5979,-1376.282;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-837.1681,619.4396;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;49;472.9818,-1105.881;Inherit;False;Property;_FresnelPower;Fresnel Power;8;0;Create;True;0;0;0;False;0;False;0.88;3.19;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;-509.6903,467.4347;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;38;255.2787,496.6209;Inherit;False;Property;_Color;Color;7;0;Create;True;0;0;0;False;0;False;0.4764151,0.7947526,1,0;0.373042,0.7830188,0.639988,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectSpecularLight;57;77.90417,-98.40841;Inherit;True;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;66;527.1576,-384.6979;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;48;793.4456,-1267.901;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;512.8057,361.6904;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;1;196.0698,237.1264;Inherit;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;710.3239,12.2544;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;37;685.5771,266.2723;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1254.386,-173.2198;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ni/Built-In/water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;15;1
WireConnection;26;1;19;4
WireConnection;16;0;15;1
WireConnection;16;1;19;1
WireConnection;17;0;15;1
WireConnection;17;1;19;2
WireConnection;25;0;15;1
WireConnection;25;1;19;3
WireConnection;13;0;12;0
WireConnection;28;0;25;0
WireConnection;28;1;26;0
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;33;0;32;1
WireConnection;33;1;32;2
WireConnection;14;0;13;0
WireConnection;14;1;18;0
WireConnection;23;0;22;1
WireConnection;23;1;22;2
WireConnection;29;0;13;0
WireConnection;29;1;28;0
WireConnection;24;0;22;3
WireConnection;24;1;22;4
WireConnection;59;0;60;0
WireConnection;20;0;14;0
WireConnection;20;1;23;0
WireConnection;30;0;29;0
WireConnection;30;1;33;0
WireConnection;34;0;32;3
WireConnection;34;1;32;4
WireConnection;67;0;35;0
WireConnection;67;1;59;0
WireConnection;21;0;20;0
WireConnection;21;1;24;0
WireConnection;68;0;36;0
WireConnection;68;1;59;0
WireConnection;31;0;30;0
WireConnection;31;1;34;0
WireConnection;2;1;21;0
WireConnection;2;5;67;0
WireConnection;3;1;31;0
WireConnection;3;5;68;0
WireConnection;7;0;2;0
WireConnection;7;1;3;0
WireConnection;7;2;8;0
WireConnection;53;0;7;0
WireConnection;50;0;43;1
WireConnection;50;1;43;2
WireConnection;56;0;50;0
WireConnection;56;1;53;0
WireConnection;55;0;56;0
WireConnection;55;2;43;3
WireConnection;42;0;39;0
WireConnection;42;1;55;0
WireConnection;44;0;42;0
WireConnection;11;0;7;0
WireConnection;46;0;44;0
WireConnection;6;0;4;1
WireConnection;6;1;4;2
WireConnection;62;0;64;0
WireConnection;62;1;63;0
WireConnection;47;0;46;0
WireConnection;9;0;11;0
WireConnection;9;1;10;0
WireConnection;5;0;6;0
WireConnection;5;1;9;0
WireConnection;57;0;7;0
WireConnection;57;1;69;0
WireConnection;66;0;62;0
WireConnection;48;0;47;0
WireConnection;48;1;49;0
WireConnection;58;0;57;0
WireConnection;58;1;38;0
WireConnection;1;0;5;0
WireConnection;61;0;59;0
WireConnection;61;1;48;0
WireConnection;61;2;66;0
WireConnection;37;0;1;0
WireConnection;37;1;58;0
WireConnection;37;2;61;0
WireConnection;0;13;37;0
ASEEND*/
//CHKSM=4DEBE72D6D14A5C659B2723D5910BF0AAF1B67AD