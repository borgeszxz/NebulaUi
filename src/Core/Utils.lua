return function(Theme)
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    
    local Utils = {}
    Utils.Connections = {}
    
    local clamp = math.clamp
    local fromOffset = UDim2.fromOffset
    local insert = table.insert
    
    function Utils:Create(className, properties)
        local instance = Instance.new(className)
        for prop, value in pairs(properties) do
            if prop ~= "Parent" then
                instance[prop] = value
            end
        end
        if properties.Parent then
            instance.Parent = properties.Parent
        end
        return instance
    end
    
    function Utils:Tween(object, properties, duration, easingStyle, easingDirection)
        local tweenInfo = TweenInfo.new(
            duration or Theme.TweenSpeed,
            easingStyle or Theme.TweenEase,
            easingDirection or Enum.EasingDirection.Out
        )
        local tween = TweenService:Create(object, tweenInfo, properties)
        tween:Play()
        return tween
    end
    
    function Utils:Draggify(frame, handle)
        handle = handle or frame
        local dragging = false
        local dragStart, startPos
        local Camera = workspace.CurrentCamera
        
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
            end
        end)
        
        handle.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        local connection = UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local viewportSize = Camera.ViewportSize
                local newX = clamp(startPos.X.Offset + delta.X, 0, viewportSize.X - frame.AbsoluteSize.X)
                local newY = clamp(startPos.Y.Offset + delta.Y, 0, viewportSize.Y - frame.AbsoluteSize.Y)
                Utils:Tween(frame, {Position = fromOffset(newX, newY)}, 0.05, Enum.EasingStyle.Linear)
            end
        end)
        
        insert(Utils.Connections, connection)
    end
    
    function Utils:AddConnection(signal, callback)
        local connection = signal:Connect(callback)
        insert(Utils.Connections, connection)
        return connection
    end
    
    function Utils:DisconnectAll()
        for _, connection in ipairs(Utils.Connections) do
            if connection.Connected then
                connection:Disconnect()
            end
        end
        Utils.Connections = {}
    end
    
    return Utils
end

