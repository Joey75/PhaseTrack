%plat phase of 3 anteena
function plotphase(csi,s)

for i=1:3
    plot(phase(csi(1,:)),s)
    plot(phase(csi(2,:)),s)
    plot(phase(csi(3,:)),s)
end