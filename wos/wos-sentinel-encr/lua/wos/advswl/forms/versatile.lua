local FORM = {}

--The name of this form. Do not repeat names of forms!
FORM.Name = "Versatile"

--Who does this form belong to? Options: FORM_SINGLE, FORM_DUAL, FORM_BOTH
FORM.Type = FORM_SINGLE

--What user groups are able to use this form? And which stances?
FORM.UserGroups = { 
	["VIP"] = { 1, 2, 3 },
}

FORM.Stances = {}

FORM.Stances[1] = {
	[ "run" ] = "vanguard_f_run",
	[ "idle" ] = "vanguard_f_idle",
	[ "light_left" ] = {
		Sequence = "vanguard_r_left_t3",
		Time = 0.5,
		Rate = nil,
	},
	[ "light_right" ] = {
		Sequence = "vanguard_r_right_t3",
		Time = 0.5,
		Rate = nil,
	},
	[ "light_forward" ] = {
		Sequence = "vanguard_r_s1_t2",
		Time = 0.6,
		Rate = nil,
	},
	[ "air_left" ] = {
		Sequence =  "judge_a_left_t1",
		Time = 0.6,
		Rate = 2,
	},
	[ "air_right" ] = {
		Sequence = "phalanx_a_right_t1",
		Time = 0.6,
		Rate = 1.7,
	},
	[ "air_forward" ] = {
		Sequence = "ryoku_a_s1_t1",
		Time = 0.6,
		Rate = 1,
	},
	[ "heavy" ] = {
		Sequence = "judge_r_s1_t1",
		Time = nil,
		Rate = 0.8,
	},
	[ "heavy_charge" ] = "judge_r_s3_charge",
}

FORM.Stances[2] = {
	[ "run" ] = "vanguard_b_run",
	[ "idle" ] = "vanguard_b_idle",
	[ "light_left" ] = {
		Sequence = "vanguard_b_left_t1",
		Time = 0.4,
		Rate = nil,
	},
	[ "light_right" ] = {
		Sequence = "vanguard_b_right_t1",
		Time = 1.4,
		Rate = nil,
	},
	[ "light_forward" ] = {
		Sequence = "vanguard_b_s2_t2",
		Time = 0.8,
		Rate = nil,
	},
	[ "air_left" ] = {
		Sequence =  "judge_a_left_t1",
		Time = 0.6,
		Rate = 2,
	},
	[ "air_right" ] = {
		Sequence = "phalanx_a_right_t1",
		Time = 0.6,
		Rate = 1.7,
	},
	[ "air_forward" ] = {
		Sequence = "ryoku_a_s1_t1",
		Time = 0.6,
		Rate = 1,
	},
	[ "heavy" ] = {
		Sequence = "judge_r_s1_t1",
		Time = nil,
		Rate = 0.8,
	},
	[ "heavy_charge" ] = "judge_r_s3_charge",
}

FORM.Stances[3] = {
	[ "run" ] = "vanguard_h_run",
	[ "idle" ] = "vanguard_h_idle",
	[ "light_left" ] = {
		Sequence = "vanguard_h_left_t2",
		Time = nil,
		Rate = nil,
	},
	[ "light_right" ] = {
		Sequence = "vanguard_h_right_t2",
		Time = nil,
		Rate = nil,
	},
	[ "light_forward" ] = {
		Sequence = "vanguard_h_s1_t1",
		Time = 0.85,
		Rate = 1.5,
	},
	[ "air_left" ] = {
		Sequence =  "judge_a_left_t1",
		Time = 0.6,
		Rate = 2,
	},
	[ "air_right" ] = {
		Sequence = "phalanx_a_right_t1",
		Time = 0.6,
		Rate = 1.7,
	},
	[ "air_forward" ] = {
		Sequence = "ryoku_a_s1_t1",
		Time = 0.6,
		Rate = 1,
	},
	[ "heavy" ] = {
		Sequence = "judge_r_s1_t1",
		Time = nil,
		Rate = 0.8,
	},
	[ "heavy_charge" ] = "judge_r_s3_charge",
}

wOS:RegisterNewForm( FORM )