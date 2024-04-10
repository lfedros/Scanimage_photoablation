# Scanimage_photoablation

% ## Automated photoablation at B2 ##
% 
% - find the target dendrite/neuron at 920nm. 
% - Zoom in and activate the cross-hair target.
% - Center the target neuron/dendrite
% - switch the laser wl to 800nm
% - re-center to correct for change of focus due to wL switch
% - pause imaging
% - run the photoablation code
% - switch laser back to 920nm
% - check the damage
% 
% ## Photoablation pseudo-code ##
% 
% function(pulse_pw, pulse_t)
% % pulse_pw is the desired power (mW)
% % pulse_t is desired length of pulse (s)
% 
% - read V-mW calibration curve for Pockels modulator
% - reduce PMT voltage
% - POINT the scanners
% - ramp up power to pulse_pw (mW)
% - OPTIONAL: access reading of PMT from NIdaq
% - OPTIONAL: switch off if PMT reading shows a significant increase
% - switch off pulse after pulse_t (s)
% - PARK the scanners
% - re-set power to initial value
% - re-set PMT voltage to initial value
