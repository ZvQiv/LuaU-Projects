local CircularBuffer = {} -- CircularBuffer Class.

CircularBuffer.__index = CircularBuffer

function CircularBuffer.new(size)
	assert(size, "Size expected got. nil.")
	assert(size > 0, "size must be > 0")
	
	local self = setmetatable({}, CircularBuffer)
	
	-- initalize fields:
	self.data = {}
	self.index = 0
	self.max_size = size

	return self
end

-- not explaining these, should not need to explain them:
function CircularBuffer:reset()
	self.data = {}
	self.index = 0
end

function CircularBuffer:get_size()
	return #self.data
end

function CircularBuffer:maxSize()
	return self.max_size
end

function CircularBuffer:front_index() -- return the index of oldest value.
	local index = self.index + 1
	
	if not self.data[index] then
		return 1
	end
	
	return index
end

function CircularBuffer:front() -- return the oldest value.
	local front = self:front_index() -- reuse front_index method here.
	
	if self.data[front] then
		return self.data[front]
	end
	
	return nil
end

function CircularBuffer:back() -- return the newest value.
	if self.data[self.index] then
		return self.data[self.index]
	end
	
	return nil
end

function CircularBuffer:at(i) -- -- return the values in order, starting at (i)
	assert(i, "cant index buffer with nil")

	local index = self:front_index() -- reuse front_index method.
	index = (index + i - 2) % self.max_size + 1 -- wrap gaurd.
	
	if self.data[index] then
		return self.data[index]
	end
	
	return nil
end

function CircularBuffer:reverse_at(i) -- return the values in reverse order, starting at (i).
	local index = self.index
	
	index = (index - i - 1) % self.max_size + 1 -- wrap gaurd.
	
	if self.data[index] then
		return self.data[index]
	end
	
	return nil
end

function CircularBuffer:get_data() -- return the queue.
	return self.data
end

function CircularBuffer:enqueue(newData) -- enqueue.
	local next_index = self.index + 1 -- increment next_index.
	
	if next_index > self.max_size then -- assuming next_index > max_size overwrite next_index.
		next_index = 1
	end
	
	-- capture overwritten values to return!
	local overwritten = self.data[next_index]

	self.data[next_index] = newData
	self.index = next_index

	return overwritten
end

return CircularBuffer
