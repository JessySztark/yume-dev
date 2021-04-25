if not ( wOS.ALCS.Config.Crafting.ShouldCraftingUseMySQL or wOS.ALCS.Config.Character.ShouldUseMySQL or wOS.ALCS.Config.Dueling.ShouldUseMySQL or wOS.ALCS.Config.Skills.ShouldSkillUseMySQL ) then return end

require("mysqloo")
if (mysqloo.VERSION != "9" || !mysqloo.MINOR_VERSION || tonumber(mysqloo.MINOR_VERSION) < 1) then
	MsgC(Color(255, 0, 0), "You are using an outdated mysqloo version\n")
	MsgC(Color(255, 0, 0), "Download the latest mysqloo9 from here\n")
	MsgC(Color(86, 156, 214), "https://github.com/syl0r/MySQLOO/releases")
	return
end

local db = {}
local dbMetatable = {__index = db}

//This converts an already existing database instance to be able to make use
//of the easier functionality provided by mysqloo.CreateDatabase
function mysqloo.ConvertDatabase(database)
	return setmetatable(database, dbMetatable)
end

//The same as mysqloo.connect() but adds easier functionality
function mysqloo.CreateDatabase(...)
	local db = mysqloo.connect(...)
	db:connect()
	return mysqloo.ConvertDatabase(db)
end

local function addQueryFunctions(query, func, ...)
	local oldtrace = debug.traceback()
	local args = {...}
	table.insert(args, query)
	function query.onAborted(qu)
		table.insert(args, false)
		table.insert(args, "aborted")
		if (func) then
			func(unpack(args))
		end
	end

	function query.onError(qu, err)
		table.insert(args, false)
		table.insert(args, err)
		if (func) then
			func(unpack(args))
		else
			ErrorNoHalt(err .. "\n" .. oldtrace .. "\n")
		end
	end

	function query.onSuccess(qu, data)
		table.insert(args, true)
		table.insert(args, data)
		if (func) then
			func(unpack(args))
		end
	end
end

function db:RunQuery(str, callback, ...)
	local query = self:query(str)
	addQueryFunctions(query, callback, ...)
	query:start()
	return query
end

local function setPreparedQueryArguments(query, values)
	if (type(values) != "table") then
		values = { values }
	end
	local typeFunctions = {
		["string"] = function(query, index, value) query:setString(index, value) end,
		["number"] = function(query, index, value) query:setNumber(index, value) end,
		["boolean"] = function(query, index, value) query:setBoolean(index, value) end,
	}
	//This has to be pairs instead of ipairs
	//because nil is allowed as value
	for k, v in pairs(values) do
		local varType = type(v)
		if (typeFunctions[varType]) then
			typeFunctions[varType](query, k, v)
		else
			query:setString(k, tostring(v))
		end
	end
end

function db:PrepareQuery(str, values, callback, ...)
	self.CachedStatements = self.CachedStatements or {}
	local preparedQuery = self.CachedStatements[str] or self:prepare(str)
	addQueryFunctions(preparedQuery, callback, ...)
	setPreparedQueryArguments(preparedQuery, values)
	preparedQuery:start()
	return preparedQuery
end

local transaction = {}
local transactionMT = {__index = transaction}

function transaction:Prepare(str, values)
	//TODO: Cache queries
	local preparedQuery = self._db:prepare(str)
	setPreparedQueryArguments(preparedQuery, values)
	self:addQuery(preparedQuery)
	return preparedQuery
end
function transaction:Query(str)
	local query = self._db:query(str)
	self:addQuery(query)
	return query
end

function transaction:Start(callback, ...)
	local args = {...}
	table.insert(args, self)
	function self:onSuccess()
		table.insert(args, true)
		if (callback) then
			callback(unpack(args))
		end
	end
	function self:onError(err)
		err = err or "aborted"
		table.insert(args, false)
		table.insert(args, err)
		if (callback) then
			callback(unpack(args))
		else
			ErrorNoHalt(err)
		end
	end
	self.onAborted = self.onError
	self:start()
end

function db:CreateTransaction()
	local transaction = self:createTransaction()
	transaction._db = self
	setmetatable(transaction, transactionMT)
	return transaction
end