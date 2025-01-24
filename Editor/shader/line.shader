// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ni/Built-In/line "
{
	Properties
	{
		_outline("# 轮廓线", Float) = 0
		[HDR]_OutlineColor("轮廓线颜色", Color) = (0.8113208,0,0,0)
		_OutlineWidth("轮廓线宽度", Float) = 0
		_PBR("# PBR", Float) = 0
		_Albedo("Albedo &&", 2D) = "white" {}
		[HDR]_Color("Color", Color) = (0.9339623,0.4976861,0,1)
		_Normal("Normal &&", 2D) = "white" {}
		_NormalIntensity("Normal Intensity", Float) = 0
		_Maskmap("Mask map &", 2D) = "white" {}
		_DRAWERMinMax_Metallicx_Metallicy("!DRAWER MinMax _Metallic.x _Metallic.y", Float) = 0
		_DRAWERMinMax_Smoothnessx_Smoothnessy("!DRAWER MinMax _Smoothness.x _Smoothness.y", Float) = 0
		_DRAWERMinMax_AOx_AOy("!DRAWER MinMax _AO.x _AO.y", Float) = 0
		_Metallic("Metallic", Vector) = (0,1,0,0)
		_Smoothness("Smoothness", Vector) = (0,1,0,0)
		_AO("AO", Vector) = (0,1,0,0)
		_TilingOffset("Tiling and Offset &", Vector) = (0,0,0,0)
		_liuguangcanshu("# 流光参数", Float) = 0
		[HDR]_color("流光颜色", Color) = (1.811765,1.043137,0.1333333,1)
		_GlowIntensity("发光强度", Float) = 1
		_XY("方向（0：X轴，1：Y轴）", Range( 0 , 1)) = 0
		_Count("段数", Float) = 3
		_width("宽度", Float) = 6.01
		_speed("速度", Float) = 1.4
		_pengzhang("膨胀", Range( 0 , 1)) = 0
		_REF_lineMask("!REF _lineMask", Float) = 0
		[Toggle(_LINEMASK_ON)] _lineMask("lineMask", Float) = 0
		[Toggle(_FANXIANG_ON)] _fanxiang("反向线条生长 [_lineMask]", Float) = 0
		_mask("线条生长 [_lineMask]", Float) = 0.6784133
		_REF_uvOffset("!REF _uvOffset", Float) = 0
		[Toggle(_UVOFFSET_ON)] _uvOffset("uvOffset", Float) = 0
		_UVoffset("uv位移 [_uvOffset]", Float) = 0
		_toumingdu1("# 透明度", Float) = 0
		_Emssion("流光显示", Range( 0 , 1)) = 0
		_Opacity("透明度(分段）", Range( 0 , 1)) = 0
		_toumingdu("透明度（整体）", Range( 0 , 1)) = 0
		_jianbianff("# 渐变", Float) = 0
		_REF_GRADIENTCOLOR("!REF _GRADIENTCOLOR", Float) = 0
		_DRAWERGradientGenerator_GradientTexture_GRADIENTCOLOR("!DRAWER GradientGenerator _GradientTexture [_GRADIENTCOLOR]", Float) = 0
		[Toggle(_GRADIENTCOLOR_ON)] _GRADIENTCOLOR("老夫要的渐变模式", Float) = 0
		_GradientTexture("这才叫渐变", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0"}
		ZWrite On
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog alpha:fade  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float outlineVar = _OutlineWidth;
			v.vertex.xyz *= ( 1 + outlineVar);
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _OutlineColor.rgb;
			o.Alpha = _OutlineColor.a;
		}
		ENDCG
		

		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#pragma shader_feature_local _UVOFFSET_ON
		#pragma shader_feature_local _GRADIENTCOLOR_ON
		#pragma shader_feature_local _LINEMASK_ON
		#pragma shader_feature_local _FANXIANG_ON
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _DRAWERGradientGenerator_GradientTexture_GRADIENTCOLOR;
		uniform float _toumingdu1;
		uniform float _DRAWERMinMax_Smoothnessx_Smoothnessy;
		uniform float _liuguangcanshu;
		uniform float _PBR;
		uniform float _DRAWERMinMax_Metallicx_Metallicy;
		uniform float _REF_uvOffset;
		uniform float _DRAWERMinMax_AOx_AOy;
		uniform float _outline;
		uniform float _REF_lineMask;
		uniform float _REF_GRADIENTCOLOR;
		uniform float _jianbianff;
		uniform float _XY;
		uniform float _Count;
		uniform float _speed;
		uniform float _UVoffset;
		uniform float _width;
		uniform float _pengzhang;
		uniform sampler2D _Normal;
		uniform float4 _TilingOffset;
		uniform float _NormalIntensity;
		uniform float4 _Color;
		uniform sampler2D _Albedo;
		uniform float4 _color;
		uniform float _Emssion;
		uniform sampler2D _GradientTexture;
		uniform float _GlowIntensity;
		uniform sampler2D _Maskmap;
		uniform float2 _Metallic;
		uniform float2 _Smoothness;
		uniform float2 _AO;
		uniform float _Opacity;
		uniform float _toumingdu;
		uniform float _mask;
		uniform float4 _OutlineColor;
		uniform float _OutlineWidth;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float lerpResult2 = lerp( v.texcoord.xy.x , v.texcoord.xy.y , _XY);
			float mulTime26 = _Time.y * _speed;
			#ifdef _UVOFFSET_ON
				float staticSwitch151 = _UVoffset;
			#else
				float staticSwitch151 = mulTime26;
			#endif
			float saferPower32 = abs( ( abs( ( frac( ( ( lerpResult2 * _Count ) + staticSwitch151 ) ) - 0.5 ) ) * 2.0 ) );
			float temp_output_32_0 = pow( saferPower32 , _width );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 objToWorldDir127 = mul( unity_ObjectToWorld, float4( ase_vertexNormal, 0 ) ).xyz;
			float3 normalizeResult60 = normalize( objToWorldDir127 );
			v.vertex.xyz += ( ( temp_output_32_0 * _pengzhang * normalizeResult60 ) + 0 );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult182 = (float2(_TilingOffset.x , _TilingOffset.y));
			float2 appendResult184 = (float2(_TilingOffset.z , _TilingOffset.w));
			float2 uv_TexCoord185 = i.uv_texcoord * appendResult182 + appendResult184;
			o.Normal = UnpackScaleNormal( tex2D( _Normal, uv_TexCoord185 ), _NormalIntensity );
			o.Albedo = ( _Color * tex2D( _Albedo, uv_TexCoord185 ) ).rgb;
			float lerpResult2 = lerp( i.uv_texcoord.x , i.uv_texcoord.y , _XY);
			float mulTime26 = _Time.y * _speed;
			#ifdef _UVOFFSET_ON
				float staticSwitch151 = _UVoffset;
			#else
				float staticSwitch151 = mulTime26;
			#endif
			float saferPower32 = abs( ( abs( ( frac( ( ( lerpResult2 * _Count ) + staticSwitch151 ) ) - 0.5 ) ) * 2.0 ) );
			float temp_output_32_0 = pow( saferPower32 , _width );
			float4 lerpResult133 = lerp( _color , float4( 0,0,0,0 ) , _Emssion);
			float2 temp_cast_1 = (lerpResult2).xx;
			#ifdef _GRADIENTCOLOR_ON
				float4 staticSwitch197 = tex2D( _GradientTexture, temp_cast_1 );
			#else
				float4 staticSwitch197 = lerpResult133;
			#endif
			o.Emission = ( temp_output_32_0 * staticSwitch197 * _GlowIntensity ).rgb;
			float4 tex2DNode87 = tex2D( _Maskmap, uv_TexCoord185 );
			o.Metallic = ( tex2DNode87.r * _Metallic ).x;
			o.Smoothness = ( tex2DNode87.a * _Smoothness ).x;
			float4 color92 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float4 temp_cast_5 = (tex2DNode87.g).xxxx;
			float4 lerpResult90 = lerp( color92 , temp_cast_5 , float4( _AO, 0.0 , 0.0 ));
			o.Occlusion = lerpResult90.r;
			float lerpResult52 = lerp( _Color.a , temp_output_32_0 , _Opacity);
			float temp_output_61_0 = ( lerpResult52 * ( 1.0 - _toumingdu ) );
			float lerpResult203 = lerp( i.uv_texcoord.x , i.uv_texcoord.y , _XY);
			#ifdef _FANXIANG_ON
				float staticSwitch207 = lerpResult203;
			#else
				float staticSwitch207 = ( 1.0 - lerpResult203 );
			#endif
			#ifdef _LINEMASK_ON
				float staticSwitch208 = step( staticSwitch207 , _mask );
			#else
				float staticSwitch208 = temp_output_61_0;
			#endif
			o.Alpha = ( temp_output_61_0 * staticSwitch208 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.0
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
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
	CustomEditor "Needle.MarkdownShaderGUI"
}
/*ASEBEGIN
Version=18935
7;48;1920;971;-1387.066;799.1387;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;166;-2005.573,-662.5009;Inherit;False;2038.8;550.1353;line;18;27;121;106;105;2;109;110;107;108;151;26;143;28;142;33;32;1;3;;1,0.1017451,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1977.573,-298.5421;Inherit;False;Property;_XY;方向（0：X轴，1：Y轴）;19;0;Create;False;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1962.056,-623.3623;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-1420.572,-338.3656;Inherit;False;Property;_speed;速度;22;0;Create;False;0;0;0;False;0;False;1.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2;-1700.866,-614.6187;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;-1249.322,-377.093;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-1219.931,-283.5753;Inherit;False;Property;_UVoffset;uv位移 [_uvOffset];30;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;142;-1418.884,-434.6158;Inherit;False;Property;_Count;段数;20;0;Create;False;0;0;0;False;0;False;3;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;105;-1393.734,-559.1742;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1140.631,-578.3046;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;151;-1039.928,-445.2628;Inherit;False;Property;_uvOffset;uvOffset;29;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;-844.4321,-593.2612;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;106;-717.3451,-612.5009;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-753.8864,-476.3004;Inherit;False;Constant;_Float0;Float 0;16;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;107;-580.5363,-608.5967;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;109;-393.4321,-602.8898;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;202;1053.079,45.45645;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-273.4186,-603.9025;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;203;1350.117,11.98524;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;172;27.70819,546.9315;Inherit;False;1689.291;1087.112;PBR_Texture;17;180;184;182;185;86;90;95;167;89;92;170;96;85;168;87;169;39;;1,0.9357363,0.6650944,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-582.3001,-428.2208;Inherit;False;Property;_width;宽度;21;0;Create;False;0;0;0;False;0;False;6.01;5.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;32;-143.7721,-483.0869;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;607.4047,-186.8778;Inherit;True;Property;_Opacity;透明度(分段）;33;0;Create;False;0;0;0;False;0;False;0;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;205;1530.668,-17.72139;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;180;22.32595,1039.987;Inherit;False;Property;_TilingOffset;Tiling and Offset &;15;0;Create;False;0;0;0;True;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;130;1805.529,-749.7291;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;588.0345,111.6458;Inherit;True;Property;_toumingdu;透明度（整体）;34;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;688.1836,596.9315;Inherit;False;Property;_Color;Color;5;1;[HDR];Create;True;0;0;0;False;0;False;0.9339623,0.4976861,0,1;0.4674262,0.7264634,0.9811321,0.01568628;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;52;1138.794,-256.6261;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;184;253.0535,1161.866;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;182;244.6715,1014.522;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;132;1295.137,-901.7093;Inherit;False;Property;_Emssion;流光显示;32;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;207;1665.599,50.96905;Inherit;False;Property;_fanxiang;反向线条生长 [_lineMask];26;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;201;1632.578,226.5264;Inherit;True;Property;_mask;线条生长 [_lineMask];27;0;Create;False;0;0;0;False;0;False;0.6784133;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;1360.608,-1157.747;Inherit;False;Property;_color;流光颜色;17;1;[HDR];Create;False;0;0;0;False;0;False;1.811765,1.043137,0.1333333,1;126.5072,33.7794,9.935119,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;63;1118.97,-91.80746;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;127;2037.146,-755.4644;Inherit;False;Object;World;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;60;2331.562,-750.8875;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;57;2085.259,-566.8057;Inherit;False;Property;_pengzhang;膨胀;23;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;133;1641.96,-1154.096;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;185;466.5113,1037.412;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;200;1947.675,48.1757;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;1414.673,-234.8746;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;195;878.2228,-1162.464;Inherit;True;Property;_GradientTexture;这才叫渐变;39;0;Create;False;0;0;0;True;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;153;2433.211,-532.124;Inherit;False;Property;_OutlineColor;轮廓线颜色;1;1;[HDR];Create;False;0;0;0;False;0;False;0.8113208,0,0,0;0.8113208,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;154;2472.46,-320.1092;Inherit;False;Property;_OutlineWidth;轮廓线宽度;2;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;87;955.5957,1014.177;Inherit;True;Property;_Maskmap;Mask map &;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;197;1817.695,-982.7407;Inherit;False;Property;_GRADIENTCOLOR;老夫要的渐变模式;38;0;Create;False;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;92;1064.565,1383.644;Inherit;False;Constant;_Color0;Color 0;14;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;169;1087.774,1243.251;Inherit;False;Property;_Smoothness;Smoothness;13;0;Create;True;0;0;0;False;0;False;0,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;170;1360.827,1392.142;Inherit;False;Property;_AO;AO;14;0;Create;True;0;0;0;False;0;False;0,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;208;2066.563,-81.14662;Inherit;False;Property;_lineMask;lineMask;25;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;85;657.7819,785.7542;Inherit;True;Property;_Albedo;Albedo &&;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;168;1292.088,973.2175;Inherit;False;Property;_Metallic;Metallic;12;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;2592.352,-661.3234;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OutlineNode;152;2764.402,-508.597;Inherit;False;1;True;Transparent;1;0;Off;True;True;True;True;0;False;-1;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;122;2081.056,-889.2803;Inherit;False;Property;_GlowIntensity;发光强度;18;0;Create;False;0;0;0;False;0;False;1;10.99;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;1067.331,889.9671;Inherit;False;Property;_NormalIntensity;Normal Intensity;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;199;773.3274,-951.5342;Inherit;False;Property;_jianbianff;# 渐变;35;0;Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-642.6844,-56.26011;Inherit;False;Property;_REF_uvOffset;!REF _uvOffset;28;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;190;3239.9,-669.1853;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-346.9201,177.0855;Inherit;False;Property;_outline;# 轮廓线;0;0;Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-665.3585,29.0248;Inherit;False;Property;_DRAWERMinMax_AOx_AOy;!DRAWER MinMax _AO.x _AO.y;11;0;Create;True;0;0;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;1518.913,924.2419;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-358.9812,-60.03207;Inherit;False;Property;_PBR;# PBR;3;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-356.5183,89.3257;Inherit;False;Property;_toumingdu1;# 透明度;31;0;Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;-669.0529,176.3301;Inherit;False;Property;_DRAWERMinMax_Smoothnessx_Smoothnessy;!DRAWER MinMax _Smoothness.x _Smoothness.y;10;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;174;-361.6145,15.43002;Inherit;False;Property;_liuguangcanshu;# 流光参数;16;0;Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;95;1331.758,708.5583;Inherit;True;Property;_Normal;Normal &&;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;2300.892,-75.5271;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;90;1534.999,1228.876;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;194;472.9959,-1146.857;Inherit;False;Property;_DRAWERGradientGenerator_GradientTexture_GRADIENTCOLOR;!DRAWER GradientGenerator _GradientTexture [_GRADIENTCOLOR];37;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;1304.338,1234.543;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;2321.398,-1002.647;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;1031.608,690.5604;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-667.1937,102.4138;Inherit;False;Property;_DRAWERMinMax_Metallicx_Metallicy;!DRAWER MinMax _Metallic.x _Metallic.y;9;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;198;494.5933,-959.4189;Inherit;False;Property;_REF_GRADIENTCOLOR;!REF _GRADIENTCOLOR;36;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;209;-52.29199,-47.66168;Inherit;False;Property;_REF_lineMask;!REF _lineMask;24;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3887.128,-639.5738;Float;False;True;-1;4;Needle.MarkdownShaderGUI;0;0;Standard;ni/Built-In/line ;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;1;0,0,0,0;VertexScale;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;1
WireConnection;2;1;1;2
WireConnection;2;2;3;0
WireConnection;26;0;28;0
WireConnection;105;0;2;0
WireConnection;27;0;105;0
WireConnection;27;1;142;0
WireConnection;151;1;26;0
WireConnection;151;0;143;0
WireConnection;121;0;27;0
WireConnection;121;1;151;0
WireConnection;106;0;121;0
WireConnection;107;0;106;0
WireConnection;107;1;108;0
WireConnection;109;0;107;0
WireConnection;110;0;109;0
WireConnection;203;0;202;1
WireConnection;203;1;202;2
WireConnection;203;2;3;0
WireConnection;32;0;110;0
WireConnection;32;1;33;0
WireConnection;205;0;203;0
WireConnection;52;0;39;4
WireConnection;52;1;32;0
WireConnection;52;2;43;0
WireConnection;184;0;180;3
WireConnection;184;1;180;4
WireConnection;182;0;180;1
WireConnection;182;1;180;2
WireConnection;207;1;205;0
WireConnection;207;0;203;0
WireConnection;63;0;62;0
WireConnection;127;0;130;0
WireConnection;60;0;127;0
WireConnection;133;0;36;0
WireConnection;133;2;132;0
WireConnection;185;0;182;0
WireConnection;185;1;184;0
WireConnection;200;0;207;0
WireConnection;200;1;201;0
WireConnection;61;0;52;0
WireConnection;61;1;63;0
WireConnection;195;1;2;0
WireConnection;87;1;185;0
WireConnection;197;1;133;0
WireConnection;197;0;195;0
WireConnection;208;1;61;0
WireConnection;208;0;200;0
WireConnection;85;1;185;0
WireConnection;56;0;32;0
WireConnection;56;1;57;0
WireConnection;56;2;60;0
WireConnection;152;0;153;0
WireConnection;152;2;153;4
WireConnection;152;1;154;0
WireConnection;190;0;56;0
WireConnection;190;1;152;0
WireConnection;167;0;87;1
WireConnection;167;1;168;0
WireConnection;95;1;185;0
WireConnection;95;5;96;0
WireConnection;204;0;61;0
WireConnection;204;1;208;0
WireConnection;90;0;92;0
WireConnection;90;1;87;2
WireConnection;90;2;170;0
WireConnection;89;0;87;4
WireConnection;89;1;169;0
WireConnection;24;0;32;0
WireConnection;24;1;197;0
WireConnection;24;2;122;0
WireConnection;86;0;39;0
WireConnection;86;1;85;0
WireConnection;0;0;86;0
WireConnection;0;1;95;0
WireConnection;0;2;24;0
WireConnection;0;3;167;0
WireConnection;0;4;89;0
WireConnection;0;5;90;0
WireConnection;0;9;204;0
WireConnection;0;11;190;0
ASEEND*/
//CHKSM=BBB8160C06A3EB2BAA50FB49E7CEC9964D083B96