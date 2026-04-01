local Parser = loadstring(game:HttpGet('https://raw.githubusercontent.com/ZvQiv/LuaU-Projects/refs/heads/main/Raspberry.lua'))()
local Buffer = loadstring(game:HttpGet('https://raw.githubusercontent.com/ZvQiv/LuaU-Projects/refs/heads/main/Raspberry.lua'))()
local Janitor = loadstring(game:HttpGet('https://raw.githubusercontent.com/ZvQiv/LuaU-Projects/refs/heads/main/Raspberry.lua'))()

local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")

local _Raspberry = {}

_Raspberry.__index = _Raspberry

local from_rgb = Color3.fromRGB
local vector2 = Vector2.new
local os_date = os.date
local table_insert = table.insert 
local udim2 = UDim2.new
local math_max = math.max
local string_lower = string.lower
local string_find = string.find

function _Raspberry:mount(parent, t)
	if self.mounted then 
		return warn('raspberry console is already mounted.')
	end
	
	local Raspberry = Instance.new("ScreenGui")
	local Console = Instance.new("Frame")
	local Viewport = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local WindowPadding = Instance.new("Frame")
	local CMD = Instance.new("TextBox")
	local UIPadding = Instance.new("UIPadding")
	local Header = Instance.new("TextButton")
	local UIDragDetector = Instance.new('UIDragDetector')

	Raspberry.Name = "Raspberry"
	Raspberry.Parent = parent
	Raspberry.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	do
		local console = self.parser:Register('console', {'con'})
		local buffer = self.parser:Register('buffer', {'b'})
		
		console:cmd('destroy', {'-d'}, function()
			table.clear(_Raspberry)
			Raspberry:Destroy()
		end)
		
		console:cmd('clear', {'-c'}, function()
			self.buffer:reset()
			
			for _, label in ipairs(self.pool) do
				label.Visible = false
			end
			
			self.render = true
		end)
		
		console:cmd('search', {'-s'}, function(a1)
			self:filter(a1)
		end)
		
		buffer:cmd(nil, nil, function(a1, ...)
			local args = {...}
			
			if a1 == 'max_size' or a1 == '-ms' then
				warn(`[buffer] [max size]: {self.buffer:getMaxSize()}`)
			end
			
			if a1 == 'size' or a1 == '-s' then
				warn(`[buffer] [current size]: {self.buffer:getSize()}`)
			end
			
			if a1 == 'data' or a1 == '-d' then
				warn(`[buffer] [data]: {self.buffer:getData()}`)
			end
			
			if a1 == '-set' and args[1] then 
				if string.match(args[1], '[%d]+') then
					self.buffer:setSize(tonumber(args[1]))

					warn(`[buffer] [max size set]: {args[1]}`)
				end
			end
		end)
	end
	
	Console.Name = "Console"
	Console.Parent = Raspberry
	Console.Active = true
	Console.AnchorPoint = Vector2.new(0.5, 0.5)
	Console.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Console.BackgroundTransparency = t or 0
	Console.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Console.BorderSizePixel = 0
	Console.Position = UDim2.new(0.5, 0, 0.5, 0)
	Console.Size = UDim2.new(0, 900, 0, 450)
	Console.ZIndex = 0

	Viewport.Name = "Viewport"
	Viewport.Parent = Console
	Viewport.Active = true
	Viewport.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Viewport.BackgroundTransparency = 1.000
	Viewport.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Viewport.BorderSizePixel = 0
	Viewport.LayoutOrder = 1
	Viewport.Position = UDim2.new(0, 0, 0, 25)
	Viewport.Size = UDim2.new(1, 0, 1, -40)
	Viewport.ZIndex = 2
	Viewport.BottomImage = "rbxassetid://1195495135"
	Viewport.CanvasSize = UDim2.new(0, 0, 0, 15)
	Viewport.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	Viewport.MidImage = "rbxassetid://1195495135"
	Viewport.ScrollBarThickness = 8
	Viewport.TopImage = "rbxassetid://1195495135"

	UIListLayout.Parent = Viewport
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 2)

	WindowPadding.Name = "WindowPadding"
	WindowPadding.Parent = Viewport
	WindowPadding.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowPadding.BackgroundTransparency = 1.000
	WindowPadding.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowPadding.BorderSizePixel = 0
	WindowPadding.LayoutOrder = 0
	WindowPadding.Position = UDim2.new(0, 0, 0, 0)
	WindowPadding.Size = UDim2.new(1, 0, -1, 0)

	CMD.Name = "CMD"
	CMD.Parent = Console
	CMD.AnchorPoint = Vector2.new(0, 1)
	CMD.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	CMD.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CMD.BorderSizePixel = 0
	CMD.LayoutOrder = 1
	CMD.Position = UDim2.new(0, 0, 1, 0)
	CMD.Size = UDim2.new(1, 0, 0, 15)
	CMD.ZIndex = 2
	CMD.Font = Enum.Font.SourceSansBold
	CMD.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
	CMD.PlaceholderText = "CMD"
	CMD.Text = ""
	CMD.TextColor3 = Color3.fromRGB(255, 255, 255)
	CMD.TextSize = 14.000
	CMD.TextXAlignment = Enum.TextXAlignment.Left

	UIPadding.Parent = CMD
	UIPadding.PaddingBottom = UDim.new(0, 2)
	UIPadding.PaddingLeft = UDim.new(0, 2)
	UIPadding.PaddingRight = UDim.new(0, 2)
	UIPadding.PaddingTop = UDim.new(0, 2)

	Header.Name = "Header"
	Header.Parent = Console
	Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Header.BorderSizePixel = 0
	Header.LayoutOrder = 1
	Header.Size = UDim2.new(1, 0, 0, 25)
	Header.ZIndex = 2
	Header.AutoButtonColor = false
	Header.Font = Enum.Font.SourceSansBold
	Header.Text = " ラズベリー"
	Header.TextColor3 = Color3.fromRGB(255, 255, 255)
	Header.TextSize = 14.000
	Header.TextXAlignment = Enum.TextXAlignment.Left

	UIDragDetector.Name = 'DragMe'
	UIDragDetector.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable
	UIDragDetector.DragSpace = Enum.UIDragDetectorDragSpace.Reference
	UIDragDetector.Parent = Header
	
	local console = Console
	local offset

	UIDragDetector.DragStart:Connect(function(pos)
		offset = pos - Vector2.new(console.AbsolutePosition.X, console.AbsolutePosition.Y)
	end)

	UIDragDetector.DragContinue:Connect(function(pos)
		local newPos = pos - offset

		console.Position = UDim2.new(0, newPos.X + (console.AbsoluteSize.X * console.AnchorPoint.X), 0, newPos.Y + (console.AbsoluteSize.Y * console.AnchorPoint.Y))
	end)
	
	self.WindowPadding = WindowPadding
	self.Viewport = Viewport
	self.layout = UIListLayout

	for i = 1, self.poolSize do
		local LogEntry = Instance.new("TextBox")
		LogEntry.Name = i
		LogEntry.Parent = Viewport
		LogEntry.BackgroundTransparency = 1
		LogEntry.Font = self.font; 
		LogEntry.TextSize = self.fontSize
		LogEntry.TextColor3 = Color3.new(1,1,1)
		LogEntry.TextWrapped = true; 
		LogEntry.TextXAlignment = Enum.TextXAlignment.Left
		LogEntry.TextYAlignment = Enum.TextYAlignment.Top
		LogEntry.Visible = false
		LogEntry.ClearTextOnFocus = false

		self.pool[i] = LogEntry
	end
	
	self.janitor:add(Viewport:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		local cp = Viewport.CanvasPosition.Y
		local cs = Viewport.CanvasSize.Y.Offset
		local vs = Viewport.AbsoluteSize.Y

		self.auto_scroll = (cp >= (cs - vs))
		self.render = true
	end))
	
	self.janitor:add(RunService.Heartbeat:Connect(function()
		if self.render then
			self:refresh()
		end
	end))
	
	self.janitor:add(CMD.FocusLost:Connect(function(enterPressed)
		if enterPressed then 
			local input = CMD.Text
			if input == "" then 
				return 
			end

			CMD.Text = ""

			self.parser:Execute(input)
		end
	end))
	
	self.mounted = true
