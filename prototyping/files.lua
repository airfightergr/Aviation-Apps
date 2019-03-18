function count(base, pattern)
  return select(2, string.gsub(base, pattern, ""))
end
  

sText = "KJFK"
sFind = {}
tData = {}
sF1 = 0
sF2 = 1


rwysFile = io.open("files/runways.csv", "r+")

if rwysFile ~= nil then print("File Found!") 
  
    local content = rwysFile:read("*a")
      if content ~= nil then 
          print("Data found")
          
          local x = count(content, sText)
          
          for i = 1, x do
            sF1, sF2 = string.find(content, sText, sF2)
            sFind[i] = string.match(content, sText..".-\n", sF1)
            print(sF1, sF2, sFind[i])
          
          for w in string.gmatch(sFind[i], "[^%,]+") do -----"%a+") do
            table.insert(tData, w)
          end
          
          end
          print(#sFind, #tData)
         
         for i = 1, #tData do
           print(tData[i])
         end
         
         print( "RUNWAYS: \n" .. 
              string.sub(tData[7], 2, -2) .. "/" .. string.sub(tData[13], 2, -2) ..  
              "\nHDG (true): " .. tData[11] .. "/" .. tData[17]..
              "\nLength (meters): " .. tData[2] ..
              "\nMean Rwy Elevetion (feet): " .. string.format("%d", (tData[10]+tData[16])/2))
         
         
          
      else
          print("Data not found")
      end


 rwysFile:close()     
else 
  print("File Not Found!") 
  
end

  
  
  