%input_output_data.m
clear 
x=[1 2]; y=[3 4 5];
save sig x y % save x and y in a MATLAB data file 'sig.mat'
clear('y')
display('After y has been cleared, does y exist?')
if (exist('y')~=0), disp('Yes'), y
 else  disp('No')
end
load sig y % read y from the MATLAB data file 'sig.mat'
disp('After y has been loaded the file sig.mat, does y exist?')
if isempty('y'), disp('No'), else disp('Yes'), y,  end 
fprintf('x(2)=%5.2f \n', x(2))
save y.dat y /ascii % save y into the ASCII data file 'y.dat' 
% The name of the ASCII data file must be the same as the variable name. 
load y.dat % read y from the ASCII data file 'y.dat'
str='prod(y)'; % ready to compute the produce of the elements of y
eval(str) % evaluate the string expression 'prod(y)'
