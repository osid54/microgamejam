shader_type canvas_item;
const float seed_variation = 0.0;
varying float elapsed_time;

void vertex() {
	elapsed_time = TIME;
}

float dot2(vec2 x) {
	return dot(x, x);
}

float rand(vec2 x) {
    return fract(cos(mod(dot(x, vec2(13.9898, 8.141)), 3.14)) * 43758.5453);
}

vec2 rand2(vec2 x) {
    return fract(cos(mod(vec2(dot(x, vec2(13.9898, 8.141)),
						      dot(x, vec2(3.4562, 17.398))), vec2(3.14))) * 43758.5453);
}

vec3 rand3(vec2 x) {
    return fract(cos(mod(vec3(dot(x, vec2(13.9898, 8.141)),
							  dot(x, vec2(3.4562, 17.398)),
                              dot(x, vec2(13.254, 5.867))), vec3(3.14))) * 43758.5453);
}

vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float param_rnd(float minimum, float maximum, float seed) {
	return minimum+(maximum-minimum)*rand(vec2(seed));
}

float param_rndi(float minimum, float maximum, float seed) {
	return floor(param_rnd(minimum, maximum + 1.0, seed));
}float perlin(vec2 uv, vec2 size, int iterations, float persistence, float seed) {
	vec2 seed2 = rand2(vec2(seed, 1.0-seed));
	float rv = 0.0;
	float coef = 1.0;
	float acc = 0.0;
	for (int i = 0; i < iterations; ++i) {
		vec2 step = vec2(1.0)/size;
		vec2 xy = floor(uv*size);
		float f0 = rand(seed2+mod(xy, size));
		float f1 = rand(seed2+mod(xy+vec2(1.0, 0.0), size));
		float f2 = rand(seed2+mod(xy+vec2(0.0, 1.0), size));
		float f3 = rand(seed2+mod(xy+vec2(1.0, 1.0), size));
		vec2 mixval = smoothstep(0.0, 1.0, fract(uv*size));
		rv += coef * mix(mix(f0, f1, mixval.x), mix(f2, f3, mixval.x), mixval.y);
		acc += coef;
		size *= 2.0;
		coef *= persistence;
	}
	
	return rv / acc;
}
vec2 scale(vec2 uv, vec2 center, vec2 scale) {
	uv -= center;
	uv /= scale;
	uv += center;
	return uv;
}const float p_o9256_cx = 0.000000000;
const float p_o9256_cy = 0.000000000;
const float p_o9256_scale_x = 200.000000000;
const float p_o9256_scale_y = 200.000000000;
const float p_o9089_offset = 0.500000000;
const float p_o9257_brightness = 0.000000000;
const float p_o9257_contrast = 0.800000000;
const float p_o9255_x = 64.000000000;
const float p_o9255_y = 64.000000000;
const float p_o9255_c = 16.000000000;
const float p_o9255_d = 0.000000000;
const float p_o9122_angle = 0.000000000;
const float p_o9122_d = 0.030000000;
const float p_o9122_a = 0.000000000;
const float p_o9106_amount = 0.200000000;
const float p_o9106_eps = 0.100000000;
const float seed_o9254 = 0.222611755;
const float p_o9253_brightness = 0.000000000;
const float p_o9253_contrast = 2.000000000;
const float seed_o9110 = 0.000000000;
const float p_o9110_scale_x = 4.000000000;
const float p_o9110_scale_y = 4.000000000;
const float p_o9110_iterations = 3.000000000;
const float p_o9110_persistence = 0.500000000;
float o9106_input_d(vec2 uv, float _seed_variation_) {
float o9110_0_1_f = perlin(((uv)-vec2((elapsed_time*.01*param_rnd(-5, 5, (seed_o9254+fract(_seed_variation_))+-0.999990)), (elapsed_time*.01*param_rnd(-5, 5, (seed_o9254+fract(_seed_variation_))+16.000010)))), vec2(p_o9110_scale_x, p_o9110_scale_y), int(p_o9110_iterations), p_o9110_persistence, (seed_o9110+fract(_seed_variation_)));
vec4 o9253_0_1_rgba = vec4(clamp(vec4(vec3(o9110_0_1_f), 1.0).rgb*p_o9253_contrast+vec3(p_o9253_brightness)+0.5-p_o9253_contrast*0.5, vec3(0.0), vec3(1.0)), vec4(vec3(o9110_0_1_f), 1.0).a);
vec4 o9254_0_1_rgba = o9253_0_1_rgba;

return (dot((o9254_0_1_rgba).rgb, vec3(1.0))/3.0);
}
vec2 o9106_slope(vec2 uv, float epsilon, float _seed_variation_) {
	return vec2(o9106_input_d(fract(uv+vec2(epsilon, 0.0)), _seed_variation_)-o9106_input_d(fract(uv-vec2(epsilon, 0.0)), _seed_variation_), o9106_input_d(fract(uv+vec2(0.0, epsilon)), _seed_variation_)-o9106_input_d(fract(uv-vec2(0.0, epsilon)), _seed_variation_));
}const float seed_o9252 = 0.292009175;
const float p_o9252_scale_x = 16.000000000;
const float p_o9252_scale_y = 16.000000000;
const float p_o9252_iterations = 3.000000000;
const float p_o9252_persistence = 0.500000000;
float o9122_input_in(vec2 uv, float _seed_variation_) {
vec2 o9106_0_slope = o9106_slope((uv), p_o9106_eps, _seed_variation_);
vec2 o9106_0_warp = o9106_0_slope;float o9252_0_1_f = perlin(((uv)+p_o9106_amount*o9106_0_warp), vec2(p_o9252_scale_x, p_o9252_scale_y), int(p_o9252_iterations), p_o9252_persistence, (seed_o9252+fract(_seed_variation_)));
vec4 o9106_0_1_rgba = vec4(vec3(o9252_0_1_f), 1.0);

return (dot((o9106_0_1_rgba).rgb, vec3(1.0))/3.0);
}
const float seed_o9105 = 0.981263161;
float o9122_input_hm(vec2 uv, float _seed_variation_) {
float o9110_0_1_f = perlin(((uv)-vec2((elapsed_time*.01*param_rnd(-5, 5, (seed_o9105+fract(_seed_variation_))+-0.999990)), (elapsed_time*.01*param_rnd(-5, 5, (seed_o9105+fract(_seed_variation_))+16.000010)))), vec2(p_o9110_scale_x, p_o9110_scale_y), int(p_o9110_iterations), p_o9110_persistence, (seed_o9110+fract(_seed_variation_)));
vec4 o9253_0_1_rgba = vec4(clamp(vec4(vec3(o9110_0_1_f), 1.0).rgb*p_o9253_contrast+vec3(p_o9253_brightness)+0.5-p_o9253_contrast*0.5, vec3(0.0), vec3(1.0)), vec4(vec3(o9110_0_1_f), 1.0).a);
vec4 o9105_0_1_rgba = o9253_0_1_rgba;

return (dot((o9105_0_1_rgba).rgb, vec3(1.0))/3.0);
}
vec2 o9122_slope(vec2 uv, float epsilon, float _seed_variation_) {
	float dx = o9122_input_hm(fract(uv+vec2(epsilon, 0.0)), _seed_variation_)-o9122_input_hm(fract(uv-vec2(epsilon, 0.0)), _seed_variation_);
	float dy = o9122_input_hm(fract(uv+vec2(0.0, epsilon)), _seed_variation_)-o9122_input_hm(fract(uv-vec2(0.0, epsilon)), _seed_variation_);
	return cos(p_o9122_angle*0.01745329251)*vec2(dx, dy)+sin(p_o9122_angle*0.01745329251)*vec2(-dy, dx);
}

