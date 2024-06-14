-- [nfnl] Compiled from fnl/LL.fnl by https://github.com/Olical/nfnl, do not edit.
local default = {name = "LL", level = "warn"}
local levels = {"debug", "info", "warn", "error"}
local toStr
local function _1_(...)
  local acc = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    local s
    if (type(v) == "table") then
      s = vim.inspect(v)
    else
      s = tostring(v)
    end
    acc[(#acc + 1)] = s
  end
  return table.concat(acc, " ")
end
toStr = _1_
local new
local function _3_(opts)
  local M = {}
  local o = vim.tbl_deep_extend("force", default, (opts or {}))
  local targetLevel
  do
    local target = #levels
    for index, level in ipairs(levels) do
      if (level == o.level) then
        target = index
      else
        target = target
      end
    end
    targetLevel = target
  end
  local path = (vim.fn.stdpath("data") .. "/" .. o.name .. ".log")
  local doLog
  local function _5_(level, label, ...)
    if (level >= targetLevel) then
      local info = debug.getinfo(2, "Sl")
      local msg = string.format("[%-6s%s] %s: %s\n", label:upper(), os.date("%Y-%m-%d %H:%M:%S"), (info.short_src .. ":" .. info.currentline), toStr(...))
      local _6_ = io.open(path, "a")
      _6_:write(msg)
      _6_:close()
      return _6_
    else
      return nil
    end
  end
  doLog = _5_
  for num, name in ipairs(levels) do
    local function _8_(...)
      return doLog(num, name, ...)
    end
    M[name] = _8_
  end
  return M
end
new = _3_
return {new = new}
