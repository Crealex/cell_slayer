extends TileMap

var size_map : Vector2i
var coin1 : Vector2i
var coin2 : Vector2i
var coin3 : Vector2i
var coin4 : Vector2i
var bord1 : Vector2i
var bord2 : Vector2i
var bord3 : Vector2i
var bord4 : Vector2i
var sol : Vector2i
var map_atlas


func init_map():
	
	var pos : Vector2i

	size_map = Vector2i(get_viewport_rect().size)
	size_map.x /= 48
	size_map.y /= 48
	map_atlas = 0
	coin1 = Vector2i(0, 0)
	coin2 = Vector2i(2, 0)
	coin3 = Vector2i(2, 2)
	coin4 = Vector2i(0, 2)
	bord1 = Vector2i(1, 0)
	bord2 = Vector2i(2, 1)
	bord3 = Vector2i(1, 2)
	bord4 = Vector2i(0, 1)
	sol = Vector2i(1, 1)

	for x in range(size_map.x):
		for y in range(size_map.y):
			pos = Vector2i(x, y)
			if (x > 0 and x < size_map.x - 1) and (y > 0 and y < size_map.y - 1):
				set_cell(0, pos, map_atlas, sol)
			if x == 0:
				set_cell(0, pos, map_atlas, bord4)
			if x == size_map.x -1:
				set_cell(0, pos, map_atlas, bord2)
			if y == 0:
				set_cell(0, pos, map_atlas, bord1)
			if y == size_map.y -1:
				set_cell(0, pos, map_atlas, bord3)
			if x == 0 and y == 0:
				set_cell(0, pos, map_atlas, coin1)
			if x == 0 and y == size_map.y -1:
				set_cell(0, pos, map_atlas, coin4)
			if x == size_map.x -1 and y == 0:
				set_cell(0, pos, map_atlas, coin2)
			if x == size_map.x -1 and y == size_map.y -1:
				set_cell(0, pos, map_atlas, coin3)
