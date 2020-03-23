local stringutils = {}

-- taken from the official Lua book
-- https://www.lua.org/pil/20.4.html
function stringutils.csv_str_to_table(s)
  s = s .. ','        -- ending comma
  local t = {}        -- table to collect fields
  local fieldstart = 1
  repeat
    -- next field is quoted? (start with `"'?)
    if string.find(s, '^"', fieldstart) then
      local a, c
      local i  = fieldstart
      repeat
        -- find closing quote
        a, i, c = string.find(s, '"("?)', i+1)
      until c ~= '"'    -- quote not followed by quote?
      if not i then error('unmatched "') end
      local f = string.sub(s, fieldstart+1, i-1)
      table.insert(t, (string.gsub(f, '""', '"')))
      fieldstart = string.find(s, ',', i) + 1
    else                -- unquoted; find next comma
      local nexti = string.find(s, ',', fieldstart)
      table.insert(t, string.sub(s, fieldstart, nexti-1))
      fieldstart = nexti + 1
    end
  until fieldstart > string.len(s)
  return t
end

function stringutils.starts_with(str, start)
   return str:sub(1, #start) == start
end

function stringutils.format_string(str)
  local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
  end
  
  return string.lower(trim(str))
end

function stringutils.get_input()
  local input = io.read("*l")
  
  return stringutils.format_string(input)
end

return stringutils