float o9122_dilate(vec2 uv, float _seed_variation_) {
	float e = 1.0/256.000000000;
	float v = 0.0;
	for (float x = 0.0; x <= p_o9122_d; x += e) {
		v = max(v, o9122_input_in(fract(uv), _seed_variation_)*(1.0-x/p_o9122_d*p_o9122_a));
		vec2 delta = o9122_slope(uv, 0.0001, _seed_variation_);
		uv += e*normalize(delta);
	}
	return v;
}const float p_o138867_repeat = 1.000000000;
const float p_o138867_rotate = 0.000000000;
const float p_o138867_gradient_0_pos = 0.000000000;
const vec4 p_o138867_gradient_0_col = vec4(0.003921569, 0.058823530, 0.003921569, 1.000000000);
const float p_o138867_gradient_1_pos = 0.595819991;
const vec4 p_o138867_gradient_1_col = vec4(0.035294119, 0.164705887, 0.035294119, 1.000000000);
const float p_o138867_gradient_2_pos = 1.000000000;
const vec4 p_o138867_gradient_2_col = vec4(0.043137256, 0.282352954, 0.043137256, 1.000000000);
vec4 o138867_gradient_gradient_fct(float x) {
  if (x < p_o138867_gradient_0_pos) {
    return p_o138867_gradient_0_col;
  } else if (x < p_o138867_gradient_1_pos) {
    return mix(p_o138867_gradient_0_col, p_o138867_gradient_1_col, ((x-p_o138867_gradient_0_pos)/(p_o138867_gradient_1_pos-p_o138867_gradient_0_pos)));
  } else if (x < p_o138867_gradient_2_pos) {
    return mix(p_o138867_gradient_1_col, p_o138867_gradient_2_col, ((x-p_o138867_gradient_1_pos)/(p_o138867_gradient_2_pos-p_o138867_gradient_1_pos)));
  }
  return p_o138867_gradient_2_col;
}

