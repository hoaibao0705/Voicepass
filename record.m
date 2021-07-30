% Ham thu am va luu vao file wav. VD: Master_voice = record('audio/Master.wav');
function [name] = record(save_path)  
disp('Start Speaking');          % Displays the string "Start Speaking" in command window
sig = audiorecorder(44100,16,1);    % Creates an audio recorder object with name 'sig', sampling rate - 44100, bits - 16 and 1 - audio channel
recordblocking(sig,3);              % Records the audio for 3 secs and store it in 'sig' object
disp('Stop Speaking');           % Displays the string "Stop Speaking" in command window
name = getaudiodata(sig);           % Gets the audio data from 'sig' object and stores it in variable named 'name1'
audiowrite(save_path,name,44100);   % Saves the audio sample with '.wav' extension as mentioned in the input parameter
