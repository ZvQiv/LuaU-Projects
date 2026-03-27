--[[
    LINEAR QUEUE (FIFO)

    WHY USE THIS OVER table.insert / table.remove?
    In Luau, using table.remove(t, 1) forces the engine to "shift" every single remaining 
    element down by one index. In a queue with 10,000 items, this is 9,999 operations 
    every time you dequeue—creating massive lag (O(n) complexity).
    
    This class uses a "Two-Pointer" system (Head and Tail). By moving the Head pointer 
    and setting old slots to nil, we achieve "Constant Time" (O(1)) performance. 
    It doesn't matter if you have 10 items or 10 million; dequeueing is always instant.
]]

local LinearQueue = {} -- linearQueue Class.

LinearQueue.__index = LinearQueue

function LinearQueue.new()
	local self = setmetatable({}, LinearQueue)

	self.data = {} -- initalieze queue.

	-- luaU arrays start at index 1:
	self.head = 1
	self.tail = 1

	return self
end

function LinearQueue:enqueue(value)
	assert(value, 'Expected value, got nil.')

	self.data[self.tail] = value -- enqueue value.
	self.tail += 1 -- increment tail-index to point to next slot.

	return nil
end

function LinearQueue:dequeue()
	local head = self:peek_head()

	if not head then
		return nil -- assuming head caught up to tail.
	end

	self.data[self.head] = nil -- overwrite value at head index with nil. We do this to prevent luaU arrays from shifting.
	self.head += 1 -- increment head.

	return head
end

function LinearQueue:head_index() -- returns head index.
	return self.head
end

function LinearQueue:peek_head() -- returns head.
	return self.data[self.head]
end

function LinearQueue:get_queue() -- returns the queue.
	return self.data
end

return LinearQueue
