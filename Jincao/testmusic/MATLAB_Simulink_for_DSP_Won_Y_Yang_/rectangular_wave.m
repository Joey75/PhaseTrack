function y=rectangular_wave(t)
global P D
y=(min(abs(mod(t,P)),abs(mod(-t,P)))<=D/2);
