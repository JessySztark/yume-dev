local FORM = {}

--The name of this form. Do not repeat names of forms!
FORM.Name = "Aggressive"

--Who does this form belong to? Options: FORM_SINGLE, FORM_DUAL, FORM_BOTH
FORM.Type = FORM_SINGLE

--What user groups are able to use this form? And which stances?
FORM.UserGroups = { 
	["user"] = { 1 }, 
	["jedi"] = { 1, 2, 3 },
}

FORM.Stances = {}

FORM.Stances[1] = {
	[ "run" ] = "phalanx_r_run",
	[ "idle" ] = "phalanx_r_idle",
	[ "light_left" ] = {
		Sequence = "phalanx_r_left_t3",
		Time = 0.5,
		Rate = nil,
	},
	[ "light_right" ] = {
		Sequence = "phalanx_r_right_t3",
		Time = 0.7,
		Rate = nil,
	},
	[ "light_forward" ] = {
		Sequence = "phalanx_r_s1_t2",
		Time = nil,
		Rate = nil,
	},
	[ "air_left" ] = {
		Sequence =  "phalanx_a_left_t1",
		Time = 0.6,
		Rate = 1.6,
	},
	[ "air_right" ] = {
		Sequence = "phalanx_a_right_t1",
		Time = 0.6,
		Rate = 1.7,
	},
	[ "air_forward" ] = {
		Sequence = "phalanx_a_s1_t1",
		Time = 0.6,
		Rate = 1.2,
	},
	[ "heavy" ] = {
		Sequence = "phalanx_b_s1_t1",
		Time = 1.7,
		Rate = 1,
	},
	[ "heavy_charge" ] = "phalanx_b_s4_charge",
}

FORM.Stances[2] = {
	[ "run" ] = "phalanx_b_run",
	[ "idle" ] = "phalanx_b_idle",
	[ "light_left" ] = {
		Sequence = "phalanx_b_left_t3",
		Time = 1.0,
		Rate = nil,
	},
	[ "light_right" ] = {
		Sequence = "phalanx_b_right_t2",
		Time = 0.7,
		Rate = nil,
	},
	[ "light_forward" ] = {
		Sequence = "phalanx_b_s2_t3",
		Time = 0.8,
		Rate = nil,
	},
	[ "air_left" ] = {
		Sequence =  "phalanx_a_left_t1",
		Time = 0.6,
		Rate = 1.6,
	},
	[ "air_right" ] = {
		Sequence = "phalanx_a_right_t1",
		Time = 0.6,
		Rate = 1.7,
	},
	[ "air_forward" ] = {
		Sequence = "phalanx_a_s1_t1",
		Time = 0.6,
		Rate = 1.2,
	},
	[ "heavy" ] = {
		Sequence = "phalanx_b_s1_t1",
		Time = 1.7,
		Rate = 1,
	},
	[ "heavy_charge" ] = "phalanx_b_s4_charge",
}

FORM.Stances[3] = {
	[ "run" ] = "phalanx_h_run",
	[ "idle" ] = "phalanx_h_idle",
	[ "light_left" ] = {
		Sequence = "phalanx_b_s2_t1",
		Time = nil,
		Rate = nil,
	},
	[ "light_right" ] = {
		Sequence = "phalanx_h_right_t1",
		Time = nil,
		Rate = nil,
	},
	[ "light_forward" ] = {
		Sequence = "phalanx_h_s1_t1",
		Time = 1.2,
		Rate = nil,
	},
	[ "air_left" ] = {
		Sequence =  "phalanx_a_left_t1",
		Time = 0.6,
		Rate = 1.6,
	},
	[ "air_right" ] = {
		Sequence = "phalanx_a_right_t1",
		Time = 0.6,
		Rate = 1.7,
	},
	[ "air_forward" ] = {
		Sequence = "phalanx_a_s1_t1",
		Time = 0.6,
		Rate = 1.2,
	},
	[ "heavy" ] = {
		Sequence = "phalanx_b_s1_t1",
		Time = 1.7,
		Rate = 1,
	},
	[ "heavy_charge" ] = "phalanx_b_s4_charge",
}

wOS:RegisterNewForm( FORM )