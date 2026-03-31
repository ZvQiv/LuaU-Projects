local LinearQueue = {}

LinearQueue.__index = LinearQueue

function LinearQueue.new()
	local self = setmetatable({}, LinearQueue)

	self.data = {}

	self.head = 1
	self.tail = 1

	return self
end

function LinearQueue:enqueue(value)
	assert(value, 'Expected value, got nil.')

	self.data[self.tail] = value
	self.tail += 1

	return nil
end

function LinearQueue:dequeue()
	local head = self:peek_head()

	if not head then
		return nil
	end

	self.data[self.head] = nil
	self.head += 1

	return head
end

function LinearQueue:head_index()
	return self.head
end

function LinearQueue:peek_head()
	return self.data[self.head]
end

function LinearQueue:get_queue()
	return self.data
end

return LinearQueue