end

function _Raspberry:out(raw, tag)
	local formated_txt = `[{os_date("%H:%M:%S")}] {raw}`

	local color = from_rgb(255, 255, 255)
	if tag == "Error" then 
		color = from_rgb(255, 90, 74)
	elseif tag == "Warning" then 
		color = from_rgb(255, 218, 68) 
	elseif tag == "Info" then 
		color = from_rgb(50, 181, 255) 
	end

	local entry = { 
		Message = formated_txt, 
		Raw = raw,
		Type = tag,
		Color = color,
		Dims = TextService:GetTextSize(formated_txt, self.fontSize, self.font, vector2()),
	}

	self.buffer:push_back(entry)
	self.render = true 
end

function _Raspberry.new(maxSize)
	local self = setmetatable({}, _Raspberry)
	local buffer_class, parser_class, janitor_class = require(script.RingBuffer), require(script.Parser), require(script.Janitor)
	
	self.buffer, self.parser, self.janitor = buffer_class.new(maxSize or 100), parser_class.new(), janitor_class.new()
	self.pool = {} 
	self.auto_scroll = true
	self.render = false
	self.isFiltering = false
	self.currentQuery = ''
	self.font = Enum.Font.SourceSansBold
	self.fontSize = 14
	self.poolSize = 26

	return self
