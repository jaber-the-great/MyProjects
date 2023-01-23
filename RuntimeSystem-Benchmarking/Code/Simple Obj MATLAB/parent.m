classdef parent
   properties (Constant)
      first;
      sec = 4;
   end
   properties
      third = 10.0;
      fourth;
   end


   methods
      function obj = parent(third, fourth)
         obj.third = third;
         obj.fourth = fourth;
      end

      function obj = rangeFunc(x)
         if x.length < 10
           obj = "Not in the range"
         else 
             obj = "in range"
         end
      end

   end
end
