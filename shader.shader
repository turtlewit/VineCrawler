shader_type spatial;
//render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,skip_vertex_transform;
render_mode depth_draw_opaque,cull_back,diffuse_burley, skip_vertex_transform, unshaded;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform sampler2D alpha_mask;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform sampler2D texture_metallic : hint_white;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_white;
uniform vec4 roughness_texture_channel;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

varying vec4 VAR1;

void vertex() {
	vec4 snap_to_pixel = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
	vec4 norm = MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
	
	vec4 vert = snap_to_pixel;
	vert.xyz = snap_to_pixel.xyz / snap_to_pixel.w;
	vert.x = floor(160.0 * vert.x) / 160.0;
	vert.y = floor(120.0 * vert.y) / 120.0;
	vert.xyz *= snap_to_pixel.w;
	VERTEX = (INV_PROJECTION_MATRIX * vert).xyz;
	//VERTEX = (PROJECTION_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float dist = length(norm);
	//UV *= (dist + (vert.w) / dist / 2.0) ;
	
	UV=UV*uv1_scale.xy+uv1_offset.xy;
	VAR1 = vec4(UV * VERTEX.z, VERTEX.z, 0);
}


//float4 frag(v2f IN) : COLOR
//	{
//		half4 c = tex2D(_MainTex, IN.uv_MainTex / IN.normal.r)*IN.color;
//		half4 color = c*(IN.colorFog.a);
//		color.rgb += IN.colorFog.rgb*(1 - IN.colorFog.a);
//		return color;
//}
void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,VAR1.xy / VAR1.z);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	//METALLIC = metallic_tex * metallic;
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	//ROUGHNESS = roughness_tex * roughness;
	//SPECULAR = specular;
	
}

