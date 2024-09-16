classdef transient_tline < handle
    %TRANSIENT_TLINE is a model for a transient transmission line.
    %
    %   TRANSIENT_TLINE(tline_config) creates a transient transmission line
    %   object... .
    %
    %   TRANSIENT_TLINE creates a transient transmission object with preset
    %   properties.
    %
    %   Note:
    %
    %   Example:
    %      T = transient_tline
    %
    %   See also STEADY_STATE_TLINE, TLINE_SIM.
    
    %   Created by Keaton Scheible
    %   License info
    
    
    %% Properties
    properties
        
        % Source Properties
        zs          % Source impedance
        src_config  % Source configuration
        vs_amp      % Source amplitude
        tr          % Rise time of input
        freq        % Source frequency
        
        % Transmission Line Properties
        tline_config    % Transmission line configuration
        z0          % Characteristic impedance
        td          % Propagation delay
        epsilon_r   % Relative permeability
        
        % Load Properties
        load_config % Configuration of load
        rl          % Load resistance
        cl          % Load capacitance
        ll          % Load inductance
        
        % Animation Properties
        ts          % Stop time of simulation
        precision   % Precision of animation data (Number of points per td
        
        % Animation Data
        v_src       % Voltage at the source
        v_load      % Voltage at the load
        v_tline     % Voltage across transmission line
        v_fwd_tline % Forward travelling voltage wave across the transmssion line
        v_bck_tline % Backward travelling voltage wave across the transmission line
        v_fwd_src   % Forward travelling voltage wave leaving from the source
        v_bck_load  % Backward travelling voltage wave leaving from the load
        i_src       % Current at the source
        i_load      % Current at the load
        i_tline     % Current across transmission line
        i_fwd_tline % Forward travelling current wave across the transmssion line
        i_bck_tline % Backward travelling current wave across the transmission line
        i_fwd_src   % Forward travelling current wave leaving from the source
        i_bck_load  % Backward travelling current wave leaving from the load
        
        % Laplace Transform Variables
        s           % Symbolic variable for laplace transform
        t           % Symbolic variable for laplace transform
        
    end
    
    properties(Dependent)
        
        % Source Properties
        vs      % Source voltage
        omega   % Angular frequency
        GAMMA_S % Source reflection coefficient
        
        % Transmission Line Properties
        dist    % Distance array (Holds values ranging from 0 to the length of the line)
        vp      % Velocity of propagation
        lambda  % Wavelength
        line_length % Length of Transmission Line
        
        
        % Load Properties
        zl      % Load impedance
        GAMMA_L % Load reflection coefficient
        
        % Animation Properties
        time    % Time for simulation to run
        num_pts % Number of samples for simulation
        
    end
    
    properties(SetAccess = immutable)
        animation_type  % Type of animation (Transient or Steady State)
    end
    
    %% Methods
    
    methods
        
        % Transient transmission line constructor
        function obj = transient_tline(varargin)
            
            % If source configuration was provided
            if(nargin == 1)
                
                % Create transmission line object
                obj = varargin{1};
                
                % If configuration file was not a transient transmission line 
                if(~strcmp(obj.animation_type,'transient'))
                    % Throw an error
                    warning('Only transient transmission line configuration files are accepted');                    
                end
                
            % Otherwise, set transmission line parameters as shown below
            else
                
                % Animation type (do not change)
                obj.animation_type = 'transient';
            
                % Source Properties
                obj.src_config = 'step';    % Source configuration
                obj.vs_amp = 1;             % Source amplitude
                obj.tr = 1e-9;              % Rise time of input
                obj.zs = 50;                % Source impedance
                obj.freq = 1e9;             % Source frequency
                
                % Transmission Line Properties
                obj.tline_config = 'lossless';  % Transmission line configuration 
                obj.z0 = 50;                    % Characteristic impedance
                obj.td = 1e-9;                  % Propagation delay
                obj.epsilon_r = 1;              % Relative permittivity
                
                % Load Properties
                obj.load_config = 'R';      % Configuration of load
                obj.rl = 25;               % Load resistance
                obj.cl = 5e-12;             % Load capacitance
                obj.ll = 25e-6;             % Load inductance
                
                % Animation Settings
                obj.ts = 3e-9;            % Stop time of simulation
                obj.precision = 100;        % Precision of animation data (Number of points per td)
                
                % Laplace Transform Symbolic Variables
                obj.s = sym('s');           % Symbolic variable for laplace transform
                obj.t = sym('t');           % Symbolic variable for laplace transform
            end
        end
        
        % Update all of voltage and current waves on the transmission line
        % and the voltages and currents at the source and the load. This is
        % called in the GUI when the animation is started if there have
        % been any adjustments to the parameters that affect the voltages
        % and currents on the transmission line.
        function update_props(obj)
            obj.update_v_src;
            obj.update_i_src;
            obj.update_v_load;
            obj.update_i_load;
            obj.update_v_fwd_src;
            obj.update_i_fwd_src;
            obj.update_v_bck_load;
            obj.update_i_bck_load;
            obj.update_v_tline;
            obj.update_i_tline;
        end
        
        
        %% Source Methods
        
        % Update angular frequency
        function result = get.omega(obj)
            result = 2*pi*obj.freq;
        end
        
        % Update voltage source
        function result = get.vs(obj)
            
            % Set voltage source based source configuration
            switch(lower(obj.src_config))
                % Step Source
                case 'step'
                    result = obj.vs_amp * (1/obj.s);
                    % Ramped Step Source
                case 'ramped_step'
                    if(obj.tr == 0)
                        result = obj.vs_amp * (1/obj.s);
                    else
                        result = obj.vs_amp * (1 -exp(-obj.tr*obj.s))/(obj.tr*obj.s^2);
                    end
                    % Sinusoidal Source
                case 'sine'
                    result = obj.vs_amp * (obj.omega/(obj.s^2 +obj.omega^2));
                otherwise
                    warning('Source is not supported\n')
                    % Source that was entered is not supported
                    result = nan;
            end
        end
        
        % Update source reflection coefficient
        function result = get.GAMMA_S(obj)
            result = (obj.zs-obj.z0)/(obj.zs+obj.z0);
        end
        
        
        %% Transmission Line Methods
                       
        % Update distance array
        % (Holds values ranging from 0 to the length of the line)
        function result = get.dist(obj)
            result = linspace(0, obj.line_length, obj.precision);
        end
        
        % Update velocity of propagation
        function result = get.vp(obj)
            result = 299792458/sqrt(obj.epsilon_r);
        end
        
        % Update wavelength
        function result = get.lambda(obj)
            result = obj.vp/obj.freq;   % Vp/f
        end
        
        % Update length of transmission line
        function result = get.line_length(obj)
            result = obj.td*obj.vp;
        end
        
        
        %% Load Methods
        
        % Update load impedance
        function result = get.zl(obj)
            
            % Function for calculating parallel circuits with 2 inputs
            par2 = @(x1,x2) (1/x1 + 1/x2)^-1;
            % Function for calculating parallel circuits with 3 inputs
            par3 = @(x1,x2,x3) (1/x1 + 1/x2 + 1/x3)^-1;
            
            % Set time constants based on load configuration
            switch(obj.load_config)
                % Load is a resistor
                case 'R'
                    result = obj.rl;
                    % Load is a capacitor
                case 'C'
                    result = 1/(obj.s*obj.cl);
                    % Load is an inductor
                case 'L'
                    result = obj.s*obj.ll;
                    % Load is a resistor and a capacitor in series
                case 'R_ser_C'
                    result = obj.rl + 1/(obj.s*obj.cl);
                    % Load is a resistor and an inductor in series
                case 'R_ser_L'
                    result = obj.rl + obj.s*obj.ll;
                    % Load is a resistor and a capacitor in paralell
                case 'R_par_C'
                    result = par2(obj.rl,1/(obj.s*obj.cl));
                    % Load is a resistor and an inductor in paralell
                case 'R_par_L'
                    result = par2(obj.rl,obj.s*obj.ll);
                    % Load is a resistor, inductor and capacitor in paralell
                case 'R_par_L_par_C'
                    result = par3(obj.rl,1/(obj.s*obj.cl),obj.s*obj.ll);
                    % Load is a capacitor and an inductor in series
                case 'R_ser_L_ser_C'
                    result = obj.rl + 1/(obj.s*obj.cl) + obj.s*obj.ll;
                    % Load is not supported
                otherwise
                    warning('Load is not supported\n')
                    % Load Impedance that was entered is not supported
                    result = nan;
            end
        end
        
        % Update load reflection coefficient
        function result = get.GAMMA_L(obj)
            result = (obj.zl-obj.z0)/(obj.zl+obj.z0);
        end
        
        
        %% Animation Properties Methods
        
        % Update number of points
        function result = get.num_pts(obj)
            result = ceil(obj.precision*obj.ts/obj.td);
        end
        
        % Update time for simulation to run
        function result = get.time(obj)
            result = linspace(0,obj.ts,obj.num_pts)';
        end
        
        
        %% Animation Data Methods
        
        % Update voltage at the source.
        % This is a 1-D array that is the same length as the time array.
        % It represents voltage over time.
        function update_v_src(obj)
            
            % Initialize laplace equation. The initial value of 1
            % represents the initial voltage wave that is leaving from the
            % source.
            v_src_laplace = 1;
            
            % Loop for each time a voltage wave reflects off of the source
            % and build the laplace equation that describes the voltage
            % at the source.
            for k = 2:2:floor(obj.ts/obj.td) 
                % Source voltage laplace equation
                v_src_laplace = v_src_laplace + ...
                    exp(-k*obj.td*obj.s) * ...          % Delay by k*td
                    obj.GAMMA_L*(1+obj.GAMMA_S) * ...   % First reflection off the load, and then off the source
                    (obj.GAMMA_S*obj.GAMMA_L)^(k/2-1);  % Sucessive reflections off of the load and source
            end
            
            % Create symbolic function for the source voltage
            v_src_sym_fun = symfun(vpa(ilaplace(obj.vs/2 * (1-obj.GAMMA_S) * v_src_laplace)),obj.t);
            
            % Calculate voltage at source
            obj.v_src = double(v_src_sym_fun(obj.time));
            
        end
        
        % Update current at the source.
        % This is a 1-D array that is the same length as the time array.
        % It represents current over time.
        function update_i_src(obj)
            
            % Initialize laplace equation. The initial value of 1
            % represents the initial current wave that is leaving from the
            % source.
            i_src_laplace = 1/obj.z0;
            
            % Loop for each time a current wave reflects off of the source
            % and build the laplace equation that describes the current
            % at the source.
            for k = 2:2:floor(obj.ts/obj.td) 
                % Source current laplace equation
                i_src_laplace = i_src_laplace - ...
                    1/obj.z0 * ...                      % Divide by characteristic impedance to calculate current
                    exp(-k*obj.td*obj.s) * ...          % Delay by k*td
                    obj.GAMMA_L*(1-obj.GAMMA_S) * ...   % First reflection off the load, and then off the source
                    (obj.GAMMA_S*obj.GAMMA_L)^(k/2-1);  % Sucessive reflections off of the load and source
            end
            
            % Create symbolic function for the source current
            i_src_sym_fun = symfun(vpa(ilaplace(obj.vs/2 * (1-obj.GAMMA_S) * i_src_laplace)),obj.t);
            
            % Calculate current at source
            obj.i_src = double(i_src_sym_fun(obj.time));
            
        end
        
        % Update voltage at the load
        % This is a 1-D array that is the same length as the time array.
        % It represents voltage over time.
        function update_v_load(obj)
            
            % Initialize laplace equation. The initial value of 0
            % represents the initial voltage at the load is 0.
            v_load_laplace = 0;
            
            % Loop for each time a voltage wave reflects off of the load
            % and build the laplace equation that describes the voltage
            % at the load.
            for k = 1:2:floor(obj.ts/obj.td) 
                % Load voltage laplace equation
                v_load_laplace = v_load_laplace + ...
                    exp(-k*obj.td*obj.s) * ...             % Delay by k*td
                    (1+obj.GAMMA_L) * ...                  % First reflection off the load
                    (obj.GAMMA_S*obj.GAMMA_L)^((k-1)/2);   % Sucessive reflections off the the load and source
            end
            
            % Create symbolic function for the load voltage
            v_load_sym_fun = symfun(vpa(ilaplace(obj.vs/2 * (1-obj.GAMMA_S) * v_load_laplace)),obj.t);
            
            % Calculate voltage at load
            obj.v_load = double(v_load_sym_fun(obj.time));
            
        end
        
        % Update current at the load
        % This is a 1-D array that is the same length as the time array.
        % It represents current over time.
        function update_i_load(obj)
            
            % Initialize laplace equation. The initial value of 0
            % represents the initial current at the load is 0.
            i_load_laplace = 0;
            
            % Loop for each time a current wave reflects off of the load
            % and build the laplace equation that describes the current
            % at the load.
            for k = 1:2:floor(obj.ts/obj.td) 
                % Load current laplace equation
                i_load_laplace = i_load_laplace + ...
                    1/obj.z0 * ...                         % Divide by characteristic impedance to calculate current
                    exp(-k*obj.td*obj.s) * ...             % Delay by k*td
                    (1-obj.GAMMA_L) * ...                  % First reflection off the load
                    (obj.GAMMA_S*obj.GAMMA_L)^((k-1)/2);   % Sucessive reflections off the the load and source
            end
            
            % Create symbolic function for the load current
            i_load_sym_fun = symfun(vpa(ilaplace(obj.vs/2 * (1-obj.GAMMA_S) * i_load_laplace)),obj.t);
            
            % Calculate current at load
            obj.i_load = double(i_load_sym_fun(obj.time));
            
        end
        
        % Update forward traveling voltage wave that is leaving from the
        % source. This is used to create the forward traveling voltage
        % wave across the transmission line in the update_v_tline function.
        % This is a 1-D array that is the same length as the time array.
        % It represents voltage over time.
        function update_v_fwd_src(obj)
            
            % Initialize laplace equation. The initial value of 1
            % represents the initial voltage wave that is leaving from the
            % source.
            v_fwd_src_laplace = 1;
            
            % Loop for each time a voltage wave reflects off of the source
            % and build the laplace equation that describes the voltage
            % wave leaving from the source.
            for k = 2:2:floor(obj.ts/obj.td) 
                v_fwd_src_laplace = v_fwd_src_laplace + ...
                    exp(-k*obj.td*obj.s) * ...          % Delay by k*td
                    (obj.GAMMA_S*obj.GAMMA_L)^(k/2);    % Reflections off the load and then the source
            end
            
            % Create symbolic function for the forward travling voltage
            % wave leaving from the source.
            v_fwd_src_sym_fun = symfun(vpa(ilaplace(obj.vs/2 * (1-obj.GAMMA_S) * v_fwd_src_laplace)),obj.t);
            
            % Calculate forward travling voltage wave leaving from the
            % source.
            obj.v_fwd_src = double(v_fwd_src_sym_fun(obj.time));
            
        end
        
        % Update backward traveling voltage wave that is leaving from the
        % load. This is used to create the backward traveling voltage
        % wave across the transmission line in the update_v_tline function.
        % This is a 1-D array that is the same length as the time array.
        % It represents voltage over time.
        function update_v_bck_load(obj)
            
            % Initialize laplace equation. The initial value of 0
            % represents that there is no initial voltage wave that is
            % leaving from the load.
            v_bck_load_laplace = 0;
            
            % Loop for each time a voltage wave reflects off of the load
            % and build the laplace equation that describes the voltage
            % wave leaving from the load.
            for k = 1:2:floor(obj.ts/obj.td) 
                v_bck_load_laplace = v_bck_load_laplace + ...
                    exp(-k*obj.td*obj.s) * ...              % Delay by k*td
                    obj.GAMMA_L * ...                       % First reflection off the load
                    (obj.GAMMA_S*obj.GAMMA_L)^((k-1)/2);    % Sucessive reflections off the source and then the load
            end
            
            % Create symbolic function for the backward travling voltage
            % wave leaving from the load.
            v_bck_load_sym_fun = symfun(vpa(ilaplace(obj.vs/2 * (1-obj.GAMMA_S) * v_bck_load_laplace)),obj.t);
            
            % Calculate backward travling voltage wave leaving from the
            % load.
            obj.v_bck_load = double(v_bck_load_sym_fun(obj.time));
        end
        
        % Update forward traveling current wave that is leaving from the
        % source. This is used to create the forward traveling current
        % wave across the transmission line in the update_i_tline function.
        % This is a 1-D array that is the same length as the time array.
        % It represents current over time.
        function update_i_fwd_src(obj)
            
            % Calculate forward travling current wave leaving from the source.
            obj.i_fwd_src = obj.v_fwd_src/obj.z0;
            
        end
        
        % Update backward traveling current wave that is leaving from the
        % load. This is used to create the backward traveling current
        % wave across the transmission line in the update_v_tline function.
        % This is a 1-D array that is the same length as the time array.
        % It represents current over time.
        function update_i_bck_load(obj)
            % Calculate backward travling current wave leaving from the load.
            obj.i_bck_load = -obj.v_bck_load/obj.z0;
        end
        
        % Update the forward traveling voltage wave across the transmission
        % line, the backward travling voltage wave across the transmission
        % line, and the overall voltage across the transmission line. Each
        % column of these arrays represents the voltage at a particular
        % location on the transmission line, and each row represents a
        % different instant in time.
        function update_v_tline(obj)
            
            % Initialize arrays to 0
            obj.v_tline = zeros(obj.num_pts,obj.precision);       % Voltage across transmission line
            obj.v_fwd_tline = zeros(obj.num_pts,obj.precision);   % Forward traveling voltage wave on transmission line
            obj.v_bck_tline = zeros(obj.num_pts,obj.precision);   % Backward traveling voltage wave on transmission line
            
            % Loop over all of the points in the simulation
            for k = 2:obj.num_pts
                
                % Shift register that shifts the forward traveling voltage
                % wave leaving from the source into the left side of an
                % array that holds the forward traveling voltage wave on
                % the transmission line. The oldest forward traveling
                % voltage wave value is shifted off the right end of the
                % array.
                obj.v_fwd_tline(k,:) = [obj.v_fwd_src(k),obj.v_fwd_tline(k-1,1:end-1)];
                
                % Shift register that shifts the backward traveling voltage
                % wave leaving from the load into the right side of an
                % array that holds the backward traveling voltage wave on
                % the transmission line. The oldest backward traveling
                % voltage wave value is shifted off the left end of the
                % array.
                obj.v_bck_tline(k,:) = [obj.v_bck_tline(k-1,2:end),obj.v_bck_load(k)];
                
                % The sum of the forward traveling voltage wave and the
                % backward traveling voltage wave on the transmission line
                % is the overall voltage across the transmission line.
                obj.v_tline(k,:) = obj.v_fwd_tline(k,:) + obj.v_bck_tline(k,:);
                
            end
        end
        
        % Update the forward traveling current wave across the transmission
        % line, the backward travling current wave across the transmission
        % line, and the overall current across the transmission line. Each
        % column of these arrays represents the current at a particular
        % location on the transmission line, and each row represents a
        % different instant in time.
        function update_i_tline(obj)
            
            % Initialize arrays to 0
            obj.i_tline = zeros(obj.num_pts,obj.precision);       % Current across transmission line
            obj.i_fwd_tline = zeros(obj.num_pts,obj.precision);   % Forward traveling current wave on transmission line
            obj.i_bck_tline = zeros(obj.num_pts,obj.precision);   % Backward traveling current wave on transmission line
            
            % Loop over all of the points in the simulation
            for k = 2:obj.num_pts
                
                % Shift register that shifts the forward traveling current
                % wave leaving from the source into the left side of an
                % array that holds the forward traveling current wave on
                % the transmission line. The oldest forward traveling
                % current wave value is shifted off the right end of the
                % array.
                obj.i_fwd_tline(k,:) = [obj.i_fwd_src(k),obj.i_fwd_tline(k-1,1:end-1)];
                
                % Shift register that shifts the backward traveling current
                % wave leaving from the load into the right side of an
                % array that holds the backward traveling current wave on
                % the transmission line. The oldest backward traveling
                % current wave value is shifted off the left end of the
                % array.
                obj.i_bck_tline(k,:) = [obj.i_bck_tline(k-1,2:end),obj.i_bck_load(k)];
                
                % The difference between the forward traveling current wave
                % and the backward traveling current wave on the
                % transmission line is the overall voltage across the
                % transmission line.
                obj.i_tline(k,:) = (obj.i_fwd_tline(k,:) + obj.i_bck_tline(k,:));
                
            end
        end
        
    end
    
end


