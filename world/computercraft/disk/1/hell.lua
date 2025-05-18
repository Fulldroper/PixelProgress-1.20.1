turtle.refuel()

while (turtle.getFuelLevel() > 0) do
 turtle.forward()
 
 if turtle.getFuelLevel() < 0 then
  turtle.refuel()
 end    
        
end