end

function _Raspberry:refresh()
	local viewport = self.Viewport
	local viewSize = viewport.AbsoluteSize
	local canvasY = viewport.CanvasPosition.Y
	local layoutPadding = self.layout.Padding.Offset

	local currentY = 0
	local uiIndex = 1
	local paddingHeight = -1

	local it = self.buffer:iterator()
	local lowerQuery = self.isFiltering and string_lower(self.currentQuery) or nil
	
	local log = it:next()
	while log do
		local isMatch = true
		
		if lowerQuery then
			local messageMatch = string_find(string_lower(log.Message), lowerQuery)
			local typeMatch = log.Type and string_find(string_lower(log.Type), lowerQuery)
			
			isMatch = (messageMatch or typeMatch)
		end

		if isMatch then
			local rowHeight = log.Dims.Y
			local rowBottom = currentY + rowHeight

			if rowBottom >= canvasY and uiIndex <= self.poolSize then
				local label = self.pool[uiIndex]
				
				if label then
					if paddingHeight < 0 then 
						paddingHeight = currentY 
					end

					label.Text = log.Message 
					label.TextColor3 = log.Color
					label.Size = udim2(1, 0, 0, rowHeight)
					label.Visible = true
					label.LayoutOrder = uiIndex + 1 

					uiIndex += 1
				end
			end

			currentY += (rowHeight + layoutPadding)
		end

		log = it:next()
	end

	self.WindowPadding.Size = udim2(1, 0, 0, math_max(0, paddingHeight))
	viewport.CanvasSize = udim2(0, 0, 0, currentY)

	if self.auto_scroll then
		viewport.CanvasPosition = vector2(0, math_max(0, currentY - viewSize.Y))
	end

	self.render = false
end

function _Raspberry:filter(query)
	self.currentQuery = query or ""
	
	if not query or query == "All" or query == "-a" then
		self.isFiltering = false
	else
		for i = 1, self.poolSize do
			self.pool[i].Visible = false
		end
		
		self.isFiltering = true
	end

	self.Viewport.CanvasPosition = vector2(0, 0)
	self.render = true
end

function _Raspberry:trace(cb)
	local success, result = xpcall(cb, function(err)
		local stack = debug.traceback(err, 2)

		self:out(stack, "Error")

		return err
	end)

	return success, result
end

return _Raspberry
