shader_type canvas_item;

global uniform vec2 light_direction; // Direction of the light
global uniform float light_strength;
global uniform float ambient;
global uniform vec4 light_color;
global uniform vec4 modulate_color;


uniform sampler2D normal_map : hint_normal;

void fragment() {
    vec4 albedo_color = texture(TEXTURE, UV);
    vec3 normal = texture(normal_map, UV).rgb;

    // Convert normal map from [0,1] to [-1,1]
    normal = normalize(normal * 2.0 - 1.0);

    // Light direction in 3D
    vec3 light_dir = normalize(vec3(light_direction, 1.0));

    // Diffuse lighting
    float diff = max(dot(normal, light_dir), 0.0);

    // Final lighting strength
    float lighting = ambient + diff * light_strength;

    // Apply lighting, light color, and modulate
    vec3 final_color = albedo_color.rgb * lighting * light_color.rgb * modulate_color.rgb;
    float final_alpha = albedo_color.a * modulate_color.a;

    COLOR = vec4(final_color, final_alpha);
}
