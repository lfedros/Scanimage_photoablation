%% from Federico's e-mail
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

%%

function cut_dendrite(hSI, PW, dur)
% Function for automated 2P laser photoablation in scanimage. 
% Automatically executes the following sequence of taks:
% - switch off the PMTs
% - point the laser
% - set the power fraction to achieve desired power in mW (HARD CODED
% CALIBRATION at 800nm !!)
% - wait for desired duration
% - drop the power fraction to 0
% - park the beam
% - re-set the PMTs to original value

%INPUTS
%hSI scanimage object
%PW desired power in mW at the objective
%dur duration of laser pulse

% created by LFR and AL on 14/10/2022 based on code from MK


% power calibration at 800nm
pw_fraction = [0:5:100]/100;
mW = [3 26.3 46.2 59.2 83.7 101.5 118.7 136 ...
    158.8 177.2 195.2 212.3 229.4 246.7 264.7 ...
    281.6 297.7 313.5 330.2 344.3 358.4];

set_PWF = interp1(mW, pw_fraction, PW, 'linear', NaN);

if isnan(set_PWF)
    warning('Requested power out of range, aborting.. ')
    return;
end

% capture current state
currentGains = hSI.hPmts.gains;
currentPmtsOn = hSI.hPmts.powersOn;

% switch off the PMTs
hSI.hPmts.powersOn = zeros(size(currentPmtsOn));
% point the beam
hSI.scanPointBeam;
% turn on the laser power to the necessary value
% the fraction should be calculated from the LUT
% if properly calibrated (we just need to input a couple of values)
% we should have useful LUT in the
% hSI.hBeams.hBeams{1}.powerFraction2PowerWattLut variable
hSI.hBeams.hBeams{1}.setPowerFraction(set_PWF);

% wait a certain time
pulseDur = dur;
pause(pulseDur);
% switch off the laser
hSI.hBeams.hBeams{1}.setPowerFraction(0);
% park the beam
hSI.abort;
% turn the PMTs back to the pre-ablation values
hSI.hPmts.powersOn = currentPmtsOn;
hSI.hPmts.gains = currentGains;

end

