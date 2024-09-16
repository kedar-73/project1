classdef steady_state_tline < handle
    %STEADY_STATE_TLINE is a model for a transient transmission line.
    %
    %   STEADY_STATE_TLINE(tline_config) creates a steady state transmission line
    %   object... .
    %
    %   STEADY_STATE_TLINE creates a steady state transmission object with preset
    %   properties.
    %
    %   Note:
    %
    %   Example:
    %      T = steady_state_tline
    %
    %   See also TLINE_SIM, TRANSIENT_TLINE.
    
    %   Created by Keaton Scheible
    %   License info
    
    
    %% Properties
    properties
        
        % Source Properties
        src_config % Source configuration (Only sine supported at this time)
        zs          % Source impedance
        vs_amp      % Source amplitude
        freq        % Source frequency
        
        % Transmission Line Properties
        tline_config    % Transmission line configuration
        L           % Inductance per meter
        C           % Capacitance per meter
        R           % Resistance per meter
        G           % Conductance per meter
        line_length % Length of Transmission Line
        
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
        v_env_tline % Voltage envelope across the transmission line
        i_src       % Current at the source
        i_load      % Current at the load
        i_tline     % Current across transmission line
        i_fwd_tline % Forward travelling current wave across the transmssion line
        i_bck_tline % Backward travelling current wave across the transmission line
        i_env_tline % Current envelope across the transmission line
        
    end
    
    properties(Dependent)
        
        % Source Properties
        omega   % Angular frequency
        GAMMA_S % Source Reflection Coefficient
        
        % Transmission Line Properties
        z0      % Characteristic Impedance
        gamma   % Propagation Constant
        v_inc   % Incident wave voltage
        dist    % Distance array (Holds values ranging from 0 to the length of the line)
        td      % Propagation delay
        p_end   % Propagation factor
        p_fwd   % Forward propagation factor array
        p_bck   % Backward propagation factor array
        beta    % Phase Constant
        alpha   % Attenuation Constant
        vp      % Velocity of propagation
        lambda  % Wavelength
        vswr    % Voltage Standing Wave Ratio
        epsilon_r   % Relative permittivity
        
        % Load Properties
        zl      % Load impedance
        GAMMA_L % Load Reflection Coefficient
        
        % Animation Properties
        time    % Time for simulation to run
        num_pts % Number of samples for simulation
        
    end
    
    properties(SetAccess = immutable)
        animation_type  % Type of animation (Transient or Steady State)
    end
    
    %% Methods
    
    methods
        % Steady state transmission line constructor
        function obj = steady_state_tline(varargin)
            
            % If configuration file was provided 
            if(nargin == 1)
                
                % Create transmission line object
                obj = varargin{1};
                
                % If configuration file was not a steady state transmission line 
                if(~strcmp(obj.animation_type,'steady_state'))
                    % Throw an error
                    error('Only steady state transmission line configuration files are accepted');                    
                end
                
                % Otherwise, set transmission line parameters as shown below
            else
                
                % Animation type (do not change)
                obj.animation_type = 'steady_state';
                
                % Source Configuration (do not change)
                obj.src_config = 'sine';
                
                % Source Properties
                obj.zs = 50;            % Source impedance
                obj.vs_amp = 1;              % Source amplitude
                obj.freq = 1e9;         % Source frequency
                
                % Transmission Line Properties
                obj.tline_config = 'lossy'; % Transmission line configuration 
                obj.L = 3.5e-7;             % Inductance per meter
                obj.C = 1.4e-10;            % Capacitance per meter
                obj.R = 250;                % Resistance per meter
                obj.G = 0.1;                % Conductance per meter
                obj.line_length = 0.286;    % Length of Transmission Line
                
                % Load Properties
                obj.load_config = 'R';  % Configuration of load
                obj.rl = 50;            % Load resistance
                obj.cl = 5e-12;         % Load capacitance
                obj.ll = 10e-9;         % Load inductance
                
                % Animation Properties
                obj.ts = 5e-9;          % Stop time of simulation
                obj.precision = 100;    % Precision of animation data (Number of points per td
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
            obj.update_v_tline;
            obj.update_i_tline;
            obj.update_v_env_tline;
            obj.update_i_env_tline;
        end
        
        
        %% Source Methods
        
        % Update angular frequency
        function result = get.omega(obj)
            result = 2*pi*obj.freq; % 2*pi*freq
        end
        
        % Update source reflection coefficient
        function result = get.GAMMA_S(obj)
            result = (obj.zs - obj.z0)/(obj.z0 + obj.zs);
        end
        
        
        
        %% Transmission Line Methods
        
        % Update characteristic impedance
        function result = get.z0(obj)
            result = sqrt((obj.R+1i*obj.omega*obj.L)/(obj.G+1i*obj.omega*obj.C));   % sqrt((R + jw*L)/(G+jw*C))
        end
        
        % Update propagation constant
        function result = get.gamma(obj)
            result = sqrt((obj.R+1i*obj.omega*obj.L)*(obj.G+1i*obj.omega*obj.C));   % sqrt((R + jw*L)*(G+jw*C))
        end

        % Update incident wave voltage
        function result = get.v_inc(obj)
            result = obj.vs_amp*(obj.z0/(obj.zs+obj.z0));
        end
                
        % Update distance array
        % (Holds values ranging from 0 to the length of the line)
        function result = get.dist(obj)
            result = linspace(0, obj.line_length, obj.precision);
        end
        
        % Update time delay of line
        function result = get.td(obj)
            result = obj.line_length/obj.vp; % Length/Vp
        end
        
        % Update propagation factor
        function result = get.p_end(obj)
            result = exp(-obj.gamma*obj.dist(end));
        end
        
        % Update forward propagation factor array
        function result = get.p_fwd(obj)
            result = exp(-obj.gamma*obj.dist);
        end
        
        % Update backward propagation factor array
        function result = get.p_bck(obj)
            result = fliplr(exp(-obj.gamma*obj.dist));
        end
        
        % Update phase constant
        function result = get.beta(obj)
            result = imag(obj.gamma);   % imag(gamma)
        end
        
        % Update attenuation constant
        function result = get.alpha(obj)
            result = real(obj.gamma);   % real(gamma)
        end
        
        % Update propagation velocity
        function result = get.vp(obj)
            result = obj.omega/obj.beta;    % omega/beta
        end
        
        % Update wavelength
        function result = get.lambda(obj)
            result = obj.vp/obj.freq;   % Vp/f
        end
        
        % Update voltage standing wave ratio
        function result = get.vswr(obj)
            result = (1+abs(obj.GAMMA_L))/(1-abs(obj.GAMMA_L));   
        end
        
        % Update relative permittivity
        function result = get.epsilon_r(obj)
            result = (299792458/obj.vp)^2;   
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
                    result = 1/(1i*obj.omega*obj.cl);
                    % Load is an inductor
                case 'L'
                    result = 1i*obj.omega*obj.ll;
                    % Load is a resistor and a capacitor in series
                case 'R_ser_C'
                    result = obj.rl + 1/(1i*obj.omega*obj.cl);
                    % Load is a resistor and an inductor in series
                case 'R_ser_L'
                    result = obj.rl + 1i*obj.omega*obj.ll;
                    % Load is a resistor and a capacitor in paralell
                case 'R_par_C'
                    result = par2(obj.rl,1/(1i*obj.omega*obj.cl));
                    % Load is a resistor and an inductor in paralell
                case 'R_par_L'
                    result = par2(obj.rl,1i*obj.omega*obj.ll);
                    % Load is a resistor, inductor and capacitor in paralell
                case 'R_par_L_par_C'
                    result = par3(obj.rl,1/(1i*obj.omega*obj.cl),1i*obj.omega*obj.ll);
                    % Load is a capacitor and an inductor in series
                case 'R_ser_L_ser_C'
                    result = obj.rl + 1/(1i*obj.omega*obj.cl) + 1i*obj.omega*obj.ll;
                    % Load is not supported
                otherwise
                    warning('Load is not supported\n')
                    % Load Impedance that was entered is not supported
                    result = nan;
            end
        end
        
        % Update load reflection coefficient
        function result = get.GAMMA_L(obj)
            result = (obj.zl - obj.z0)/(obj.z0 + obj.zl);
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
                
        % Update voltage at the source
        % This is a 1-D array that is the same length as the time array.
        % It represents voltage over time.
        function update_v_src(obj)
            % Calculate the voltage at the source
            obj.v_src = obj.cplx2time(obj.v_inc * (1 + (obj.p_end^2*obj.GAMMA_L*(1+obj.GAMMA_S)) / (1 - obj.p_end^2*obj.GAMMA_L*obj.GAMMA_S)));              
        end
        
        % Update current at the source
        % This is a 1-D array that is the same length as the time array.
        % It represents current over time.
        function update_i_src(obj)        
            % Calculate the current at the source
            obj.i_src = obj.cplx2time(obj.v_inc / obj.z0 * (1-obj.p_end^2*obj.GAMMA_L) / (1 - obj.p_end^2*obj.GAMMA_L*obj.GAMMA_S));
        end
        
        % Update voltage at the load
        % This is a 1-D array that is the same length as the time array.
        % It represents voltage over time.
        function update_v_load(obj)
            % Calculate the voltage at the load
            obj.v_load = obj.cplx2time(obj.v_inc * (obj.p_end*(1+obj.GAMMA_L)) / (1 - obj.p_end^2*obj.GAMMA_L*obj.GAMMA_S));           
        end
        
        % Update current at the load
        % This is a 1-D array that is the same length as the time array.
        % It represents current over time.
        function update_i_load(obj)          
            % Calculate the current at the load
            obj.i_load = obj.cplx2time(obj.v_inc / obj.z0 * (obj.p_end*(1-obj.GAMMA_L)) / (1 - obj.p_end^2*obj.GAMMA_L*obj.GAMMA_S));
        end
        
        
        % Update the forward traveling voltage wave across the transmission
        % line, the backward travling voltage wave across the transmission
        % line, and the overall voltage across the transmission line. Each
        % column of these arrays represents the voltage at a particular
        % location on the transmission line, and each row represents a
        % different instant in time.
        function update_v_tline(obj)
            
            % Complex voltages of the forward traveling voltage wave
            v_fwd_tline_complex = (obj.v_inc * obj.p_fwd) ./ (1 - obj.p_end^2*obj.GAMMA_L*obj.GAMMA_S);
            
            % Complex voltages of the backward traveling voltage wave
            v_bck_tline_complex = (obj.v_inc * obj.p_bck * obj.p_end * obj.GAMMA_L) ./ (1 - obj.p_end^2*obj.GAMMA_L*obj.GAMMA_S);
            
            % Calculate the forward traveling voltage wave across the transmission line
            obj.v_fwd_tline = obj.cplx2time(v_fwd_tline_complex);
            
            % Calculate the backward traveling voltage wave across the transmission line
            obj.v_bck_tline = obj.cplx2time(v_bck_tline_complex);
            
            % Calculate the overall voltage across the transmission line
            obj.v_tline = obj.cplx2time(v_fwd_tline_complex + v_bck_tline_complex);
                        
        end
        
        % Update the forward traveling current wave across the transmission
        % line, the backward travling current wave across the transmission
        % line, and the overall current across the transmission line. Each
        % column of these arrays represents the current at a particular
        % location on the transmission line, and each row represents a
        % different instant in time.
        function update_i_tline(obj)
                        
            % Complex currents of the forward traveling current wave
            i_fwd_tline_complex = obj.v_inc/obj.z0 * (obj.p_fwd) ./ (1 - obj.p_end^2*-obj.GAMMA_L*-obj.GAMMA_S);
            
            % Complex currents of the backward traveling current wave
            i_bck_tline_complex = obj.v_inc/obj.z0 * (obj.p_bck * obj.p_end * -obj.GAMMA_L) ./ (1 - obj.p_end^2*-obj.GAMMA_L*-obj.GAMMA_S);
            
            % Calculate the forward traveling current wave across the transmission line
            obj.i_fwd_tline = obj.cplx2time(i_fwd_tline_complex);
            
            % Calculate the backward traveling current wave across the transmission line
            obj.i_bck_tline = obj.cplx2time(i_bck_tline_complex);
            
            % Calculate the overall current across the transmission line
            obj.i_tline = obj.cplx2time(i_fwd_tline_complex + i_bck_tline_complex);
            
        end
        
        % Update voltage envelope of transmission line
        function update_v_env_tline(obj)      
            %obj.v_env_tline = max(obj.v_tline);
            obj.v_env_tline = abs((obj.v_inc * ((obj.p_fwd) + (obj.p_bck * obj.p_end * obj.GAMMA_L))) ./ ...
                                    (1 - obj.p_end^2*obj.GAMMA_L*obj.GAMMA_S));
        end
        
        % Update current envelope of transmission line
        function update_i_env_tline(obj)      
            obj.i_env_tline = max(obj.i_tline);
            obj.i_env_tline = abs(obj.v_inc/obj.z0 * (obj.p_fwd + (obj.p_bck * obj.p_end * -obj.GAMMA_L)) ./ ...
                                    (1 - obj.p_end^2*-obj.GAMMA_L*-obj.GAMMA_S));
        end
        
        % Convert complex value to the time domain
        % Performs outer product with time and complex values if there are
        % multiple complex values.
        function time_val = cplx2time(obj,complex_val)
            time_val = real(exp(1i*obj.omega*obj.time) * complex_val);
        end
        
    end
    
end


