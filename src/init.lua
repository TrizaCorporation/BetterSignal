local Dependencies = script:WaitForChild("Dependencies")
local ConnectionCreator = require(Dependencies.Connection)

local BetterSignal = {}
BetterSignal.__index = BetterSignal

function BetterSignal.new()
  local self = setmetatable({}, BetterSignal)
  self.Connections = {}
  return self
end

function BetterSignal:Fire(...)
  for _, connection in self.Connections do
      if connection.Function then
        connection.Function(...)
      else
        table.remove(self.Connections, table.find(self.Connections, connection))
      end
   end
end

function BetterSignal:Connect(...)
  local Connection = ConnectionCreator.new(...)
  table.insert(self.Connections, Connection)
  return Connection
end

function BetterSignal:Wait()
  local fired = nil
  local Connection = self:Connect(function()
    fired = true
  end)
  repeat
    task.wait()
  until fired
  Connection:Disconnect()
end

return BetterSignal