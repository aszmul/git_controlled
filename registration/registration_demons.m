function [I_interp, Tx, Ty] = registration_demons(I_rigid, I_mov,Tx,Ty,iteration, range, sigma)

  I_interp = I_mov;    
        
[Gx Gy] = gradient(I_rigid);

    for i=1:iteration
            
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (m-s)    
       Diff = (I_interp - I_rigid) ;  
     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %% Eq 4.
        Vy = -(Diff.* (Gx))./((Gx.^2+Gy.^2) + Diff.^2 + eps);   % changed order during iteration of X and Y
 
        Vx = -(Diff.* (Gy))./((Gy.^2 +Gx.^2) + Diff.^2 + eps);  % changed order during iteration of X and Y    
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Insterting zeros instead of Nan when divided by 0

   Vx(isnan(Vx))=0;            % to eliminate NaN instead of eps
   Vy(isnan(Vy))=0;            % to eliminate NaN instead of eps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Smoothing transformation field
        %Hsmooth=fspecial('gaussian',[60 60],5);
        Hsmooth=fspecial('gaussian',range,sigma);
        Vx=3*imfilter(Vx,Hsmooth);
        Vy=3*imfilter(Vy,Hsmooth);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



        Tx = Tx + Vx;           % changed order during iteration of X and Y
        Ty = Ty + Vy;           % changed order during iteration of X and Y
        




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Standard built in function       

[x,y]=ndgrid(1:size(I_rigid,1),1:size(I_rigid,2));
I_interp = interp2(I_mov, y+Ty,x+Tx);  % the other order of X and Y

     I_interp(isnan(I_interp))=1;  % eliminates NaN

%% b-spline
%        I_interp=movepixels(I_mov,Tx,Ty); 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        

    end


end
