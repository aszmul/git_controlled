function [I] = draw_circle(sizeX, sizeY, x, y, r )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


I = zeros(sizeY,sizeX);
[n,m] = size(I);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Narysowanie kolka w I_rigid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:n
    for k= 1:m
        if sqrt((i-y)^2 + (k-x)^2)<r
            I(i,k) = 255;
        end
    end
end


end

