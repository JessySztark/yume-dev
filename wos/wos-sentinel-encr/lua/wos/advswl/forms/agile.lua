local FORM = {}

--The name of this form. Do not repeat names of forms!
FORM.Name = "Agile"

--Who does this form belong to? Options: FORM_SINGLE, FORM_DUAL, FORM_BOTH
FORM.Type = FORM_SINGLE

--What user groups are able to use this form? And which stances?
FORM.UserGroups = { 
	["VIP"] = { 1, 2, 3 },
}

FORM.Stances = {}

FORM.Stances[1] = {
	[ "run" ] = "ryoku_r_run",
	[ "idle" ] = "ryoku_r_idle",
	[ "light_left" ] = {
		Sequence = "ryoku_r_left_t1",
		Time = 0.7,
		Rate = nil,
	},
	[ "light_right" ] = {
		Sequence = "ryoku_r_right_t1",
		Time = 0.9,
		Rate = nil,
	},
	[ "light_forward" ] = {
		Sequence = "ryoku_r_c1_t1",
		Time = 0.6,
		Rate = nil,
	},
	[ "air_left" ] = {
		Sequence =  "vanguard_a_left_t1",
		Time = 0.4,
		Rate = 1.5,
	},
	[ "air_right" ] = {
		Sequence = "vanguard_a_right_t1",
		Time = 0.4,
		Rate = 1.5,
	},
	[ "air_forward" ] = {
		Sequence = "ryoku_a_s2_t1",
		Time = 0.6,
		Rate = 1.5,
	},
	[ "heavy" ] = {
		Sequence = "ryoku_b_s2_t3",
		Time = 2.0,
		Rate = nil,
	},
	[ "heavy_charge" ] = "ryoku_b_s1_charge",
}

FORM.Stances[2] = {
	[ "run" ] = "ryoku_b_run",
	[ "idle" ] = "ryoku_b_idle",
	[ "light_left" ] = {
		Sequence = "ryoku_b_left_t1",
		Time = nil,
		Rate = nil,
	},
	[ "light_right" ] = {
		Sequence = "ryoku_b_right_t1",
		Time = nil,
		Rate = nil,
	},
	[ "light_forward" ] = {
		Sequence = "ryoku_b_s2_t2",
		Time = 0.8,
		Rate = 1.2,
	},
	[ "air_left" ] = {
		Sequence =  "vanguard_a_left_t1",
		Time = 0.4,
		Rate = 1.5,
	},
	[ "air_right" ] = {
		Sequence = "vanguard_a_right_t1",
		Time = 0.4,
		Rate = 1.5,
	},
	[ "air_forward" ] = {
		Sequence = "ryoku_a_s2_t1",
		Time = 0.6,
		Rate = 1.5,
	},
	[ "heavy" ] = {
		Sequence = "ryoku_b_s2_t3",
		Time = 2.0,
		Rate = nil,
	},
	[ "heavy_charge" ] = "ryoku_b_s1_charge",
}

FORM.Stances[3] = {
	[ "run" ] = "ryoku_h_run",
	[ "idle" ] = "ryoku_h_idle",
	[ "light_left" ] = {
		Sequence = "ryoku_h_left_t1",
		Time = 0.8,
		Rate = nil,
	},
	[ "light_right" ] = {
		Sequence = "ryoku_h_right_t1",
		Time = 0.8,
		Rate = nil,
	},
	[ "light_forward" ] = {
		Sequence = "ryoku_h_s1_t1",
		Time = 0.9,
		Rate = nil,
	},
	[ "air_left" ] = {
		Sequence =  "vanguard_a_left_t1",
		Time = 0.4,
		Rate = 1.5,
	},
	[ "air_right" ] = {
		Sequence = "vanguard_a_right_t1",
		Time = 0.4,
		Rate = 1.5,
	},
	[ "air_forward" ] = {
		Sequence = "ryoku_a_s2_t1",
		Time = 0.6,
		Rate = 1.5,
	},
	[ "heavy" ] = {
		Sequence = "ryoku_b_s2_t3",
		Time = 2.0,
		Rate = nil,
	},
	[ "heavy_charge" ] = "ryoku_b_s1_charge",
}

wOS:RegisterNewForm( FORM )