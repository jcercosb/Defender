local function dumpTableToFile(file, myTable, indent)
  indent = indent or 0 -- Indentación inicial
  
  for k, v in pairs(myTable) do
    if type(v) == "table" then
      file:write(string.rep("  ", indent) .. tostring(k) .. ":\n")
      dumpTableToFile(file, v, indent + 1)
    else
      file:write(string.rep("  ", indent) .. tostring(k) .. ": " .. tostring(v) .. "\n")
    end
  end
end
function TabToFile(tab, file)
  --local zm = zdo.domo:ZMToLua()
  --iterateStruct(zm)
  

  local f = io.open(file, "w")
  if f then
    dumpTableToFile(f, tab)
    f:close()
  else
    print('Can\'t open: '.. file)
  end
end