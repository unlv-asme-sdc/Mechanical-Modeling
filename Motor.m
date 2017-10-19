classdef Motor

	properties
		voltage = 12;
		motor_name = '';
		% motors stall properties
		stall_torque;
		stall_current; 
		% motors free load properties
		free_rpm;
		free_current; 
		gear = 1;
	end

	methods
		% Parameters
			% FREE_RPM, angular velocity in RPM
			% FREE_CURRENT, current in Amps
			% STALL_TORQUE, in ounces-inches
			% STALL_CURRENT, current in Amps

		function obj = Motor(FREE_RPM, FREE_CURRENT, STALL_TORQUE, STALL_CURRENT, MOTOR_NAME)
			if(nargin >= 4)
				obj.free_rpm = FREE_RPM;
				obj.free_current = FREE_CURRENT;
				obj.stall_torque = STALL_TORQUE;
				obj.stall_current = STALL_CURRENT;
				if(ischar(MOTOR_NAME))
					obj.motor_name = MOTOR_NAME;
				end
			else
				% TODO add error throw
			end

		end

		function plot_speed_curve(obj)
			% TODO Make multi-scale display
			% TODO Use matlab's built in unit properties
			figure('Name', 'Speed-Torque Curve');
			free_rpm = obj.free_rpm;
			free_current = obj.free_current;
			stall_torque = obj.stall_torque;
			stall_current = obj.stall_current;
			gear = obj.gear;
			voltage = obj.voltage;
			motor_name = obj.motor_name;
			steps = 200;
			amps = linspace(0, stall_current, steps);

			% plots rpm
			plot([0, stall_current], [free_rpm/gear, 0]);
			ylabel('RPM');
			hold on

			% plots power and scales it down
			amp = linspace(free_current,  stall_current, steps);
			torque = linspace(0, stall_torque*gear, steps);
			rpm = linspace(free_rpm/gear, 0, steps);
			power = torque*0.007061551833333.*rpm*2*pi/60; % converts oz*in * rpm to N*m * rad/s
			plot(amps, (power * (max(rpm)/max(power))));


			% plots effeciency
			eff = power./(amp*voltage)*100;
			plot(amps, (eff * (max(rpm)/max(eff))));

			% plots torque
			yyaxis right
			plot([0, stall_current], [0, stall_torque*gear]);
			ylabel('Torque(oz-in)');
			
			% Plot's properties
			legend('RPM', 'Power', 'effeciency', 'Torque');
			label = sprintf('Speed-Torque Curve for %s, at gear ratio 1:%.d', motor_name, gear); 
			title(label);
			xlabel('Current');

		end
			

	end

end
