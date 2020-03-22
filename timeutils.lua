local DATE_FORMAT = "%Y%m%d"
local TIME_FORMAT = "%X"
local TIMER = 0

function get_date()
  return os.date(DATE_FORMAT)
end

function get_time()
  return os.date(TIME_FORMAT)
end

function current_time()
  return os.time()
end

function start_timer()
  TIMER = current_time()
end

function get_timer()
  return current_time() - TIMER 
end