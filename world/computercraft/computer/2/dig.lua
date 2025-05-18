maxDistance = 50;

function dig3by3()
  turtle.dig();
  turtle.digUp();
  turtle.digDown();
end;


for i=0,50 do
  dig3by3();
  turtle.forward();
end
