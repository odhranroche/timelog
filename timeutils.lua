local timeutils = {}

local DATE_FORMAT = "%Y%m%d"
local TIME_FORMAT = "%X"
local TIMER = 0

function timeutils.get_date()
  return os.date(DATE_FORMAT)
end

function timeutils.get_time()
  return os.date(TIME_FORMAT)
end

function timeutils.current_time()
  return os.time()
end

function timeutils.start_timer()
  TIMER = timeutils.current_time()
end

function timeutils.get_timer()
  return timeutils.current_time() - TIMER 
end

return timeutils