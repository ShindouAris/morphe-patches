-----------------------------
-----------------------------
--                         --
--      DAY SCHEMA         -- 
--      Apr 20 2017        -- 
--                         -- 
-----------------------------
-----------------------------

-----------------------
-- Params/Color File --
-----------------------
-- A set of parameters for structure file. Mainly colors, but might define many other
-- things. This file does not have any pre-defined structure, only parameters defined 
-- under names structure fuke expects them to be found.

-- Local 'palette' (constants) for convinience
local Palette = {

	base_default = rgb(0x0095FF),
	black = rgb(0x000000),
	white = rgb(0xFFFFFF),
	red = rgb(0xFF0000),

	map_background = rgb(0xF7F8F5),
	map_missing = rgb(0xD9DEE2),

	labels = rgb(0x3B4248),
	labels_strong = rgb(0x161B1F),
	labels_bgcolor = rgb(0xFFFFFF),

	oneWay = rgba(0x30384077),
	points = rgb(0x829AC4),
	selection = rgb(0x00B7E8),

	-- Roads ------------------------

	freeways = rgb(0x5F6872),
	primary = rgb(0x79838D),
	secondary = rgb(0xA0A8AF),
	highways = rgb(0x8D969F),
	street = rgb(0xBBC2C8),
	private = rgb(0xC8CED3),
	trails4x4 = rgb(0xD7C48B),
  alleys = rgb(0xBBC5CE),

	-- Ramps & Exit ------------------------

	ramps = rgb(0x79838D),

	-- Parking ----------------------------

	parking = rgb(0xBDC6CC),
	parking_lots = rgb(0xE0E4E6),
	parking_lots_pins = rgb(0xC4D6E6),

	-- No-Auto ------------------------

	railroads = rgb(0x9EA5A9),
	ferry_stroke = rgb(0x238DAD),

	pedestrian = rgb(0xB7C2CB),
	trails = rgb(0xB7C2CB),
	walkway = rgb(0xB7C2CB),

	-- Areas ------------------------

	cities = rgb(0xF2F2ED),
	stations = rgb(0xD4DADD),
	parks = rgb(0xA3E2B2),
	sea = rgb(0x72C9EF),
	lakes = rgb(0x72C9EF),
	rivers = rgb(0x72C9EF),
  generic_event = rgba(0xE3740034),
  generic_event_light = rgba(0xE3740020),
  generic_event_ultra_light = rgba(0xE374000F),
  generic_event_ultra_strong = rgba(0xE3740060),
  

	label_station = rgb(0x59666D),
	label_cities = rgb(0x24323A),
	label_vegetation = rgb(0x087A32),
	label_water = rgb(0x064F91),
  label_generic_event = rgb(0xA84600),
  label_outline_generic_event = rgb(0xFFFFFF),

	-- Labels ------------------------

	ad_labels_color = rgb(0x565C61),
	ad_labels_outline_color = rgb(0xffffff),

	-- Others --------------------------

	navigation = rgb(0x6517D1),
	stop_point = rgb(0x9E42BE),
	shared = rgb(0x1BAB50),
	shared_stroke = rgb(0x118742),
	shared_stop = rgb(0x02B087),
  snail = rgb(0xD9BAFA),
  snail_via = rgb(0xDBB9E7),
  snail_share = rgb(0xC4FBD8),
  snail_via_share = rgb(0xC4FBD8),
  recording = rgb(0xFF0000),
  recorded = rgb(0x0000FF),
  detour = rgb(0xD5ACFF),
  detour_stroke = rgb(0xC088FF),

	alt_color_1 = rgb(0x00CF8A),
	alt_color_2 = rgb(0x1DC4FF),
	alt_color_3 = rgb(0xFF9600),
	alt_color_current = rgb(0x9C86FF),			

	carpool_ride_fill = rgb(0x00B6EA),
	carpool_ride_stroke = rgb(0x0089B0),
	carpool_direct_fill = rgb(0xD0E3E9),
	carpool_direct_stroke = rgb(0xB1CFD6),
 
  route_preview_unselected_fill = rgb(0xD5ACFF),
  route_preview_unselected_stroke = rgb(0xC088FF),

  traffic_route_light = rgb(0xFF9A4A),
  traffic_route_moderate = rgb(0xFF7A32),
  traffic_route_heavy = rgb(0xF04444),
  traffic_route_standstill = rgb(0xC9182B),
	traffic_route_closed_road = rgb(0x6D1017),	

	traffic_arrow_light = rgb(0xFF7A22),
	traffic_arrow_moderate = rgb(0xFF5F17),
	traffic_arrow_heavy = rgb(0xE11D2E),
	traffic_arrow_standstill = rgb(0xB70720),
	traffic_arrow_closed_road = rgb(0x101010),	


}

