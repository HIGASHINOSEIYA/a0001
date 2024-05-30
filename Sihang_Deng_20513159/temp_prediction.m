% TEMP_PREDICTION Function
% This function continuously monitors the temperature from a sensor connected to an Arduino board. 
% It calculates the rate of temperature change in °C/s, predicts the temperature value in 5 minutes, 
% and controls three LEDs (green, yellow, and red) based on the rate of temperature change:
% - Green LED is constantly on when the temperature is stable within the comfort range.
% - Red LED is constantly on when the temperature is increasing at a rate greater than +4°C/min.
% - Yellow LED is constantly on when the temperature is decreasing at a rate greater than -4°C/min.
% Usage: temp_prediction(a, tempPin, greenLedPin, yellowLedPin, redLedPin)


function temp_prediction(a, tempPin, greenLedPin, yellowLedPin, redLedPin)
V0C=500; TC=10;   
    % Initialize the figure for the live graph
    figure;
    h = animatedline;
    xlabel('Time (s)');
    ylabel('Temperature (°C)');
    
 % Initialize the time
    startTime = datetime('now');
    prevTime = startTime;
    prevTemp = (readVoltage(a, tempPin)*10000-V0C)/TC;
    maxTemp=prevTemp;miniTemp=prevTemp;
    
 % Continuously monitor the temperature
    while true
        % Read the temperature value from the sensor
        currentTemp = (readVoltage(a, tempPin)*10000-V0C)/TC;  % Read the temperature value from the sensor
        currentTime = datetime('now');
   
     rateOfChange =  (currentTemp - prevTemp)/ seconds(currentTime - prevTime)*60;
       
         % Print the rate of change to the screen
        fprintf('Rate of change: %.2f °C/min\n', rateOfChange);
        
        % Predict the temperature in 5 minutes
        predictedTemp = currentTemp + rateOfChange * 5;
      
        % Print the current and predicted temperatures to the screen
        fprintf('Current temperature: %.2f °C\n', currentTemp);
        fprintf('Predicted temperature in 5 minutes: %.2f °C\n', predictedTemp);

       if currentTemp>maxTemp
          maxTemp=currentTemp;
       end
       if currentTemp<miniTemp
          miniTemp=currentTemp;
       end
        % Add the new data point to the graph
        addpoints(h, seconds(currentTime - startTime), currentTemp);
        
        % Adjust the x-axis limits and the y-axis limits
        xlim([0, seconds(datetime('now') - startTime) + 1]);
        ylim([miniTemp-1, maxTemp+1]);
        
        % Update the graph
        drawnow;
              
        % Control the LEDs according to the rate of change
        if rateOfChange <= -4
            % Temperature is decreasing too fast
            writeDigitalPin(a, greenLedPin, 0);
            writeDigitalPin(a, yellowLedPin, 1);
            writeDigitalPin(a, redLedPin, 0);
        elseif rateOfChange > 4
            % Temperature is increasing too fast
            writeDigitalPin(a, greenLedPin, 0);
            writeDigitalPin(a, yellowLedPin, 0);
            writeDigitalPin(a, redLedPin, 1);
        else
            % Temperature is stable
            writeDigitalPin(a, greenLedPin, 1);
            writeDigitalPin(a, yellowLedPin, 0);
            writeDigitalPin(a, redLedPin, 0);
        end
        
        % Update the previous temperature and time
        prevTemp = currentTemp;
        prevTime = currentTime;
        pause(1);
    end
end