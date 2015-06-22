

numparticles = 50;
sigma = .3;
l = .2;
v_0 = .03;
timesteps = 3000;
sol = simulate_vicsek(numparticles, timesteps, v_0, l, sigma);
baseindx = 0;
if numparticles < 100,
    numlandmarks = numparticles;
else
    numlandmarks = 100;
end
for baseindx = 0:1500:7500
    fname = strcat('vicksek_persistence_', num2str(baseindx/3));
    vicsek_persistence(sol(: ,[baseindx+1, baseindx+2, baseindx+3]), numlandmarks, true, fname);
end