void fragment() {
float _seed_variation_ = seed_variation;
vec2 o9255_0_uv = floor(((scale((UV), vec2(0.5+p_o9256_cx, 0.5+p_o9256_cy), vec2(p_o9256_scale_x, p_o9256_scale_y)))*vec2(p_o9255_x, p_o9255_y)))+vec2(0.5);
vec3 o9255_0_dither = fract(vec3(dot(vec2(171.0, 231.0), o9255_0_uv))/vec3(103.0, 71.0, 97.0));
float o9122_0_1_f = o9122_dilate((o9255_0_uv/vec2(p_o9255_x, p_o9255_y)), _seed_variation_);
vec3 o9255_0_1_rgb = floor(vec3(o9122_0_1_f)*p_o9255_c+p_o9255_d*(o9255_0_dither-vec3(0.5)))/p_o9255_c;
vec4 o9257_0_1_rgba = vec4(clamp(vec4(o9255_0_1_rgb, 1.0).rgb*p_o9257_contrast+vec3(p_o9257_brightness)+0.5-p_o9257_contrast*0.5, vec3(0.0), vec3(1.0)), vec4(o9255_0_1_rgb, 1.0).a);
float o138867_0_r = 0.5+(cos(p_o138867_rotate*0.01745329251)*((vec2((dot((o9257_0_1_rgba).rgb, vec3(1.0))/3.0), p_o9089_offset)).x-0.5)+sin(p_o138867_rotate*0.01745329251)*((vec2((dot((o9257_0_1_rgba).rgb, vec3(1.0))/3.0), p_o9089_offset)).y-0.5))/(cos(abs(mod(p_o138867_rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);vec4 o138867_0_1_rgba = o138867_gradient_gradient_fct(fract(o138867_0_r*p_o138867_repeat));
vec4 o9089_0_1_rgba = o138867_0_1_rgba;
vec4 o9256_0_1_rgba = o9089_0_1_rgba;
COLOR = o9256_0_1_rgba;
}
