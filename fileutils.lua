-- taken from the official Lua book
-- https://www.lua.org/pil/20.4.html
function csv_str_to_table(s)
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

function safe_open(filename, dr, mode)
  local f = io.open(dr .. "/" .. filename, mode)

  if not f then
    error("Could not open file: " .. filename .. " in mode: " .. mode)
  end
  
  return f
end

function safe_close(file)
  file:close()
end

function file_to_table(filename, dr)
  local f = safe_open(filename, dr, "r")
  local tbl = {}
  for line in f:lines() do
    table.insert (tbl, csv_str_to_table(line));
  end
  safe_close(f)

  return tbl
end

function file_exists(filename, dr)
  for file in lfs.dir(dr) do
    if file == filename then
      return true
    end
  end
  
  return false
end

function create_file(filename, dr)
  if file_exists(filename, dr) then
    error("File already exists")
  end
  
  local current_dir = lfs.currentdir()
  lfs.chdir(dr)
  
  local f = safe_open(filename, "w")
  safe_close(f)
  
  lfs.chdir(current_dir)
  return filename
end