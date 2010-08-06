#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require 'singleton'

$PARAMS = {
    'world_sleep_millis' => 75,
    'world_width' => 400,
    'world_height' => 400,
    'world_depth' => 400,
    'window_width' => 500,
    'window_height' => 500,
    'flock_boids' => 10,
    'boid_max_speed' => 30,
    'boid_bounds_limit_pull' => 5,
    'boid_bounds_limit_above_ground_level' => 5,
    'boid_wing_length' => 10,
    'boid_personal_space_dist' => 12,
    'boid_square_of_personal_space_dist' => 144,
    'boid_max_perching_turns' => 150,
    'boid_perch_wing_flap_percent' => 30,
    'cloud_count' => 10,
    'cloud_min_speed' => 2,
    'cloud_max_speed' => 50,
    'cloud_min_bubbles' => 3,
    'cloud_max_bubbles' => 10,
    'cloud_max_bubble_radius' => 10,
    'cloud_min_altitude' => 250,
    'camera_x' => 0,
    'camera_y' => 0,
    'camera_z' => 60,
    'camera_rot_x' => 50,
    'camera_rot_y' => 10,
    'camera_rot_z' => 0,
    'camera_zoom' => 1
}

class Params

    @@reals = %w(
world_width
world_height
world_depth
boid_max_speed
boid_bounds_limit_pull
boid_bounds_limit_above_ground_level
boid_wing_length
boid_personal_space_dist
boid_square_of_personal_space_dist
cloud_min_speed
cloud_max_speed
cloud_max_bubble_radius
cloud_min_altitude
camera_x
camera_y
camera_z
camera_rot_x
camera_rot_y
camera_rot_z
camera_zoom
)

    def Params.readParamsFromFile(paramFileName)
	File.open(File.join("..", paramFileName)).each { | line |
	    line.chomp!
	    next if line.empty? || line =~ /^#/

	    key, value = line.split(/\s*=\s*/)
	    next unless value
	    key.downcase!()
	    key.gsub!(/\./, '_')

	    isReal = @@reals.include?(key)
	    value = value.to_f if isReal
	    value = value.to_i if !isReal
	    $PARAMS[key] = value
	}
	$PARAMS['boid_square_of_personal_space_dist'] =
	    $PARAMS['boid_personal_space_dist'] *
	    $PARAMS['boid_personal_space_dist']
    end

end
