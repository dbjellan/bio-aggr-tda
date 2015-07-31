%  For merlin’s sake, don’t use compareDifferentCrockers.m, it’s inefficient 
%  and the whole 3D matrix thing was a failure. Instead, use 
%  compare100crocker.m, which is much much faster. It doesn’t compare the  
%  model and non-model to each other but. Trust me. You don’t need that, and 
%  it’s not worth the extra time. Change N to your number of runs, make sure 
%  m is indexing over the videos you want, make sure you’re loading and 
%  writing to the correct data, and writing to the correct files, and that’s 
%  it! Since you’re just comparing all of the CROCKER plots to the 
%  experimental data for that one video, your matrices in the resulting 
%  files should be 1xN.


N = 100; %number of runs for each experiment, to compare

%diagonal matrices which stores the pairwise differences between the plots
diffMatrix12 = zeros(1, N); %experimental and model
diffMatrix13 = diffMatrix12; % experimental and non-interactive
dimension = 0; %h dimension of plots you want

%just to grab the sizes
sample = load(strcat('experimental', 'h', num2str(dimension), 'exp1.csv'));

sizeSamp = size(sample);

for m = 3:7
    
    expnum = m;
    
    vector1 = load(strcat('experimental', 'h', num2str(dimension), 'exp', num2str(expnum), '.csv'));
    
    for runnum = 1:N
        vector2 = load(strcat('model100', 'h', num2str(dimension), 'exp', num2str(expnum), 'run', num2str(runnum), '.csv'));
        vector3 = load(strcat('noInteraction100', 'h', num2str(dimension), 'exp', num2str(expnum), 'run', num2str(runnum), '.csv'));
        
        %comparing exp by models, 1*N matrices
        diff = abs(vector1 - vector2);
        diffMatrix12(1, runnum) = sum(diff(:));
        
        diff = abs(vector1 - vector3);
        diffMatrix13(1, runnum) = sum(diff(:));
        
        runnum
    end
    
    
    values = diffMatrix12./(sizeSamp(1) * sizeSamp(2));
    csvwrite(strcat('ModelAndExperimental100', 'h', num2str(dimension), 'exp', num2str(m), 'differences', '.csv'), values)
    
    values = diffMatrix13./(sizeSamp(1) * sizeSamp(2));
    csvwrite(strcat('ExperimentalAndNon100', 'h', num2str(dimension), 'exp', num2str(m), 'differences', '.csv'), values)
    
    expDone = m
end

