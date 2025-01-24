// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ni/Universal/UI扫光"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_AddMap("扫光叠加贴图", 2D) = "white" {}
		_NoiseMap("NoiseMap", 2D) = "bump" {}
		_NoiseSpeed("NoiseSpeed", Vector) = (0.49,0.15,0,0)
		_NoiseStrength("Noise强度", Range( 0 , 1)) = 0
		[HDR]_color("颜色", Color) = (0,0.4865076,4.594794,1)
		_XY("方向（0：X轴，1：Y轴）", Range( 0 , 1)) = 0
		_Count("段数", Float) = 1
		_width("宽度", Float) = 8.57
		_speed("扫光速度", Float) = 1
		[Toggle(_UVOFFSET_ON)] _uvOffset("uvOffset", Float) = 0
		[Toggle(_UVOFFSET1_ON)] _uvOffset1("双向对开模式", Float) = 0
		_UVoffset("uv位移", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _UVOFFSET1_ON
			#pragma shader_feature_local _UVOFFSET_ON

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _NoiseMap;
			uniform float2 _NoiseSpeed;
			uniform float4 _NoiseMap_ST;
			uniform float _NoiseStrength;
			uniform float _XY;
			uniform float _Count;
			uniform float _speed;
			uniform float _UVoffset;
			uniform float _width;
			uniform sampler2D _AddMap;
			uniform float4 _AddMap_ST;
			uniform float4 _color;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
				float2 uv_NoiseMap = IN.texcoord.xy * _NoiseMap_ST.xy + _NoiseMap_ST.zw;
				float2 panner4 = ( 1.0 * _Time.y * _NoiseSpeed + uv_NoiseMap);
				float lerpResult41 = lerp( 0.0 , UnpackNormal( tex2D( _NoiseMap, panner4 ) ).r , _NoiseStrength);
				float2 temp_cast_0 = (lerpResult41).xx;
				float2 texCoord19 = IN.texcoord.xy * float2( 1,1 ) + temp_cast_0;
				float lerpResult20 = lerp( texCoord19.x , texCoord19.y , _XY);
				float temp_output_24_0 = ( lerpResult20 * _Count );
				float mulTime22 = _Time.y * _speed;
				#ifdef _UVOFFSET_ON
				float staticSwitch25 = _UVoffset;
				#else
				float staticSwitch25 = mulTime22;
				#endif
				float saferPower33 = abs( ( abs( ( frac( ( temp_output_24_0 + staticSwitch25 ) ) - 0.5 ) ) * 2.0 ) );
				float temp_output_33_0 = pow( saferPower33 , _width );
				float mulTime79 = _Time.y * -_speed;
				float saferPower59 = abs( ( abs( ( frac( ( temp_output_24_0 + mulTime79 ) ) - 0.5 ) ) * 2.0 ) );
				float2 texCoord81 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float lerpResult82 = lerp( texCoord81.x , texCoord81.y , _XY);
				float lerpResult69 = lerp( pow( saferPower59 , _width ) , temp_output_33_0 , step( lerpResult82 , 0.5 ));
				#ifdef _UVOFFSET1_ON
				float staticSwitch80 = lerpResult69;
				#else
				float staticSwitch80 = temp_output_33_0;
				#endif
				float2 uv_AddMap = IN.texcoord.xy * _AddMap_ST.xy + _AddMap_ST.zw;
				
				half4 color = ( ( tex2DNode2 + ( tex2DNode2.a * ( staticSwitch80 * tex2D( _AddMap, uv_AddMap ) ) * _color ) ) * IN.color );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
7;24;1920;995;172.7662;2582.862;2.618299;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-2219.794,-1979.127;Inherit;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;43;-2183.082,-1690.036;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;2;0;Create;True;0;0;0;False;0;False;0.49,0.15;0.24,0.56;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;4;-1842.188,-1820.408;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1225.574,-1310.854;Inherit;False;Property;_NoiseStrength;Noise强度;3;0;Create;False;0;0;0;False;0;False;0;1.03;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1580.501,-1879.97;Inherit;True;Property;_NoiseMap;NoiseMap;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;41;-1186.935,-1871.678;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-903.0556,-2089.354;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-852.7867,-1758.408;Inherit;True;Property;_XY;方向（0：X轴，1：Y轴）;5;0;Create;False;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;-573.0428,-1962.298;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-405.0574,-1047.319;Inherit;False;Property;_speed;扫光速度;8;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;62;-138.8154,-1240.629;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;22;18.54386,-1078.315;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-228.2394,-685.9262;Inherit;False;Property;_UVoffset;uv位移;11;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;21;-289.43,-1858.326;Inherit;True;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-301.82,-1589.193;Inherit;False;Property;_Count;段数;6;0;Create;False;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;25;209.7045,-887.2654;Inherit;False;Property;_uvOffset;uvOffset;9;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;79;52.656,-1310.959;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;36.08651,-1854.224;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;490.1558,-1596.348;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;518.3358,-1129.971;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;28;809.1302,-935.8795;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;56;825.9577,-1445.059;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;57;1007.162,-1437.898;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;996.9391,-935.3231;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;81;-740.5344,-2385.574;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;30;1218.402,-929.2683;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;58;1228.625,-1431.843;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;82;-410.5215,-2258.518;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;1416.081,-1435.878;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;1405.858,-933.3028;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;662.7772,-1781.15;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;1372.413,-1133.841;Inherit;False;Property;_width;宽度;7;0;Create;False;0;0;0;False;0;False;8.57;5.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;59;1675.319,-1380.056;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;70;1307.537,-1915.751;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;33;1712.133,-896.2971;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;69;2067.734,-1446.142;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;55;2339.196,-773.3577;Inherit;True;Property;_AddMap;扫光叠加贴图;0;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;80;2320.458,-1210.677;Inherit;False;Property;_uvOffset1;双向对开模式;10;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;2348.33,-1588.138;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;2644.024,-1580.648;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;2703.231,-1153.728;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;51;2808.589,-946.3486;Inherit;False;Property;_color;颜色;4;1;[HDR];Create;False;0;0;0;False;0;False;0,0.4865076,4.594794,1;0,0.4865076,4.594794,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;3017.12,-1215.73;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;3228.797,-1332.52;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;53;3283.651,-1158.146;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;3538.501,-1244.182;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;112;3850.306,-1248.854;Float;False;True;-1;2;ASEMaterialInspector;0;6;ni/Universal/UI扫光;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;4;0;39;0
WireConnection;4;2;43;0
WireConnection;5;1;4;0
WireConnection;41;1;5;1
WireConnection;41;2;42;0
WireConnection;19;1;41;0
WireConnection;20;0;19;1
WireConnection;20;1;19;2
WireConnection;20;2;34;0
WireConnection;62;0;35;0
WireConnection;22;0;35;0
WireConnection;21;0;20;0
WireConnection;25;1;22;0
WireConnection;25;0;36;0
WireConnection;79;0;62;0
WireConnection;24;0;21;0
WireConnection;24;1;23;0
WireConnection;65;0;24;0
WireConnection;65;1;79;0
WireConnection;26;0;24;0
WireConnection;26;1;25;0
WireConnection;28;0;26;0
WireConnection;56;0;65;0
WireConnection;57;0;56;0
WireConnection;29;0;28;0
WireConnection;30;0;29;0
WireConnection;58;0;57;0
WireConnection;82;0;81;1
WireConnection;82;1;81;2
WireConnection;82;2;34;0
WireConnection;60;0;58;0
WireConnection;31;0;30;0
WireConnection;59;0;60;0
WireConnection;59;1;32;0
WireConnection;70;0;82;0
WireConnection;70;1;71;0
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;69;0;59;0
WireConnection;69;1;33;0
WireConnection;69;2;70;0
WireConnection;80;1;33;0
WireConnection;80;0;69;0
WireConnection;2;0;1;0
WireConnection;54;0;80;0
WireConnection;54;1;55;0
WireConnection;50;0;2;4
WireConnection;50;1;54;0
WireConnection;50;2;51;0
WireConnection;44;0;2;0
WireConnection;44;1;50;0
WireConnection;52;0;44;0
WireConnection;52;1;53;0
WireConnection;112;0;52;0
ASEEND*/
//CHKSM=8FEFFABB04FFAD1ECCE2E9C7DFBBEF26E29439C2