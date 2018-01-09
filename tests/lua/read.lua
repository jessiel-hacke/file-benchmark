-- please install https://github.com/mah0x211/lua-process
-- this is necessary to use getpid();

process = require('process')

-- http://lua-users.org/wiki/SimpleRound
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- This function used to be a generic function to call any system command
-- but was bugging and now only capture memory usage

function capture_memory_usage(pid)

  local command = ("ps -o rss= -p :pid"):gsub(':pid', pid)

  local io = io.popen(command, 'r')
  local f = assert(io)
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')

  return s
end

function print_memory_usage(memory_before, memory_after)
  local memory_usage = round(((memory_after - memory_before) / 1024.0), 2)

  local memory_str = ("Memory: :memory_usage MB"):gsub(':memory_usage', memory_usage)
  print(memory_str)
end

function print_time_spent(time)
  -- os.clock():
  -- Returns an approximation of the amount in seconds of CPU time used by the program.
  local time_str = ("Time: :timems"):gsub(':time', time * 1000 )
  print(time_str)
end

function test_type_label(test_type, test_name, test_mode)
  local str=[=[
Test Language: Lua
Test Language Version: :version
Test Type: :test_type
Test Name: :test_name
Test Mode: :test_mode]=]
  str = str:gsub(':version', io.popen('lua -v'):read())
  str = str:gsub(':test_type', test_type)
  str = str:gsub(':test_name', test_name)
  str = str:gsub(':test_mode', test_mode)

  return str
end

function test_stream(file_path)
  local file = io.open(file_path)
  local lines = file:lines() -- this returns a file iterator

  -- read line by line
  for line in lines do
    -- print(line) -- just to make sure each lines was read
  end

  file:close()
end

function test_full(file_path)
  local file = io.open(file_path)
  file:read("*a")
  file:close()
end

function basename(str)
  value = str:gsub("(.*/)(.*)", '%2')

  return value
end

-- get options from system env(MODE=stream VERBOSE=true lua lua/read.lua)
local file_path = os.getenv('TEST_FILE')
local test_type = os.getenv('TEST_TYPE')
local test_mode = (os.getenv('TEST_MODE') or 'full')

local test_name = (os.getenv('TEST_NAME') or basename(file_path))
local verbose   = (os.getenv('VERBOSE') == 'true')

function run(file_path, test_mode, test_type, test_name, verbose)
  if verbose then
    print(test_type_label(test_type, test_name, test_mode))
  end

  local memory_before = capture_memory_usage(process.getpid())

  if(test_mode == 'full') then
    test_full(file_path)
  else
    test_stream(file_path)
  end

  local memory_after = capture_memory_usage(process.getpid())

  if verbose then
    print_memory_usage(memory_before, memory_after)
    print_time_spent(os.clock())
  end
end

run(file_path, test_mode, test_type, test_name, verbose)

--[===[]
process = require('process')

IOBench = {}
IOBench.__index = IOBench

-- Extend math
-- http://lua-users.org/wiki/SimpleRound
function math.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function IOBench.new(file_path, test_mode, verbose)
  local self = setmetatable({}, IOBench)
  self.file_path = init
  self.mode = test_mode
  self.verbose = verbose
  return self
end

function IOBench.run()
end

function IOBench.print_memory_usage(memory_before, memory_after)
  memory_usage = math.round(((memory_after - memory_before) / 1024.0), 2)

  print(("Memory: :memory_usage MB"):gsub(':memory_usage', memory_usage))
end
--- ]===]
