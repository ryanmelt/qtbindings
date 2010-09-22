#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require './Params'

class Camera

    attr_accessor :position, :rotation, :zoom

    def initialize
	@position = Point.new($PARAMS['camera_x'],
			      $PARAMS['camera_y'],
			      $PARAMS['camera_z'])
	@rotation = Point.new($PARAMS['camera_rot_x'],
			      $PARAMS['camera_rot_y'],
			      $PARAMS['camera_rot_z'])
	@zoom = $PARAMS['camera_zoom']
    end
end

