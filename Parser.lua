-- This is parser & tokenizer for a small project of mine.
local Commander = {}

Commander.__index = Commander

function Commander.new()
	local self = setmetatable({}, Commander)

	self.MasterTable = {}

	return self
end

function Commander:Register(rootName, aliases)
	local commandObject = {
		Name = rootName,
		Literals = {},
		Default = nil
	}

	self.MasterTable[rootName] = commandObject

	for _, alias in ipairs(aliases or {}) do
		self.MasterTable[alias] = commandObject
	end

	function commandObject:cmd(literal, litAliases, callback)
		local argCount, isVararg = debug.info(callback, "a")
		local cmdData = {
			func = callback,
			expectedArgs = argCount,
			isVararg = isVararg
		}

		if literal == nil then
			self.Default = cmdData
		else
			self.Literals[literal] = cmdData

			for _, lAlias in ipairs(litAliases or {}) do
				self.Literals[lAlias] = cmdData
			end
		end
	end
	
	return commandObject
end

local function _tokenize(text)
	local tokens = {}
	local length = #text
	local pos = 1

	while pos <= length do
		local char = string.sub(text, pos, pos)

		if char == '"' then
			local endQuote = string.find(text, '"', pos + 1)

			if endQuote then
				table.move({'"', string.sub(text, pos + 1, endQuote - 1), '"'}, 1, 3, #tokens + 1, tokens)
				pos = endQuote + 1
			else
				table.insert(tokens, '"')
				pos = pos + 1
			end
		elseif char == " " then
			pos = pos + 1
		else
			local word = string.match(text, '^[^%s"]+', pos)
			
			if word then
				table.insert(tokens, word)
				pos = pos + #word
			else
				pos = pos + 1
			end
		end
	end
	
	return tokens
end

function Commander:Execute(text)
	local tokens = _tokenize(text)
	
	local quoteCount = 0
	for _, t in ipairs(tokens) do
		if t == '"' then 
			quoteCount = quoteCount + 1 
		end
	end
	
	if quoteCount % 2 ~= 0 then
		return warn("Syntax Error: Unclosed string.")
	end

	if #tokens == 0 then 
		return 
	end

	local rootName = string.gsub(tokens[1], "^/", "")
	local root = self.MasterTable[rootName]

	if not root then 
		return warn("Unknown command: " .. rootName) 
	end

	local args = {}
	for i = 2, #tokens do
		if tokens[i] ~= '"' then 
			table.insert(args, tokens[i]) 
		end
	end

	local firstArg = args[1]
	local cmdData
	local finalArgs

	if firstArg and root.Literals[firstArg] then
		cmdData = root.Literals[firstArg]
		finalArgs = {unpack(args, 2)}
	else
		cmdData = root.Default
		finalArgs = args
	end

	if not cmdData then 
		return warn("Invalid usage for " .. rootName) 
	end
	
	if cmdData.isVararg then
		if #finalArgs < cmdData.expectedArgs then
			return warn(string.format("Error: This command requires at least %d argument(s).", cmdData.expectedArgs))
		end
	else
		if #finalArgs ~= cmdData.expectedArgs then
			return warn(string.format("Error: Expected exactly %d args, got %d.", cmdData.expectedArgs, #finalArgs))
		end
	end

	cmdData.func(unpack(finalArgs))
end

return Commander
