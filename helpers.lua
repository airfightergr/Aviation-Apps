function binary_to_float(str, pos)
   local b1, b2, b3, b4 = str:byte(pos, pos+3)
   local sign = b4 > 0x7F and -1 or 1
   local expo = (b4 % 0x80) * 2 + math.floor(b3 / 0x80)
   local mant = ((b3 % 0x80) * 0x100 + b2) * 0x100 + b1
   local n
   if mant + expo == 0 then
      n = sign * 0.0
   elseif expo == 0xFF then
      n = (mant == 0 and sign or 0) / 0
   else
      n = sign * (1 + mant / 0x800000) * 2.0^(expo - 0x7F)
   end
   return n
end

--
--local str = "DATA*\20\0\0\0\237\222\28\66\189\59\182\65..."
--print(binary_to_float(str, 10))  --> 39.217700958252
--print(binary_to_float(str, 14))  --> 22.779169082642



function CoordsDeciToMinutes( )

   ---Takes coordinates in decimal format and outputs in HH MM.s in a table




end


function CoordsMinutesToDeci( )





end