-- General params --------------------------------

Params = {
	Defaults = {
		font_size = 12,
		declutter_max = 2147483647,
	},
		
	--Example
	Street = {
		font_size = 17,
		declutter = 120,
	}
}

-- Helper functions -------------------------------------

--Transform color for off-navigation rout color
local function traffic_offroute_color(orig_color)
	return color.desaturate(0.45,color.lighten(0.3,orig_color))
end

--Transform traffic color for showing on an unselected-route
local function traffic_unselected_route_color(orig_color)
  return color.desaturate(0.17,color.darken(0.05,orig_color))
end

-- Colors -------------------------------------

Colors = {
	General = {
		global_color_mod = rgba(0xffffff40),
		map_background = Palette.map_background,
		missing = Palette.map_missing,
		labels_bgcolor = Palette.labels_bgcolor,

		map_selection_color = Palette.selection,
		map_one_way_color = Palette.oneWay,
    	map_points_color = Palette.points,

      -- Alt colors: { ALT_COLOR_1, ALT_COLOR_2, ALT_COLOR_3, CURRENT_ROUTE_COLOR }
      nav_alt_colors = { Palette.alt_color_1, Palette.alt_color_2, Palette.alt_color_3, Palette.alt_color_current },

		-- Traffic types:{LIGHT, MODERATE, HEAVY, STAND_STILL, UNUSED, CLOSED_ROAD}
		traffic_nav_route_colors = { Palette.traffic_route_light, Palette.traffic_route_moderate, Palette.traffic_route_heavy, Palette.traffic_route_standstill, rgb(0xE12D2D), Palette.traffic_route_closed_road },
		traffic_nav_arrow_colors = { Palette.traffic_arrow_light, Palette.traffic_arrow_moderate, Palette.traffic_arrow_heavy, Palette.traffic_arrow_standstill, rgb(0xbb0b0b), Palette.traffic_arrow_closed_road },

		traffic_route_colors = { 	traffic_offroute_color( Palette.traffic_route_light		), 
									traffic_offroute_color( Palette.traffic_route_moderate	), 
									traffic_offroute_color( Palette.traffic_route_heavy		), 
									traffic_offroute_color( Palette.traffic_route_standstill),
									traffic_offroute_color( rgb(0xE12D2D)					), 
									traffic_offroute_color( Palette.traffic_route_closed_road) },

		traffic_arrow_colors = { 	traffic_offroute_color( Palette.traffic_arrow_light		), 
									traffic_offroute_color( Palette.traffic_arrow_moderate	), 
									traffic_offroute_color( Palette.traffic_arrow_heavy		), 
									traffic_offroute_color( Palette.traffic_arrow_standstill), 
									traffic_offroute_color( rgb(0xbb0b0b)					), 
									traffic_offroute_color( Palette.traffic_arrow_closed_road) },
         
		traffic_unselected_route_colors = {   traffic_unselected_route_color( Palette.traffic_route_light    ),
									traffic_unselected_route_color( Palette.traffic_route_moderate  ),
									traffic_unselected_route_color( Palette.traffic_route_heavy    ),
									traffic_unselected_route_color( Palette.traffic_route_standstill),
									traffic_unselected_route_color( rgb(0xE12D2D)          ),
									traffic_unselected_route_color( Palette.traffic_route_closed_road) },

	},

	Defaults = {
		fill = Palette.base_default,
		strokes = Palette.black,
		labels = Palette.labels,
		labels_bgcolor = Palette.labels_bgcolor,
	},
	
	-- Roads -------------------------------------

	Freeways = {
		light_stroke = color.lighten(0.1,Palette.freeways),
		light_fill = color.lighten(0.15,Palette.freeways),
		light_label = color.lighten(0.1,Palette.labels),

		medium_stroke = Palette.freeways,
		medium_fill = color.lighten(0.1,Palette.freeways),
		medium_label = Palette.labels,

		strong_stroke = color.darken(0.1,Palette.freeways),
		strong_fill = Palette.freeways,
		strong_label = Palette.labels_strong,
	},

	Primary = {
		light_stroke = color.lighten(0.15,Palette.primary),
		light_fill = color.lighten(0.1,Palette.primary),
		light_label = color.lighten(0.1,Palette.labels),

		medium_stroke = Palette.primary,
		medium_fill = color.lighten(0.07,Palette.primary),
		medium_label = Palette.labels,

		strong_stroke = color.darken(0.1,Palette.primary),
		strong_fill = Palette.primary,
		strong_label = Palette.labels_strong,
	},

	Secondary = {
		light_stroke = color.lighten(0.1,Palette.secondary),
		light_fill = color.desaturate(0.01,color.lighten(0.07,Palette.secondary)),
		light_label = color.lighten(0.1,Palette.labels),

		medium_stroke = Palette.secondary,
		medium_fill = color.lighten(0.05,Palette.secondary),
		medium_label = Palette.labels,

		strong_stroke = color.darken(0.1,Palette.secondary),
		strong_fill = Palette.secondary,
		strong_label = Palette.labels_strong,
	},

	Highways = {
		light_stroke = color.darken(0.1,Palette.highways),
		light_fill = color.lighten(0.15,Palette.highways),
		light_label = color.lighten(0.1,Palette.labels),

		medium_stroke = Palette.highways,
		medium_fill = color.lighten(0.03,Palette.highways),
		medium_label = Palette.labels,

		strong_stroke = color.darken(0.1,Palette.highways),
		strong_fill = Palette.highways,
		strong_label = Palette.labels_strong,
	},

	Street = {
		light_stroke = color.darken(0.05,Palette.street),
		light_fill = color.lighten(0.1,Palette.street),
		light_label = color.lighten(0.1,Palette.labels),

		medium_stroke = Palette.street,
		medium_fill = color.lighten(0.02,Palette.street),
		medium_label = Palette.labels,

		strong_stroke = Palette.map_background,
		strong_fill = Palette.street,
		strong_label = Palette.labels_strong,
	},

	Private = {
		light_stroke = Palette.map_background,
		light_fill = color.lighten(0.1,Palette.private),
		light_label = color.lighten(0.1,Palette.labels),

		medium_stroke = Palette.map_background,
		medium_fill = color.lighten(0.05,Palette.private),
		medium_label = Palette.labels,

		strong_stroke = Palette.map_background,
		strong_fill = Palette.private,
		strong_label = Palette.labels_strong,
	},

	Trails4X4 = {
		light_stroke = color.darken(0.1,Palette.trails4x4),
		light_fill = color.lighten(0.2,Palette.trails4x4),
		light_label = color.lighten(0.1,Palette.labels),

		medium_stroke = Palette.trails4x4,
		medium_fill = color.lighten(0.05,Palette.trails4x4),
		medium_label = Palette.labels,

		strong_stroke = color.darken(0.1,Palette.trails4x4),
		strong_fill = Palette.trails4x4,
		strong_label = Palette.labels_strong,
	},

	--Ramps and Exits-------------------------------------

	Ramps = {
		light_stroke = Palette.ramps,
		light_fill = Palette.ramps,

		medium_stroke = Palette.ramps,
		medium_fill = color.lighten(0.02,Palette.ramps),

		strong_stroke = color.shiftHue(0.2,color.darken(0.15,Palette.ramps)),
		strong_fill = Palette.ramps,
	},

	Exit = {
		light_stroke = Palette.ramps,
		light_fill = Palette.ramps,

		medium_stroke = Palette.ramps,
		medium_fill = color.shiftHue(-0.2,color.lighten(0.15,Palette.ramps)),

		strong_stroke = color.shiftHue(0.2,color.darken(0.15,Palette.ramps)),
		strong_fill = Palette.ramps,
	},

	--Parking-------------------------------------

	Parking = {
		light_stroke = Palette.map_background,
		light_fill = color.lighten(0.1,Palette.parking),
		light_label = color.lighten(0.1,Palette.labels),

		medium_stroke = Palette.map_background,
		medium_fill = color.lighten(0.05,Palette.parking),
		medium_label = Palette.labels,

		strong_stroke = Palette.map_background,
		strong_fill = Palette.parking,
		strong_label = Palette.labels_strong,
	},


	ParkingLots = {
		light_fill = color.saturate(0.03,color.lighten(0.02,Palette.parking_lots)),
		strong_fill = Palette.parking_lots,		
	},


	ParkingLotsPins = {
		light_fill = color.saturate(0.03,color.lighten(0.02,Palette.parking_lots_pins)),
		strong_fill = Palette.parking_lots_pins,	
	},


   --Alleys-------------------------------------

   Alleys = {
      light_stroke = Palette.map_background,
      light_fill = color.lighten(0.1,Palette.alleys),
      light_label = color.lighten(0.1,Palette.labels),
      
      medium_stroke = Palette.map_background,
      medium_fill = color.shiftHue(-0.05,color.lighten(0.05,Palette.alleys)),
      medium_label = Palette.labels,
      
      strong_stroke = Palette.map_background,
      strong_fill = Palette.alleys,
      strong_label = Palette.labels_strong,
   },


	--No-Auto-------------------------------------


	Railroads = {
		light_stroke = color.lighten(0.13,Palette.railroads),
		light_fill = Palette.railroads,

		medium_stroke = color.lighten(0.07,Palette.railroads),
		medium_fill = Palette.railroads,

		strong_stroke = Palette.railroads,
		strong_fill = Palette.railroads,

		texture = "rail_pattern",
		-- shadow = Palette.base_default,
	},

	Ferry = {
		light_stroke = Palette.ferry_stroke,
		light_label = color.darken(0.05,Palette.label_water),

		medium_stroke = Palette.ferry_stroke,
		medium_label = color.darken(0.07,Palette.label_water),

		strong_stroke = Palette.ferry_stroke,
		strong_label = color.darken(0.1,Palette.label_water),

		texture = "longdash_pattern",
	},

	Pedestrian = {
		light_stroke = Palette.map_background,
		light_fill = color.lighten(0.07,Palette.pedestrian),
		light_label = color.lighten(0.1,Palette.labels),

		medium_stroke = Palette.map_background,
		medium_fill = color.lighten(0.05,Palette.pedestrian),
		medium_label = Palette.labels,

		strong_stroke = Palette.map_background,
		strong_fill = Palette.pedestrian,
		strong_label = Palette.labels_strong,
	},

	Trails = {
		light_stroke = Palette.map_background,
		light_fill = color.lighten(0.07,Palette.trails),
		light_label = color.darken(0.10,Palette.trails),

		medium_stroke = Palette.map_background,
		medium_fill = color.lighten(0.05,Palette.trails),
		medium_label = color.darken(0.15,Palette.trails),

		strong_stroke = Palette.map_background,
		strong_fill = Palette.trails,
		strong_label = color.darken(0.18,Palette.trails),
	},

	Walkway = {
		light_stroke = Palette.map_background,
		light_fill = color.lighten(0.07,Palette.walkway),
		light_label = color.lighten(0.1,Palette.labels),

		medium_stroke = Palette.map_background,
		medium_fill = color.lighten(0.05,Palette.walkway),
		medium_label = Palette.labels,

		strong_stroke = Palette.map_background,
		strong_fill = Palette.walkway,
		strong_label = Palette.labels_strong,
	},

	-- Areas -------------------------------------

	Cities = {
		light_fill = Palette.cities,
		light_label = color.saturate(0.09,color.lighten(0.3,Palette.label_cities)),

		medium_label = color.lighten(0.25,Palette.label_cities),

		strong_fill = Palette.cities,
		strong_label = Palette.label_cities,
	},


	Stations = {
		light_fill = color.saturate(0.03,color.lighten(0.03,Palette.stations)),
		
		strong_fill = Palette.stations,
		strong_label = Palette.label_station,
	},

	Parks = {
		light_fill = color.desaturate(0.11,color.lighten(0.02,Palette.parks)),

		strong_fill = Palette.parks,
		strong_label = Palette.label_vegetation,	
	},

	Rivers = {
		strong_fill = Palette.rivers,
		strong_label = Palette.label_water,	
	},

	Lakes = {
		strong_fill = Palette.lakes,
		strong_label = Palette.label_water,	
	},

	Sea = {
		strong_fill = Palette.sea,
		strong_label = Palette.label_water,
	},

  GenericEvent = {
    strong_fill = Palette.generic_event,
    light_fill = Palette.generic_event_light,
    ultra_light_fill = Palette.generic_event_ultra_light,
    ultra_strong_fill = Palette.generic_event_ultra_strong,
    stroke = Palette.white,
    strong_label = Palette.label_generic_event, 
    label_outline = Palette.label_outline_generic_event,
    texture = "nwm_generic_mte_outline_pattern",
  },

  AdPinBusinessName = {
    labels_color = Palette.ad_labels_color,
    labels_outline_color = Palette.ad_labels_outline_color,
  },

	-- Navigation -------------------------------------

	Navigation = {
		fill = Palette.navigation,
		stroke = color.darken(0.5,Palette.navigation),
		label = Palette.white,
		labelBg = color.darken(0.2,color.saturate(0.2,Palette.navigation)),
	},
	
	StopPoint = {
		fill = Palette.stop_point,
		stroke = color.darken(0.2,Palette.stop_point),
		label = Palette.white,
		labelBg = color.darken(0.2,color.saturate(0.3,Palette.stop_point)),
	},

	Shared = {
		fill = Palette.shared,
		stroke = Palette.shared_stroke,
		label = Palette.white,
		labelBg = color.darken(0.2,color.saturate(0.2,Palette.shared)),
	},

	SharedStop = {
		fill = Palette.shared_stop,
		stroke = color.darken(0.2,Palette.shared_stop),
		label = Palette.white,
		labelBg = color.darken(0.2,color.saturate(0.2,Palette.shared_stop)),
	},

   RouteSnail = {
      fill = Palette.snail,
      stroke = color.darken(0.2,Palette.snail),
   },
   
   ViaSnail = {
      fill = Palette.snail_via,
      stroke = color.darken(0.15,Palette.snail_via),
   },
   
   SharedSnail = {
      fill = Palette.snail_share,
      stroke = Palette.shared_stroke,
   },
   
   SharedViaSnail = {
      fill = Palette.snail_via_share,
      stroke = Palette.shared_stroke,
   },
   
   Recording = {
      fill = Palette.recording,
      stroke = color.darken(0.2,Palette.recording),
   },
   
   Recorded = {
      fill = Palette.recorded,
      stroke = color.darken(0.2,Palette.recorded),
   },
   
   CarpoolRide = {
      fill = Palette.carpool_ride_fill,
      stroke = Palette.carpool_ride_stroke,
   },
   
   CarpoolDirect = {
      fill = Palette.carpool_direct_fill,
      stroke = Palette.carpool_direct_stroke,
   },

   RoutePreviewSelected = {
      fill = Palette.navigation,
      stroke = color.darken(0.5,Palette.navigation),
   },

   RoutePreviewUnselected = {
      fill = Palette.route_preview_unselected_fill,
      stroke = Palette.route_preview_unselected_stroke,
   },

   AltGreenSelected = {
      fill = Palette.alt_color_1,
      stroke = color.darken(0.5, Palette.alt_color_1),
   },

   AltGreenUnselected = {
      fill = Palette.alt_color_1,
      stroke = color.darken(0.5, Palette.alt_color_1),
   },

   AltBlueSelected = {
      fill = Palette.alt_color_2,
      stroke = color.darken(0.5, Palette.alt_color_2),
   },

   AltBlueUnselected = {
      fill = Palette.alt_color_2,
      stroke = color.darken(0.5, Palette.alt_color_2),
   },

   AltOrangeSelected = {
      fill = Palette.alt_color_3,
      stroke = color.darken(0.5, Palette.alt_color_3),
   },

   AltOrangeUnselected = {
      fill = Palette.alt_color_3,
      stroke = color.darken(0.5, Palette.alt_color_3),
   },

   RouteDetour = {
    fill = Palette.detour,
    stroke = Palette.detour_stroke,
    label = Palette.black,
    labelBg = Palette.white,
  },
}
