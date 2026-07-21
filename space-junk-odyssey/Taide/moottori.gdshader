shader_type spatial;
render_mode unshaded;

uniform float haihtuminen : hint_range(0.1, 10.0) = 1.0;
uniform float uv_keski = 0.5;

uniform sampler2D noise_tekstuuri : filter_linear_mipmap, repeat_enable;
uniform vec2 noise_suunta = vec2(0.0, 0.5);
uniform vec2 noise_skaala = vec2(1.0, 2.0);
uniform float noise_voima : hint_range(0.0, 2.0) = 0.5;

uniform vec4 paavari : source_color = vec4(0.0, 0.8, 1.0, 1.0);
uniform float neon : hint_range(0.0, 15.0) = 3.0;

uniform float fresnel_voima : hint_range(0.0, 10.0) = 1.5;

void fragment(){
	vec2 noise_uv = (UV * noise_skaala) + (noise_suunta * TIME);
	float noise_arvo = texture(noise_tekstuuri, noise_uv).r;
	float gradientti = (UV.y - uv_keski);
	gradientti += (noise_arvo - 0.5) * noise_voima;
	
	float pohja_alpha = pow(clamp(gradientti, 0.0, 1.0), haihtuminen);
	float fresnel = pow(clamp(dot(NORMAL, VIEW), 0.0, 1.0), fresnel_voima);
	ALPHA = clamp(pohja_alpha * fresnel, 0.0, 1.0);
	
	vec3 vari = paavari.rgb;
	vari = mix(paavari.rgb, vec3(1.0), pohja_alpha);
	ALBEDO = vari * neon;
}