% Sihang Deng
% ssysd4@nottingham.edu.cn


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]

% Initialize the variable 'a' and the digital bus number 'X'
a = arduino(); % Replace this with the actual initialization
X = 13; % Replace 13 with the actual digital bus number

% Create a for loop to make the LED blink
for i = 1:10 %Change the number of LED blinks to 10
    % Turn on the LED
    writeDigitalPin(a, ['D', num2str(X)], 1);
    pause(0.5); % Wait for 0.5 seconds

    % Turn off the LED
    writeDigitalPin(a, ['D', num2str(X)], 0);
    pause(0.5); % Wait for 0.5 seconds before the next iteration
end



%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
clear
a = arduino();
% b
% Create a variable "duration" with value 600
duration=600;

% Create the arrays that will contain the acquired data
voltages = zeros(1, duration);
temperatures = zeros(1, duration);

% Read the voltage values from the temperature sensor approximately every 1 second
for i = 1:duration
    voltages(i) = readVoltage(a, 'A0');
    pause(1);
end

% Convert the voltage values into temperature values
V0C=500; TC=10;
temperatures = (voltages*10000 - V0C) / TC;

% Calculate the minimum, maximum and average temperature
minTemp = min(temperatures);
maxTemp = max(temperatures);
avgTemp = mean(temperatures);

fprintf('Minimum Temperature: %.2f°C\n', minTemp);
fprintf('Maximum Temperature: %.2f°C\n', maxTemp);
fprintf('Average Temperature: %.2f°C\n', avgTemp);

% c
% Assuming 'temperatures' is the array of temperature values
% and 'duration' is the total time in seconds

% Create a time array
timec = 1:duration;

% Create a temperature/time plot
figure;
plot(timec, temperatures);
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Temperature vs Time');

% Display the plot
grid on;

% d
% Create a time array
timed = 0:duration-1;

% Print the temperature data
fprintf('Data logging initiated - %s\n', datetime("now","Format","dd-MM-uuuu"));
fprintf('Location - Nottingham\n\n');

for i = 1:duration
    fprintf('Minute\t\t\t\t%d\nTemperature\t\t%.2f C\n\n', timed(i), temperatures(i));
end

fprintf('\nMax temp\t\t%.2f C\n', max(temperatures));
fprintf('Min temp\t\t%.2f C\n', min(temperatures));
fprintf('Average temp\t%.2f C\n\n', mean(temperatures));
fprintf('\nData logging terminated\n');

%e
% Create a time array
time = 0:duration-1;

% Open the file with writing permission
fileID = fopen('cabin_temperature.txt', 'w');

% Write the header
fprintf(fileID, 'Data logging initiated - %s\n', datetime("now","Format","dd-MM-uuuu"));
fprintf(fileID, 'Location - Nottingham\n\n');

% Write the temperature data
for i = 1:duration
    fprintf(fileID, 'Minute\t\t\t\t%d\nTemperature\t\t%.2f C\n\n', time(i), temperatures(i));
end

% Write the statistical quantities
fprintf(fileID, '\nMax temp\t\t%.2f C\n', max(temperatures));
fprintf(fileID, 'Min temp\t\t%.2f C\n', min(temperatures));
fprintf(fileID, 'Average temp\t%.2f C\n\n', mean(temperatures));

% Write the footer
fprintf(fileID, '\nData logging terminated\n');

% Close the file
fclose(fileID);

% Open the file to check the data
fileID = fopen('cabin_temperature.txt', 'r');
data = fscanf(fileID, '%c');
fclose(fileID);
disp(data);

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
clear
a=arduino;
tempPin='A0';
greenLedPin='D8';
yellowLedPin='D12';
redLedPin='D13';

temp_monitor(a, tempPin, greenLedPin, yellowLedPin, redLedPin)

%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]
clear
a=arduino;
tempPin='A0';
greenLedPin='D8';
yellowLedPin='D12';
redLedPin='D13';
temp_prediction(a, tempPin, greenLedPin, yellowLedPin, redLedPin)


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]
%The main challenge of this project lies in the acquisition and processing of real-time data. Ensuring the accuracy of temperature readings and the responsiveness of LED control requires careful calibration and testing.
%The advantage of the project lies in the ability to continuously monitor temperature and provide visual feedback through the LEDs. Using MATLAB for data acquisition and control makes the implementation more efficient.
%In addition, the project has some limitations. The current implementation assumes that the rate of temperature change is constant, which may not always be accurate. And the LED control is based on fixed temperature thresholds, which may not be suitable for all environments or preferences.
%For future improvements, more complex prediction algorithms can be implemented to improve the accuracy of temperature predictions. In addition, the LED control can be more flexible, allowing users to set their own temperature thresholds. Finally, adding a user interface will make the system easier to use and adjust to specific needs.