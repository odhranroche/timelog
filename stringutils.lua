function starts_with(str, start)
   return str:sub(1, #start) == start
end

function format_string(str)
  local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
  end
  
  return string.lower(trim(str))
end

function get_input()
  local input = io.read("*l")
  
  return format_string(input)
end

-- Tests --
assert(starts_with("view 1234567890", "view"))
assert(format_string("   ") == "")
assert(format_string("  ABC  ") == "abc")
assert(format_string(" AbCd") == "abcd")
assert(format_string("AbCd ") == "abcd")