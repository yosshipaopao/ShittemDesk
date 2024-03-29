shader_type sky;

group_uniforms sky;
	uniform vec3 day_top_color : source_color;
	uniform vec3 day_horizon_color : source_color;
	uniform vec3 sunset_top_color : source_color;
	uniform vec3 sunset_horizon_color : source_color;
	uniform vec3 night_top_color : source_color;
	uniform vec3 night_horizon_color : source_color;
	uniform float horizon_height : hint_range(0.0, 2.0) = 0.05;
group_uniforms sun;
	uniform vec3 sun_color : source_color = vec3( 10.0, 8.0, 1.0 );
	uniform vec3 sun_sunset_color : source_color = vec3( 10.0, 0.0, 0.0 );
	uniform float sun_size : hint_range( 0.01, 1.0 ) = 0.2;
	uniform float sun_blur : hint_range( 0.01, 20.0 ) = 10.0;
group_uniforms stars;
	uniform sampler2D star_noise_1 :filter_linear_mipmap ;
	uniform sampler2D star_noise_2 :filter_linear_mipmap ;
group_uniforms clouds;
	uniform sampler2D cloud_noise_1 :filter_linear_mipmap ;
	uniform sampler2D cloud_noise_2 :filter_linear_mipmap ;
	uniform vec2 cloud_direction_1 = vec2(2,0);
	uniform vec2 cloud_direction_2 = vec2(2,0);
	uniform float cloud_scale = 0.15;
	uniform float cloud_dist :hint_range(-1.0, 1.0, 0.001) = 0.5;
	uniform float cloud_mix = 0.5 ;
group_uniforms animate;
	uniform float time : hint_range(0.0, 1.0);
	uniform float cloud_time_scale: hint_range(0.0, 1.0, 0.001) = 0.025;
	uniform float sunset_duration : hint_range(0.0, 1.0) = 0.2;

void sky() {
	// -1 ~ 0 -> night , 0 ~ 1 -> mornig
	float light_time = time * 4.0;
	if(light_time > 2.0)light_time = 4.0 - light_time;
	// 0.0 ~ 0.5 -> night , 0.5 ~ 1.0 -> mornig
	float _time = light_time - 1.0;
	light_time /= 2.0;
	
	float energy = clamp(LIGHT0_ENERGY + LIGHT1_ENERGY , 0 , 1);
	// sky
	vec3 top_color = mix(night_top_color,day_top_color,light_time);
	vec3 horizon_color = mix(night_horizon_color,day_horizon_color,light_time);
	float sky_col = clamp(EYEDIR.y / horizon_height, 0.0 , 1.0);
	vec3 nomal_col = mix(horizon_color,top_color,sky_col);
	float sunset_time = (sunset_duration - min(abs(_time),sunset_duration)) * (1.0 / sunset_duration);
	vec3 sunset_col = mix(sunset_horizon_color , sunset_top_color , sky_col);
	vec3 final_col = mix(nomal_col , sunset_col , sunset_time);	
	COLOR = final_col * energy;
	/// cloud
	if(EYEDIR.y > 0.0){
		float cloud_time = TIME * cloud_time_scale;
		vec2 sky_uv = EYEDIR.xz / EYEDIR.y;
		vec3 clouds_col = texture(cloud_noise_1 ,sky_uv * cloud_scale + cloud_direction_1 * cloud_time).rgb - texture(cloud_noise_2 ,sky_uv * cloud_scale + cloud_direction_2 * cloud_time).rgb;
		clouds_col -= smoothstep(0.0,EYEDIR.y,cloud_dist);
		clouds_col = clamp(clouds_col,0,1);
		COLOR += clouds_col * 0.5 * energy;
	}
	// sun
	if( LIGHT0_ENABLED ){
		float _sun_distance = clamp(distance( EYEDIR, LIGHT0_DIRECTION ) ,0.0 , sun_size) ;
		vec3 sun_col = mix(sun_color , sun_sunset_color , sunset_time);
		COLOR += clamp(vec3((-_sun_distance + sun_size)*sun_blur),0.0,1.0) * sun_col * LIGHT0_ENERGY;
	}
	if( LIGHT1_ENABLED ){
		float _moon_distance = clamp(distance( EYEDIR, LIGHT1_DIRECTION ) ,0.0 , sun_size) ;
		vec3 sun_col = mix(sun_color , sun_sunset_color , sunset_time);
		COLOR += clamp(vec3((-_moon_distance + sun_size)*sun_blur),0.0,1.0) * sun_col * LIGHT1_ENERGY;
	}
	// stars
	if( EYEDIR.y > 0.2 && _time < 0.0){
		float _stars_speed_cos = cos( TIME * 0.005 );
		float _stars_speed_sin = sin( TIME * 0.005 );
		vec2 _sky_uv = EYEDIR.xz / sqrt( EYEDIR.y );
		vec2 _stars_uv = vec2(
			_sky_uv.x * _stars_speed_cos - _sky_uv.y * _stars_speed_sin,
			_sky_uv.x * _stars_speed_sin + _sky_uv.y * _stars_speed_cos
		) *  1.0;
		float stars_texture = texture(star_noise_1 ,_stars_uv).x - texture(star_noise_2 ,_stars_uv).x;
		if(stars_texture > .6 )COLOR += stars_texture * -LIGHT0_DIRECTION.y * 2.0;
	}
}
