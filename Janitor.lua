local connectionMannager = {}

connectionMannager.__index = connectionMannager

function connectionMannager.new()
	local _reg = setmetatable({
		connections = {},
		binds = {}
	}, connectionMannager)
	
	return _reg
end

function connectionMannager:add(v)
	assert(typeof(v) == "RBXScriptConnection", "arg must be a connection.")

	table.insert(self.connections, v)
    
	return {
		instance = v,
		remove = function()
			v:Disconnect()

			local idx = table.find(self.connections, v)
			
			if idx then
				table.remove(self.connections, idx)
			end
		end
	}
end

function connectionMannager:cleanup()
	local to_clean = { 
		self.connections, 
		self.binds
	}

	for _, t in ipairs(to_clean) do
		for key, connection in pairs(t) do
			if typeof(connection) == "RBXScriptConnection" then
				if connection.Connected then
					connection:Disconnect()
				end
			end
			
			t[key] = nil
		end
		
		table.clear(t)
	end
	
	return nil
end

function connectionMannager:bind_to(instance)
	assert(typeof(instance) == "Instance", "arg must be an instance.")

	local conn
	conn = instance.AncestryChanged:Once(function(parent)
		self:cleanup()
	end)

	table.insert(self.binds, conn)

	return nil
end

function connectionMannager:get_connections()
    return self.connections
end

function connectionMannager:get_binds()
	return self.binds
end

return connectionMannager
