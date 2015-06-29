function [A,b,error]=f(frame1,frame2,border,...
                       A_initial,...
                       b_initial,...
                       options)

theta_initial=[reshape(A_initial,[4,1]);b_initial];
theta=fmins('fmins_registration_error',theta_initial,options,[],...
            frame1,frame2,border); 
fprintf(1,'\n');
A=reshape(theta(1:4),[2,2]);
b=theta(5:6);
error=registration_error(frame1,frame2,border,A,b);
