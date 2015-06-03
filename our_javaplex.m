% This script prepares the javaplex library for use

%clc; clear all; close all;
%clear import;

% curpath = pwd();
% fname = mfilename('fullpath');
% [pathstr,name,ext] = fileparts(fname);
% cd(pathstr);
% 
% javaaddpath(strcat(pathstr, '/lib/javaplex.jar'));
% import edu.stanford.math.plex4.*;
% 
% javaaddpath(strcat(pathstr, '/lib/plex-viewer.jar'));
% import edu.stanford.math.plex_viewer.*;
% 
% 
% 
% cd('./utility');
% addpath(pwd);
% 
% cd(curpath);


curpath = pwd();
fname = mfilename('fullpath');
[pathstr,name,ext] = fileparts(fname)
cd(pathstr);

javaaddpath(strcat(pathstr, '/lib/javaplex.jar'));
import edu.stanford.math.plex4.*;

javaaddpath(strcat(pathstr, '/lib/plex-viewer.jar'));
import edu.stanford.math.plex_viewer.*;



cd('./utility');
addpath(pwd);

cd(curpath);