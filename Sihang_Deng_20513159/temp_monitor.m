% TEMP_MONITOR Function
% This function continuously monitors the temperature from a sensor connected to an Arduino board. 
% It controls three LEDs (green, yellow, and red) based on the measured temperature:
% - Green LED is constantly on when the temperature is within the range 18-24 °C.
% - Yellow LED blinks at 0.5 s intervals when the temperature is below the range.
% - Red LED blinks at 0.25 s intervals when the temperature is above the range.
% The function also plots the temperature values as time progresses at intervals of approximately 1 s.
% Usage: temp_monitor(a, tempPin, greenLedPin, yellowLedPin, redLedPin)

function temp_monitor(a, tempPin, greenLedPin, yellowLedPin, redLedPin)
    V0C=500; TC=10;
    % Initialize the figure for the live graph
    figure;
    h = animatedline;
    xlabel('Time (s)');
    ylabel('Temperature (°C)');
    
    % Initialize the time
    startTime = datetime('now');
    
    % Continuously monitor the temperature
    while true
        % Read the temperature value from the sensor
        temperature = (readVoltage(a, tempPin)*10000-V0C)/TC; % Replace this with your actual temperature reading
        
        % Add the new data point to the graph
        addpoints(h, seconds(datetime('now') - startTime), temperature);
        
        % Adjust the x-axis limits and y-axis limits
        xlim([0, seconds(datetime('now') - startTime) + 1]);
        ylim([min(temperature)-1, max(temperature)+1]);
        
        % Update the graph
        drawnow;
        
        % Control the LEDs according to the measured temperature
        if temperature >= 18 && temperature <= 24
            % When the temperature is in the range 18-24 °C, the green LED should show a constant light
            writeDigitalPin(a, greenLedPin, 1);
            writeDigitalPin(a, yellowLedPin, 0);
            writeDigitalPin(a, redLedPin, 0);
        elseif temperature < 18
            % When the temperature is below the range, the yellow LED should blink intermittently at 0.5 s intervals
            writeDigitalPin(a, greenLedPin, 0);
            writeDigitalPin(a, yellowLedPin, 1);
            pause(0.5);
            writeDigitalPin(a, yellowLedPin, 0);
            pause(0.5);
        else
            % When the temperature is above the range, the red LED should blink intermittently at 0.25 s intervals
            writeDigitalPin(a, greenLedPin, 0);
            writeDigitalPin(a, redLedPin, 1);
            pause(0.25);
            writeDigitalPin(a, redLedPin, 0);
            pause(0.25);
        end
    end
end

