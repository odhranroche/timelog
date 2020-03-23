local lfs = require("lfs")
local stringutils = require ("stringutils")

local fileutils = {}

function fileutils.safe_open(filename, dr, mode)
  local f = io.open(dr .. "/" .. filename, mode)

  if not f then
    error("Could not open file: " .. filename .. " in mode: " .. mode)
  end
  
  return f
end

function fileutils.safe_close(file)
  file:close()
end

function fileutils.file_to_table(filename, dr)
  local f = fileutils.safe_open(filename, dr, "r")
  local tbl = {}
  for line in f:lines() do
    table.insert (tbl, stringutils.csv_str_to_table(line));
  end
  fileutils.safe_close(f)

  return tbl
end

function fileutils.file_exists(filename, dr)
  for file in lfs.dir(dr) do
    if file == filename then
      return true
    end
  end
  
  return false
end

function fileutils.create_file(filename, dr)
  if fileutils.file_exists(filename, dr) then
    error("File already exists")
  end
  
  local current_dir = lfs.currentdir()
  lfs.chdir(dr)
  
  local f = fileutils.safe_open(filename, dr, "w")
  fileutils.safe_close(f)
  
  lfs.chdir(current_dir)
  return filename
end

return fileutils