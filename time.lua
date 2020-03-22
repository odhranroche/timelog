--[[
Name:        time.lua
Usage:       lua time.lua
Commands:    exit, quit -> end timing
             view       -> takes a date in format YYYYMMDD and prints time for that day
             TODO : view today|yesterday -> prints relative time
             pause      -> stops timer
Version:     1
Description:
A command line task timer. Logs are kept and a breakdown of time spent on each task can be viewed.
]]

package.path = "?.lua;" .. package.path

local lfs = require("lfs")
require ("fileutils")
require ("timeutils")
require ("stringutils")

local LOG_DIR = "" -- specify directory to store logs
local CURR_TASK = nil

function get_todays_log()
  local today = get_date()
  
  if file_exists(today, LOG_DIR) then
    return today
  else
    return create_file(today, LOG_DIR)
  end
end

function start_task(activity_name)
  local task = {["activity"]   = activity_name,
                ["start_time"] = get_time(),
                ["end_time"]   = 0,
                ["total_time"] = 0}

  return task
end

function finish_task(task)
  local finished_task = {["activity"]   = task.activity,
                         ["start_time"] = task.start_time,
                         ["end_time"]   = get_time(),
                         ["total_time"] = get_timer()}

  return finished_task
end 

function log_task(task, filename)
  if not file_exists(filename, LOG_DIR) then
    error("File " .. filename .. " does not exist.")
  end
  
  local file = safe_open(filename, LOG_DIR, "a")
  file:write(task.activity   .. ",")
  file:write(task.start_time .. ",")
  file:write(task.end_time   .. ",")
  file:write(task.total_time .. "\n")
  io.flush()
  safe_close(file)
  
  return true  
end

function get_activities(filename)
  if not file_exists(filename, LOG_DIR) then
    print("\nFile " .. filename .. " does not exist.")
  else
    local trackfile = file_to_table(filename, LOG_DIR)
    
    local activities = {}
    for _, task in ipairs(trackfile) do
      activities[task[1]] = true
    end
    
    return activities
  end
  
  return {}
end

function activity_exists(activity, activities)
  return activities[activity]
end

function get_summary(filename)
  if not file_exists(filename, LOG_DIR) then
    print("\nFile " .. filename .. " does not exist.")
  else
    local trackfile = file_to_table(filename, LOG_DIR)
    local activities = get_activities(filename)
    
    local activity_time = {}
    
    for activity,_ in pairs(activities) do
      local track_activity = {["activity"] = activity,
                              ["time"] = 0}
                              
      local subtime = 0
      
      for _, task in ipairs(trackfile) do
        local act = task[1]
        local tm  = task[4]
      
        if act == activity then
          subtime = subtime + tm
        end
      end
      
      activity_time[activity] = subtime
    end

    return activity_time
  end
end

function get_total(summary)
  local total = 0
  
  for k, v in pairs(summary) do
    total = total + v
  end
  
  return total
end

function print_summary(summary)
  local total = get_total(summary)
  
  print()
  for k, v in pairs(summary) do
    print(string.format("%-10s %7.2f mins   %5.2f%%", k, v/60, (v/total)*100))
  end
  print("---------------------------------")
  print(string.format("%-10s %7.2f mins", "Total", total/60))
end

function prompt()
  io.write("\ntime track >> ")
end

function parse_input(str, activities)
  if str == "exit" or str == "quit" then
    return "exit"
  elseif starts_with(str, "view") then
    return "view"
  elseif str == "pause" or str == "stop" then
    return "pause"
  elseif activity_exists(str, activities) then
    return "known"
  else
    return "unknown"
  end
end

function run()
  -- if not lfs.chdir(LOG_DIR) then
  --   error("Unable to chdir to log dir.")
  -- end
  
  local todays_log   = get_todays_log()
  local activities   = get_activities(todays_log)
  local current_task = nil
  
  while true do
    prompt()
    local input = get_input()
    
    if current_task then
      local finished_task = finish_task(current_task)
      log_task(finished_task, todays_log)
      print("Tracking " .. finished_task.activity .. " complete")
      current_task = nil
    end  
    
    local p_input = parse_input(input, activities)
    
    if p_input == "exit" then
      return 0
    elseif p_input == "view" then
      local summary = get_summary(todays_log)
      print_summary(summary)
    elseif p_input == "pause" then
    elseif p_input == "known" then
      print("Tracking " .. input .. " again")
    elseif p_input == "unknown" then
      print("Tracking " .. input .. " for the first time")
      activities[input] = true
    end
    
    if p_input == "known" or p_input == "unknown" then
      current_task = start_task(input)
      start_timer()
    end      
    
  end
end

run()