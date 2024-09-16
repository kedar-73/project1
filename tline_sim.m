function tline_sim

% Close previous instances of this program
% Find all figures
all_fig_handles = findobj('Type', 'figure');
% Look for figures with the name Transmission Line Settings
fig_handle = findall(all_fig_handles,'Name','Transmission Line Settings');
% If a figure was found
if(~isempty(fig_handle))
    % Close that instance of the figure
    close(fig_handle);
end

% Setup GUI
handles = setup_gui;

% Save handles structures
save_handles(handles);

% Load Configuration File
load_configuration_file(handles);

end


%% GUI Setup

% Initializes GUI and sets up the layout of the GUI
function handles = setup_gui

%% GUI Appearance Settings

handles.FontSize = 8;
handles.FontColor = [.3 .3 .3];
handles.MainBackgroundColor = [.2 .2 .2];
handles.PanelBackgroundColor = [.9 .9 .9];
handles.SliderBackgroundColor = [.2 .2 .2];

handles.PlotBackgroundColor = [0 0 0];
handles.PlotGridColor = [1 1 1];
handles.PlotGridTransparency = .3;
handles.PlotGridLineWidth = 1.5;
handles.PlotGridLineStyle = ':';

% Set the colors of the voltage waves
handles.v_tline_color = [0 0 1];
handles.v_fwd_tline_color = [.2 .77 1];
handles.v_bck_tline_color = [.45 0 1];
handles.v_env_tline_color = [0 0 .2];

% Set the colors of the current waves
handles.i_tline_color = [1 0 0];
handles.i_fwd_tline_color = [1 .42 .2];
handles.i_bck_tline_color = [.89 0 .96];
handles.i_env_tline_color = [0 1 0];


%% Other Variables

% Initialize plot index (Used in plot_tline_data function)
handles.plot_idx = 1;
% Used to determine if recalculation of transmission line is necissary
handles.recalc_needed = 0;

% Configuration file to load
handles.config_file = [];

% Initialize simulation note to be an empty cell array
% This is updated when File => Add Note is selected
handles.simulation_notes = {''};

% Set transmission line object to transient tline for startup
handles.tline = transient_tline;


%% Create Figure Windows

% Create Transmission Line Settings Figure Window
handles.tline_settings_fig = figure(...
    'Units','pixels',...
    'Position',[50 450 816 375],...
    'MenuBar','none',...
    'ToolBar','none',...
    'name','Transmission Line Settings',...
    'numbertitle','off',...
    'resize','off',...
    'CloseRequestFcn',@tline_settings_fig_close_request_callback);

% Create Animation Figure Window
handles.animation_fig = figure(...
    'Units','normalized',...
    'Position',[.5 .23 .5 .7],...
    'MenuBar','none',...
    'ToolBar','none',...
    'name','Animation',...
    'numbertitle','off',...
    'resize','on',...
    'Visible','on',...
    'CloseRequestFcn',@animation_fig_close_request_callback);

% Create Load Selection Figure Window
handles.load_select_fig = figure(...
    'Units','pixels',...
    'Position',[655 300 445 485],...
    'MenuBar','none',...
    'ToolBar','none',...
    'name','Load Selection',...
    'numbertitle','off',...
    'resize','off',...
    'Visible','off',...
    'CloseRequestFcn',@load_select_fig_close_request_callback);

% Create Source Selection Figure Window
handles.source_select_fig = figure(...
    'Units','pixels',...
    'Position',[100 100 427 215],...
    'MenuBar','none',...
    'ToolBar','none',...
    'name','Source Selection',...
    'numbertitle','off',...
    'resize','off',...
    'Visible','off',...
    'CloseRequestFcn',@source_select_fig_close_request_callback);

% Create Animation Settings Figure Window
handles.animation_settings_fig = figure(...
    'Units','pixels',...
    'Position',[200 150 325 250],...
    'MenuBar','none',...
    'ToolBar','none',...
    'name','Animation Settings',...
    'numbertitle','off',...
    'resize','off',...
    'Visible','on',...
    'CloseRequestFcn',@animation_settings_fig_close_request_callback);

% Create Animation Slider Figure Window
handles.animation_slider_fig = figure(...
    'Units','normalized',...
    'Position',[.5 .045 .5 .15],...
    'MenuBar','none',...
    'ToolBar','none',...
    'name','Animation Slider',...
    'numbertitle','off',...
    'resize','on',...
    'Visible','off',...
    'CloseRequestFcn',@animation_slider_fig_close_request_callback);

% Create Legend Figure Window
handles.legend_fig = figure(...
    'Units','pixels',...
    'Position',[200 200 208 450],...
    'MenuBar','none',...
    'ToolBar','none',...
    'name','Legend',...
    'numbertitle','off',...
    'resize','off',...
    'Visible','off',...
    'CloseRequestFcn',@legend_fig_close_request_callback);

% Create Calculations Figure Window
handles.calculations_fig = figure(...
    'Units','pixels',...
    'Position',[655 100 300 485],...
    'MenuBar','none',...
    'ToolBar','none',...
    'name','Transmission Line Calculations',...
    'numbertitle','off',...
    'resize','off',...
    'Visible','off',...
    'CloseRequestFcn',@calculations_fig_close_request_callback);

% Create Simulation Notes Figure Window
handles.simulation_notes_fig = figure(...
    'Units','pixels',...
    'Position',[655 100 800 500],...
    'MenuBar','none',...
    'ToolBar','none',...
    'name','Simulation Notes',...
    'numbertitle','off',...
    'resize','off',...
    'Visible','off',...
    'CloseRequestFcn',@simulation_notes_fig_close_request_callback);


%% Create Transmission Line Settings Figure Menus



% Load
handles.tline_settings_load = uimenu(...
    'Parent',handles.tline_settings_fig,...
    'Label','Load');





%% Create Transmission Line Settings Load Menu

% Load => Load Selection Panel
handles.tline_settings_load_panel = uimenu(...
    'Parent',handles.tline_settings_load,...
    'Label','Load Selection Panel',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@tline_settings_load_panel_callback);

% Load => R
handles.tline_settings_load_R = uimenu(...
    'Parent',handles.tline_settings_load,...
    'Label','R',...
    'Checked','on',...
    'UserData',1,...
    'Separator','on',...
    'Callback',@tline_settings_load_R_callback);

% Load => L
handles.tline_settings_load_L = uimenu(...
    'Parent',handles.tline_settings_load,...
    'Label','L',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@tline_settings_load_L_callback);

% Load => C
handles.tline_settings_load_C = uimenu(...
    'Parent',handles.tline_settings_load,...
    'Label','C',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@tline_settings_load_C_callback);

% Load => R + L
handles.tline_settings_load_R_ser_L = uimenu(...
    'Parent',handles.tline_settings_load,...
    'Label','R + L',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@tline_settings_load_R_ser_L_callback);

% Load => R + C
handles.tline_settings_load_R_ser_C = uimenu(...
    'Parent',handles.tline_settings_load,...
    'Label','R + C',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@tline_settings_load_R_ser_C_callback);

% Load => R + L + C
handles.tline_settings_load_R_ser_L_ser_C = uimenu(...
    'Parent',handles.tline_settings_load,...
    'Label','R + L + C',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@tline_settings_load_R_ser_L_ser_C_callback);

% Load => R || L
handles.tline_settings_load_R_par_L = uimenu(...
    'Parent',handles.tline_settings_load,...
    'Label','R || L',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@tline_settings_load_R_par_L_callback);

% Load => R || C
handles.tline_settings_load_R_par_C = uimenu(...
    'Parent',handles.tline_settings_load,...
    'Label','R || C',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@tline_settings_load_R_par_C_callback);

% Load => R || L || C
handles.tline_settings_load_R_par_L_par_C = uimenu(...
    'Parent',handles.tline_settings_load,...
    'Label','R || L || C',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@tline_settings_load_R_par_L_par_C_callback);


%% Create Transmission Line Settings Animation Menu



%% Create Animation Figure Menus

% File
handles.animation_file = uimenu(...
    'Parent',handles.animation_fig,...
    'Label','File');

% Settings
handles.animation_settings = uimenu(...
    'Parent',handles.animation_fig,...
    'Label','Settings');

% Help
handles.animation_help = uimenu(...
    'Parent',handles.animation_fig,...
    'Label','Help');


%% Create Animation Figure File Menu

% File => Print
handles.animation_file_print = uimenu(...
    'Parent',handles.animation_file,...
    'Label','Print to File');

% File => Print => Top
handles.animation_file_print_top = uimenu(...
    'Parent',handles.animation_file_print,...
    'Label','Top',...
    'Callback',@animation_file_print_top_callback);

% File => Print => Middle
handles.animation_file_print_middle = uimenu(...
    'Parent',handles.animation_file_print,...
    'Label','Middle',...
    'Callback',@animation_file_print_middle_callback);

% File => Print => Bottom
handles.animation_file_print_bottom = uimenu(...
    'Parent',handles.animation_file_print,...
    'Label','Bottom',...
    'Callback',@animation_file_print_bottom_callback);

% File => Print => All
handles.animation_file_print_all = uimenu(...
    'Parent',handles.animation_file_print,...
    'Label','All',...
    'Callback',@animation_file_print_all_callback);


%% Create Animation Figure Settings Menu

% Animation => Across
handles.animation_settings_across = uimenu(...
    'Parent',handles.animation_settings,...
    'Label','Across');

% Animation => Near End
handles.animation_settings_near_end = uimenu(...
    'Parent',handles.animation_settings,...
    'Label','Near End');

% Animation => Far End
handles.animation_settings_far_end = uimenu(...
    'Parent',handles.animation_settings,...
    'Label','Far End');

% Animation => Across => V
handles.animation_settings_across_v = uimenu(...
    'Parent',handles.animation_settings_across,...
    'Label','V',...
    'Checked','on',...
    'UserData',1,...
    'Callback',@animation_settings_across_v_callback);

% Animation => Across => V_f
handles.animation_settings_across_v_f = uimenu(...
    'Parent',handles.animation_settings_across,...
    'Label','V_f',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@animation_settings_across_v_f_callback);

% Animation => Across => V_b
handles.animation_settings_across_v_b = uimenu(...
    'Parent',handles.animation_settings_across,...
    'Label','V_b',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@animation_settings_across_v_b_callback);

% Animation => Across => V_env
handles.animation_settings_across_v_env = uimenu(...
    'Parent',handles.animation_settings_across,...
    'Label','V_env',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@animation_settings_across_v_env_callback);

% Animation => Across => I
handles.animation_settings_across_i = uimenu(...
    'Parent',handles.animation_settings_across,...
    'Label','I',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@animation_settings_across_i_callback);

% Animation => Across => I_f
handles.animation_settings_across_i_f = uimenu(...
    'Parent',handles.animation_settings_across,...
    'Label','I_f',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@animation_settings_across_i_f_callback);

% Animation => Across => I_b
handles.animation_settings_across_i_b = uimenu(...
    'Parent',handles.animation_settings_across,...
    'Label','I_b',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@animation_settings_across_i_b_callback);

% Animation => Across => I_env
handles.animation_settings_across_i_env = uimenu(...
    'Parent',handles.animation_settings_across,...
    'Label','I_env',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@animation_settings_across_i_env_callback);

% Animation => Near End => V
handles.animation_settings_near_end_v = uimenu(...
    'Parent',handles.animation_settings_near_end,...
    'Label','V',...
    'Checked','on',...
    'UserData',1,...
    'Callback',@animation_settings_near_end_v_callback);

% Animation => Near End => I
handles.animation_settings_near_end_i = uimenu(...
    'Parent',handles.animation_settings_near_end,...
    'Label','I',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@animation_settings_near_end_i_callback);

% Animation => Far End => V
handles.animation_settings_far_end_v = uimenu(...
    'Parent',handles.animation_settings_far_end,...
    'Label','V',...
    'Checked','on',...
    'UserData',1,...
    'Callback',@animation_settings_far_end_v_callback);

% Animation => Far End => I
handles.animation_settings_far_end_i = uimenu(...
    'Parent',handles.animation_settings_far_end,...
    'Label','I',...
    'Checked','off',...
    'UserData',0,...
    'Callback',@animation_settings_far_end_i_callback);

% Animation => Update Current Scale
handles.animation_settings_current_scale = uimenu(...
    'Parent',handles.animation_settings,...
    'Label','Update Current Scale',...
    'UserData',1,...
    'Separator','on',...
    'Callback',@animation_settings_current_scale_callback);

% Animation => Update Plot Precision
handles.animation_settings_precision = uimenu(...
    'Parent',handles.animation_settings,...
    'Label','Update Plot Precision',...
    'UserData',100,...
    'Separator','on',...
    'Callback',@animation_settings_precision_callback);


%% Create Animation Figure Help Menu

% Help => Legend
handles.animation_help_legend = uimenu(...
    'Parent',handles.animation_help,...
    'Label','Legend',...
    'UserData',0,...
    'Checked','off',...
    'Separator','on',...
    'Callback',@animation_help_legend_callback);


%% Create Panels

% Create Transmission Line Settings Panel
handles.tline_settings_panel = uipanel(...
    'Parent',handles.tline_settings_fig,...
    'Title','',...
    'Tag','tline_settings_panel',...
    'Units','pixels',...
    'Position',[0 0 816 375],...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'BorderType','etchedin',...
    'BorderWidth',5);

% Create Animation Panel
handles.animation_panel = uipanel(...
    'Parent',handles.animation_fig,...
    'Title','',...
    'Tag','animation_panel',...
    'Units','normalized',...
    'Position',[0 0 1 1],...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'BorderType','etchedin',...
    'BorderWidth',5);

% Create Load Selection Panel
handles.load_select_panel = uipanel(...
    'Parent',handles.load_select_fig,...
    'Title','',...
    'Tag','load_select_panel',...
    'Units','pixels',...
    'Position',[0 0 445 485],...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'BorderType','etchedin',...
    'BorderWidth',5);

% Create Source Selection Panel
handles.source_select_panel = uipanel(...
    'Parent',handles.source_select_fig,...
    'Title','',...
    'Tag','source_select_panel',...
    'Units','pixels',...
    'Position',[0 0 427 215],...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'BorderType','etchedin',...
    'BorderWidth',5);

% Create Animation Settings Panel
handles.animation_settings_panel = uipanel(...
    'Parent',handles.animation_settings_fig,...
    'Title','',...
    'Tag','animation_settings_panel',...
    'Units','pixels',...
    'Position',[0 0 325 250],...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'BorderType','etchedin',...
    'BorderWidth',5);

% Create Animation Slider Panel
handles.animation_slider_panel = uipanel(...
    'Parent',handles.animation_slider_fig,...
    'Title','',...
    'Tag','animation_slider_panel',...
    'Units','normalized',...
    'Position',[0 0 1 1],...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'BorderType','etchedin',...
    'BorderWidth',5);

% Create Legend Panel
handles.legend_panel = uipanel(...
    'Parent',handles.legend_fig,...
    'Title','',...
    'Tag','legend_panel',...
    'Units','pixels',...
    'Position',[0 0 208 450],...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'BorderType','etchedin',...
    'BorderWidth',5);

% Create Calculations Panel
handles.calculations_panel = uipanel(...
    'Parent',handles.calculations_fig,...
    'Title','',...
    'Tag','calculations_panel',...
    'Units','pixels',...
    'Position',[0 0 300 485],...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'BorderType','etchedin',...
    'BorderWidth',5);

% Create Simulation Notes Panel
handles.simulation_notes_panel = uipanel(...
    'Parent',handles.simulation_notes_fig,...
    'Title','',...
    'Tag','simulation_notes_panel',...
    'Units','pixels',...
    'Position',[0 0 800 500],...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'BorderType','etchedin',...
    'BorderWidth',5);


%% Create Animation Settings Panel Objects

% Create Animation Settings Text
handles.animation_settings_text = uicontrol(handles.animation_settings_panel,...
    'Style','text',...
    'String','Animation Settings',...
    'Units','pixels',...
    'Position',[0 175 310 35],...
    'FontSize',20,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','center',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Animation Speed Text
handles.animation_speed_text = uicontrol(handles.animation_settings_panel,...
    'Style','text',...
    'String','Animation Speed',...
    'Units','pixels',...
    'Position',[25 64 200 30],...
    'FontSize',14,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','left',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Stop Time Text
handles.stop_time_text = uicontrol(handles.animation_settings_panel,...
    'Style','text',...
    'String','Stop Time',...
    'Units','pixels',...
    'Position',[25 22 200 30],...
    'FontSize',14,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','left',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Play Button
handles.play_button = uicontrol(handles.animation_settings_panel,...
    'Style','pushbutton',...
    'String','',...
    'Units','pixels',...
    'Position',[85 112 50 50],...
    'FontSize',10,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','center',...
    'BackgroundColor',[0 1 0],...
    'ForegroundColor',handles.FontColor,...
    'CData',imread(['images',filesep,'play_button.png']),...
    'UserData',0,...
    'Interruptible','on',...
    'TooltipString','Press to Start Animation',...
    'Callback',@play_button_callback);

% Create Stop Button
handles.stop_button = uicontrol(handles.animation_settings_panel,...
    'Style','pushbutton',...
    'String','',...
    'Units','pixels',...
    'Position',[160 112 50 50],...
    'FontSize',10,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','center',...
    'BackgroundColor',[1 0 0],...
    'ForegroundColor',handles.FontColor,...
    'CData',imread(['images',filesep,'stop_button.png']),...
    'UserData',0,...
    'TooltipString','Press to Stop Animation',...
    'Callback',@stop_button_callback);

% Create Animation Speed Edit Box
handles.animation_speed = uicontrol(handles.animation_settings_panel,...
    'Style','edit',...
    'String','1',...
    'Units','pixels',...
    'Position',[225 63 60 30],...
    'FontSize',11,...
    'FontWeight','normal',...
    'TooltipString','Enter Speed of Animation',...
    'Enable','inactive',...
    'Callback',@animation_speed_callback,...
    'ButtonDownFcn',@animation_speed_buttondown_callback,...
    'KeyPressFcn',@animation_speed_keypress_callback);

% Create Stop Time Edit Box
handles.ts = uicontrol(handles.animation_settings_panel,...
    'Style','edit',...
    'String','1',...
    'Units','pixels',...
    'Position',[225 20 60 30],...
    'FontSize',11,...
    'FontWeight','normal',...
    'TooltipString','Enter Stop Time of Simulation',...
    'Enable','inactive',...
    'Callback',@ts_callback,...
    'ButtonDownFcn',@ts_buttondown_callback,...
    'KeyPressFcn',@ts_keypress_callback);




%% Create Load Selection Panel Objects

% Create Load Selection Text
handles.load_selection_text = uicontrol(handles.load_select_panel,...
    'Style','text',...
    'String','Load Selection',...
    'Units','pixels',...
    'Position',[0 400 445 50],...
    'FontSize',20,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','center',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Resistor Load Button
handles.R_load_button = uicontrol(handles.load_select_panel,...
    'Style','pushbutton',...
    'String','',...
    'Tag','R',...
    'Units','pixels',...
    'Position',[20 280 125 125],...
    'CData',imread(['images',filesep,'R_sel.jpg']),...
    'UserData',1,...
    'Callback',@R_load_button_callback);

% Create Inductor Load Button
handles.L_load_button = uicontrol(handles.load_select_panel,...
    'Style','pushbutton',...
    'String','',...
    'Tag','L',...
    'Units','pixels',...
    'Position',[150 280 125 125],...
    'CData',imread(['images',filesep,'L.jpg']),...
    'UserData',0,...
    'Callback',@L_load_button_callback);

% Create Capacitor Load Button
handles.C_load_button = uicontrol(handles.load_select_panel,...
    'Style','pushbutton',...
    'String','',...
    'Tag','C',...
    'Units','pixels',...
    'Position',[280 280 125 125],...
    'CData',imread(['images',filesep,'C.jpg']),...
    'UserData',0,...
    'Callback',@C_load_button_callback);

% Create Resistor in Series with Inductor Load Button
handles.R_ser_L_load_button = uicontrol(handles.load_select_panel,...
    'Style','pushbutton',...
    'String','',...
    'Tag','R_ser_L',...
    'Units','pixels',...
    'Position',[20 150 125 125],...
    'CData',imread(['images',filesep,'R_ser_L.jpg']),...
    'UserData',0,...
    'Callback',@R_ser_L_load_button_callback);

% Create Resistor in Series with Capacitor Load Button
handles.R_ser_C_load_button = uicontrol(handles.load_select_panel,...
    'Style','pushbutton',...
    'String','',...
    'Tag','R_ser_C',...
    'Units','pixels',...
    'Position',[150 150 125 125],...
    'CData',imread(['images',filesep,'R_ser_C.jpg']),...
    'UserData',0,...
    'Callback',@R_ser_C_load_button_callback);

% Create Inductor in Series with Capacitor Load Button
handles.R_ser_L_ser_C_load_button = uicontrol(handles.load_select_panel,...
    'Style','pushbutton',...
    'String','',...
    'Tag','R_ser_L_ser_C',...
    'Units','pixels',...
    'Position',[280 150 125 125],...
    'CData',imread(['images',filesep,'R_ser_L_ser_C.jpg']),...
    'UserData',0,...
    'Callback',@R_ser_L_ser_C_load_button_callback);

% Create Resistor in Parallel with Inductor Load Button
handles.R_par_L_load_button = uicontrol(handles.load_select_panel,...
    'Style','pushbutton',...
    'String','',...
    'Tag','R_par_L',...
    'Units','pixels',...
    'Position',[20 20 125 125],...
    'CData',imread(['images',filesep,'R_par_L.jpg']),...
    'UserData',0,...
    'Callback',@R_par_L_load_button_callback);

% Create Resistor in Parallel with Capacitor Load Button
handles.R_par_C_load_button = uicontrol(handles.load_select_panel,...
    'Style','pushbutton',...
    'String','',...
    'Tag','R_par_C',...
    'Units','pixels',...
    'Position',[150 20 125 125],...
    'CData',imread(['images',filesep,'R_par_C.jpg']),...
    'UserData',0,...
    'Callback',@R_par_C_load_button_callback);

% Create Inductor in Parallel with Capacitor Load Button
handles.R_par_L_par_C_load_button = uicontrol(handles.load_select_panel,...
    'Style','pushbutton',...
    'String','',...
    'Tag','R_par_L_par_C',...
    'Units','pixels',...
    'Position',[280 20 125 125],...
    'CData',imread(['images',filesep,'R_par_L_par_C.jpg']),...
    'UserData',0,...
    'Callback',@R_par_L_par_C_load_button_callback);


%% Create Source Selection Panel Objects

% Create Source Selection Text
handles.source_selection_text = uicontrol(handles.source_select_panel,...
    'Style','text',...
    'String','Source Selection',...
    'Units','pixels',...
    'Position',[0 130 427 50],...
    'FontSize',20,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','center',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Step Source Button
handles.step_source_button = uicontrol(handles.source_select_panel,...
    'Style','pushbutton',...
    'String','',...
    'Tag','step',...
    'Units','pixels',...
    'Position',[10 10 125 125],...
    'CData',imread(['images',filesep,'step_sel.jpg']),...
    'UserData',1,...
    'Callback',@step_source_button_callback);

% Create Inductor Source Button
handles.ramped_step_source_button = uicontrol(handles.source_select_panel,...
    'Style','pushbutton',...
    'String','',...
    'Tag','ramped_step',...
    'Units','pixels',...
    'Position',[140 10 125 125],...
    'CData',imread(['images',filesep,'ramped_step.jpg']),...
    'UserData',0,...
    'Callback',@ramped_step_source_button_callback);

% Create Capacitor Source Button
handles.sine_source_button = uicontrol(handles.source_select_panel,...
    'Style','pushbutton',...
    'String','',...
    'Tag','sine',...
    'Units','pixels',...
    'Position',[270 10 125 125],...
    'CData',imread(['images',filesep,'sine.jpg']),...
    'UserData',0,...
    'Callback',@sine_source_button_callback);


%% Create Transmission Line Settings Panel Objects

% Create Transmission Line Settings Text
handles.tline_settings_text = uicontrol(handles.tline_settings_panel,...
    'Style','text',...
    'String','Transmission Line Settings',...
    'Units','pixels',...
    'Position',[0 305 800 40],...
    'FontSize',20,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','center',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Overlay Axes on Transmission Line Settings Panel
handles.tline_image_ax = axes('Parent',handles.tline_settings_panel,...
    'Units','pixels',...
    'Position',[0 0 800 400],...
    'XTick',[],...
    'YTick',[],...
    'Color', handles.PanelBackgroundColor);

% Create Source Amplitude Edit Box
handles.vs_amp = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','1',...
    'Units','pixels',...
    'Position',[41 135 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Source Amplitude',...
    'Enable','inactive',...
    'Visible','on',...
    'Callback',@vs_amp_callback,...
    'ButtonDownFcn',@vs_amp_buttondown_callback,...
    'KeyPressFcn',@vs_amp_keypress_callback);

% Create Source Rise Time Edit Box
handles.tr = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','1',...
    'Units','pixels',...
    'Position',[41 109 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Source Amplitude',...
    'Enable','inactive',...
    'Visible','off',...
    'Callback',@tr_callback,...
    'ButtonDownFcn',@tr_buttondown_callback,...
    'KeyPressFcn',@tr_keypress_callback);

% Create Frequency Edit Box
handles.freq = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','1',...
    'Units','pixels',...
    'Position',[41 112 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Source Frequency',...
    'Enable','inactive',...
    'Visible','off',...
    'Callback',@freq_callback,...
    'ButtonDownFcn',@freq_buttondown_callback,...
    'KeyPressFcn',@freq_keypress_callback);

% Create Source Resistance Edit Box
handles.zs = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','1',...
    'Units','pixels',...
    'Position',[150 216 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Source Resistance',...
    'Enable','inactive',...
    'Callback',@zs_callback,...
    'ButtonDownFcn',@zs_buttondown_callback,...
    'KeyPressFcn',@zs_keypress_callback);

% Create Characteristic Impedance Edit Box
handles.z0 = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','1',...
    'Units','pixels',...
    'Position',[341 218 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Characteristic Impedance',...
    'Enable','inactive',...
    'Callback',@z0_callback,...
    'ButtonDownFcn',@z0_buttondown_callback,...
    'KeyPressFcn',@z0_keypress_callback);

% Create Relative Permittivity Edit Box
handles.epsilon_r = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','1',...
    'Units','pixels',...
    'Position',[449 218 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Relative Permittivity',...
    'Enable','inactive',...
    'Callback',@epsilon_r_callback,...
    'ButtonDownFcn',@epsilon_r_buttondown_callback,...
    'KeyPressFcn',@epsilon_r_keypress_callback);

% Create Propagation Delay Edit Box
handles.td = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','1',...
    'Units','pixels',...
    'Position',[390 168 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Propagation Delay',...
    'Enable','inactive',...
    'Callback',@td_callback,...
    'ButtonDownFcn',@td_buttondown_callback,...
    'KeyPressFcn',@td_keypress_callback);

% Create Load Resistance Edit Box
handles.rl = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','r',...
    'Units','pixels',...
    'Position',[470 120 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Load Resistance',...
    'Enable','inactive',...
    'Visible','on',...
    'Callback',@rl_callback,...
    'ButtonDownFcn',@rl_buttondown_callback,...
    'KeyPressFcn',@rl_keypress_callback);

% Create Load Inductance Edit Box
handles.ll = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','l',...
    'Units','pixels',...
    'Position',[470 77 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Load Inductance',...
    'Enable','inactive',...
    'Visible','on',...
    'Callback',@ll_callback,...
    'ButtonDownFcn',@ll_buttondown_callback,...
    'KeyPressFcn',@ll_keypress_callback);

% Create Load Capacitance Edit Box
handles.cl = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','c',...
    'Units','pixels',...
    'Position',[470 77 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Load Capacitance',...
    'Enable','inactive',...
    'Visible','off',...
    'Callback',@cl_callback,...
    'ButtonDownFcn',@cl_buttondown_callback,...
    'KeyPressFcn',@cl_keypress_callback);

% Create Transmission Line Inductance per Unit Length Edit Box
handles.L = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','L',...
    'Units','pixels',...
    'Position',[275 217 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Inductance per Unit Length',...
    'Enable','inactive',...
    'Visible','off',...
    'Callback',@L_callback,...
    'ButtonDownFcn',@L_buttondown_callback,...
    'KeyPressFcn',@L_keypress_callback);

% Create Transmission Line Capacitance per Unit Length Edit Box
handles.C = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','C',...
    'Units','pixels',...
    'Position',[356 217 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Capacitance per Unit Length',...
    'Enable','inactive',...
    'Visible','off',...
    'Callback',@C_callback,...
    'ButtonDownFcn',@C_buttondown_callback,...
    'KeyPressFcn',@C_keypress_callback);

% Create Transmission Line Resistance per Unit Length Edit Box
handles.R = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','R',...
    'Units','pixels',...
    'Position',[440 217 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Resistance per Unit Length',...
    'Enable','inactive',...
    'Visible','off',...
    'Callback',@R_callback,...
    'ButtonDownFcn',@R_buttondown_callback,...
    'KeyPressFcn',@R_keypress_callback);

% Create Transmission Line Conductance per Unit Length Edit Box
handles.G = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','G',...
    'Units','pixels',...
    'Position',[524 217 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Conductance per Unit Length',...
    'Enable','inactive',...
    'Visible','off',...
    'Callback',@G_callback,...
    'ButtonDownFcn',@G_buttondown_callback,...
    'KeyPressFcn',@G_keypress_callback);

% Create Line Length Edit Box
handles.line_length = uicontrol(handles.tline_settings_panel,...
    'Style','edit',...
    'String','1',...
    'Units','pixels',...
    'Position',[390 168 50 20],...
    'FontSize',handles.FontSize,...
    'FontWeight','normal',...
    'TooltipString','Enter Line Length',...
    'Enable','inactive',...
    'Visible','off',...
    'Callback',@line_length_callback,...
    'ButtonDownFcn',@line_length_buttondown_callback,...
    'KeyPressFcn',@line_length_keypress_callback);

% Create Transmission Line Settings Text
handles.tline_units_text = uicontrol(handles.tline_settings_panel,...
    'Style','text',...
    'String','Standard base and derived SI units are used',...
    'Units','pixels',...
    'Position',[275 20 250 15],...
    'FontSize',8,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','center',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);


%% Create Animation Panel Objects

% Create Distance Axis
handles.ax_dist = axes('Parent',handles.animation_panel,...
    'Units','normalized',...
    'Position',[.07 .73 .9 .22],...
    'Color', handles.PlotBackgroundColor,...
    'XGrid','on',...
    'YGrid','on',...
    'LineWidth',handles.PlotGridLineWidth,...
    'GridLineStyle',handles.PlotGridLineStyle,...
    'TickLength',[0 0],...
    'GridColor',[handles.PlotGridColor],...
    'GridAlpha',handles.PlotGridTransparency);
set(handles.ax_dist.Title,'String','Voltage Across Transmission Line');
set(handles.ax_dist.XLabel,'String','Distance (m)',...
    'Units','normalized',...
    'Position',[.5 -.12,0]);
set(handles.ax_dist.YLabel,'String','Voltage (V)',...
    'Units','normalized',...
    'Position',[-.035,.5,0]);

% Create Source Axis
handles.ax_src = axes('Parent',handles.animation_panel,...
    'Units','normalized',...
    'Position',[.07 .405 .9 .22],...
    'Color', handles.PlotBackgroundColor,...
    'XGrid','on',...
    'YGrid','on',...
    'LineWidth',handles.PlotGridLineWidth,...
    'GridLineStyle',handles.PlotGridLineStyle,...
    'TickLength',[0 0],...
    'GridColor',[handles.PlotGridColor],...
    'GridAlpha',handles.PlotGridTransparency);
set(handles.ax_src.Title,'String','Voltage at Near End of Transmission Line');
set(handles.ax_src.XLabel,'String','Time (s)',...
    'Units','normalized',...
    'Position',[.5 -.12,0]);
set(handles.ax_src.YLabel,'String','Voltage (V)',...
    'Units','normalized',...
    'Position',[-.035,.5,0]);

% Create Load Axis
handles.ax_load = axes('Parent',handles.animation_panel,...
    'Units','normalized',...
    'Position',[.07 .08 .9 .22],...
    'Color', handles.PlotBackgroundColor,...
    'XGrid','on',...
    'YGrid','on',...
    'LineWidth',handles.PlotGridLineWidth,...
    'GridLineStyle',handles.PlotGridLineStyle,...
    'TickLength',[0 0],...
    'GridColor',[handles.PlotGridColor],...
    'GridAlpha',handles.PlotGridTransparency);

set(handles.ax_load.Title,'String','Voltage at Far End of Transmission Line');
set(handles.ax_load.XLabel,'String','Time (s)',...
    'Units','normalized',...
    'Position',[.5 -.12,0]);
set(handles.ax_load.YLabel,'String','Voltage (V)',...
    'Units','normalized',...
    'Position',[-.035,.5,0]);


%% Create Animation Slider Panel Objects

% Create Animation Slider Text
handles.animation_slider_text = uicontrol(handles.animation_slider_panel,...
    'Style','Text',...
    'String','Animation Slider',...
    'Units','normalized',...
    'Position',[0 .5 1 .4],...
    'FontSize',20,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','center',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Animation Slider
handles.animation_slider = uicontrol(handles.animation_slider_panel,...
    'Style','slider',...
    'String','',...
    'Units','normalized',...
    'Position',[.03 .13 .94 .4],...
    'BackgroundColor',handles.SliderBackgroundColor,...
    'TooltipString','Adjust Animation Time',...
    'Callback',@animation_slider_callback);


%% Create Legend Panel Objects

% Create Legend Text
handles.legend_text = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','Legend',...
    'Units','pixels',...
    'Position',[0 380 208 40],...
    'FontSize',20,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','center',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Voltage Text
handles.voltage_text = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','V',...
    'Units','pixels',...
    'Position',[50 330 285 25],...
    'FontSize',16,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','left',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Voltage Color Box
handles.voltage_color = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','',...
    'Units','pixels',...
    'Position',[110 325 30 30],...
    'BackgroundColor',handles.v_tline_color);

% Create Forward Traveling Voltage Text
handles.forward_voltage_text = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','V_f',...
    'Units','pixels',...
    'Position',[50 280 285 25],...
    'FontSize',16,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','left',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Forward Traveling Voltage Color Box
handles.forward_voltage_color = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','',...
    'Units','pixels',...
    'Position',[110 275 30 30],...
    'BackgroundColor',handles.v_fwd_tline_color);

% Create Backward Traveling Voltage Text
handles.backward_voltage_text = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','V_b',...
    'Units','pixels',...
    'Position',[50 230 285 25],...
    'FontSize',16,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','left',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Backward Traveling Voltage Color Box
handles.backward_voltage_color = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','',...
    'Units','pixels',...
    'Position',[110 225 30 30],...
    'BackgroundColor',handles.v_bck_tline_color);

% Create Current Text
handles.current_text = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','I',...
    'Units','pixels',...
    'Position',[50 180 285 25],...
    'FontSize',16,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','left',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Current Color Box
handles.current_color = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','',...
    'Units','pixels',...
    'Position',[110 175 30 30],...
    'BackgroundColor',handles.i_tline_color);

% Create Forward Traveling Current Text
handles.forward_current_text = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','I_f',...
    'Units','pixels',...
    'Position',[50 130 285 25],...
    'FontSize',16,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','left',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Forward Traveling Current Color Box
handles.forward_current_color = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','',...
    'Units','pixels',...
    'Position',[110 125 30 30],...
    'BackgroundColor',handles.i_fwd_tline_color);

% Create Backward Traveling Current Text
handles.backward_current_text = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','I_b',...
    'Units','pixels',...
    'Position',[50 80 285 25],...
    'FontSize',16,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','left',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);

% Create Backward Traveling Current Color Box
handles.backward_current_color = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','',...
    'Units','pixels',...
    'Position',[110 75 30 30],...
    'BackgroundColor',handles.i_bck_tline_color);

% Create Current Scale Text
handles.current_scale_text = uicontrol(handles.legend_panel,...
    'Style','Text',...
    'String','Current Scale: 1',...
    'Units','pixels',...
    'Position',[0 25 190 25],...
    'FontSize',15,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','center',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);


%% Create Calculations Panel Objects

% Create Calculations Axis (Created axes to allow text() function to be used.
% This makes it so greek letters and subscripts can be used)
handles.ax_calculations = axes('Parent',handles.calculations_panel,...
    'Units','pixels',...
    'Position',[0 0 300 485],...
    'Color', handles.PanelBackgroundColor,...
    'XTick',[],...
    'YTick',[]);

% Create Calculations Text
handles.calculations_text = uicontrol(handles.calculations_panel,...
    'Style','text',...
    'String','Calculations',...
    'Units','pixels',...
    'Position',[0 410 300 40],...
    'FontSize',20,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','center',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);


%% Create Simulation Notes Panel Objects

% Create Simulation Notes Text
handles.simulation_notes_text = uicontrol(handles.simulation_notes_panel,...
    'Style','text',...
    'String',handles.simulation_notes{1},...
    'Units','pixels',...
    'Position',[20 40 750 420],...
    'FontSize',12,...
    'FontWeight','bold',...
    'FontName','MS Sans Serif',...
    'HorizontalAlignment','left',...
    'BackgroundColor',handles.PanelBackgroundColor,...
    'ForegroundColor',handles.FontColor);


end

%% Helper Functions

% Save handles structure to all the figure windows
function save_handles(handles)
guidata(handles.tline_settings_fig,handles);
guidata(handles.animation_fig,handles);
guidata(handles.load_select_fig,handles);
guidata(handles.source_select_fig,handles);
guidata(handles.animation_settings_fig,handles);
guidata(handles.animation_slider_fig,handles);
guidata(handles.legend_fig,handles);
guidata(handles.calculations_fig,handles);
guidata(handles.simulation_notes_fig,handles);
end

% Format string for the calculations panel
function formatted_str = format_calc_str(str)

% Replace i with j
str = strrep(str,'i','j');

% Add space around minus or plus signs in imaginary numbers
for k = 2:length(str-1)
    if(~isnan(str2double(str(k-1))) && (strcmp(str(k),'-') || strcmp(str(k),'+')) && ~isnan(str2double(str(k+1))))
        str = [str(1:k-1),' ',str(k),' ',str(k+1:end)];
    end
end

% Move the j to the start of the imaginary number
for k = 1:length(str)
    if(strcmp(str(k),'j'))
        for n = k:-1:1
            if(strcmp(str(n),' '))
                str = [str(1:n),'j',str(n+1:k-1),str(k+1:end)];
                break;
            end
        end
    end
end

formatted_str = str;
end

% Generate calculations panel
function generate_calculations_window(handles)

% Clear the text that is currently on the axis
cla(handles.ax_calculations);

% Set the number of calculation lines depending on the settings
if(strcmp(handles.tline.tline_config,'lossless'))
    if(strcmp(handles.tline.src_config,'sine'))
        num_lines = 7;
    else
        if(strcmp(handles.tline.load_config,'R'))
            num_lines = 5;
        else
            num_lines = 2;
        end
    end
elseif(strcmp(handles.tline.tline_config,'lossy'))
    if(handles.tline.R == 0 && handles.tline.G == 0)
        num_lines = 13;
    else
        num_lines = 12;
    end
end

% Vertical space between calculation strings
diff = 30;
% Vertical offset between first calculation string and the title string
offset = 90;

% Get current figure position
fig_pos = get(handles.calculations_fig,'Position');
% Celculate the height that the figure window needs to be
height = num_lines*diff+offset;
% Get the width of the figure
width = fig_pos(3);
% Calculate the new figure position
new_pos = [fig_pos(1), fig_pos(2)-(height-fig_pos(4)), fig_pos(3), height];

% Location of the first string
text_height = height - offset;

% Set the location of the figure
set(handles.calculations_fig,'Position',new_pos);
set(handles.calculations_panel,'Position',[0 0 width height]);
set(handles.ax_calculations,'Position',[0 0 width height]);
set(handles.calculations_text,'Position',[0 height-75 width 40]);

% If using a lossless line
if(strcmp(handles.tline.tline_config,'lossless'))
    
    % If using a sinusoidal source
    if(strcmp(handles.tline.src_config,'sine'))
        
        % Load impedance
        zl = double(vpa(subs(handles.tline.zl,handles.tline.s,1i*handles.tline.omega),4));
        zl_str = ['Z_{L} = ',num2str(zl), ' \Omega'];
        zl_str = format_calc_str(zl_str);
        text('Parent',handles.ax_calculations,...
            'String',zl_str,...
            'Units','pixels',...
            'Position',[20,text_height],...
            'Interpreter','tex',...
            'FontSize',12,...
            'FontWeight','bold',...
            'FontName','MS Sans Serif',...
            'HorizontalAlignment','left',...
            'Color',handles.FontColor);
        text_height = text_height-diff;
        
        % If load is purely resistive
        if(strcmp(handles.tline.load_config,'R'))
            
            % Source reflection coeficient
            GAMMA_S = double(vpa(subs(handles.tline.GAMMA_S,handles.tline.s,1i*handles.tline.omega),4));
            GAMMA_S_str = ['\rho_{S} = ',num2str(GAMMA_S)];
            GAMMA_S_str = format_calc_str(GAMMA_S_str);
            text('Parent',handles.ax_calculations,...
                'String',GAMMA_S_str,...
                'Units','pixels',...
                'Position',[20,text_height],...
                'Interpreter','tex',...
                'FontSize',12,...
                'FontWeight','bold',...
                'FontName','MS Sans Serif',...
                'HorizontalAlignment','left',...
                'Color',handles.FontColor);
            text_height = text_height-diff;
            
            % Load reflection coeficient
            GAMMA_L = double(vpa(subs(handles.tline.GAMMA_L,handles.tline.s,1i*handles.tline.omega),4));
            GAMMA_L_str = ['\rho_{L} = ',num2str(GAMMA_L)];
            GAMMA_L_str = format_calc_str(GAMMA_L_str);
            text('Parent',handles.ax_calculations,...
                'String',GAMMA_L_str,...
                'Units','pixels',...
                'Position',[20,text_height],...
                'Interpreter','tex',...
                'FontSize',12,...
                'FontWeight','bold',...
                'FontName','MS Sans Serif',...
                'HorizontalAlignment','left',...
                'Color',handles.FontColor);
            text_height = text_height-diff;
            
            % If load has reactive component
        else
            % Source reflection coeficient
            GAMMA_S = double(vpa(subs(handles.tline.GAMMA_S,handles.tline.s,1i*handles.tline.omega),4));
            GAMMA_S_str = ['\Gamma_{S} = ',num2str(GAMMA_S)];
            GAMMA_S_str = format_calc_str(GAMMA_S_str);
            text('Parent',handles.ax_calculations,...
                'String',GAMMA_S_str,...
                'Units','pixels',...
                'Position',[20,text_height],...
                'Interpreter','tex',...
                'FontSize',12,...
                'FontWeight','bold',...
                'FontName','MS Sans Serif',...
                'HorizontalAlignment','left',...
                'Color',handles.FontColor);
            text_height = text_height-diff;
            
            % Load reflection coeficient
            GAMMA_L = double(vpa(subs(handles.tline.GAMMA_L,handles.tline.s,1i*handles.tline.omega),4));
            GAMMA_L_str = ['\Gamma_{L} = ',num2str(GAMMA_L)];
            GAMMA_L_str = format_calc_str(GAMMA_L_str);
            text('Parent',handles.ax_calculations,...
                'String',GAMMA_L_str,...
                'Units','pixels',...
                'Position',[20,text_height],...
                'Interpreter','tex',...
                'FontSize',12,...
                'FontWeight','bold',...
                'FontName','MS Sans Serif',...
                'HorizontalAlignment','left',...
                'Color',handles.FontColor);
            text_height = text_height-diff;
            
        end
        
        % Line Length
        text('Parent',handles.ax_calculations,...
            'String',['length = ',num2str(handles.tline.line_length,'%.3g'),' m'],...
            'Units','pixels',...
            'Position',[20,text_height],...
            'Interpreter','tex',...
            'FontSize',12,...
            'FontWeight','bold',...
            'FontName','MS Sans Serif',...
            'HorizontalAlignment','left',...
            'Color',handles.FontColor);
        text_height = text_height-diff;
        
        % Velocity of propagation
        text('Parent',handles.ax_calculations,...
            'String',['v_{p} = ',num2str(handles.tline.vp)],...
            'Units','pixels',...
            'Position',[20,text_height],...
            'Interpreter','tex',...
            'FontSize',12,...
            'FontWeight','bold',...
            'FontName','MS Sans Serif',...
            'HorizontalAlignment','left',...
            'Color',handles.FontColor);
        text_height = text_height-diff;
        
        % Angular Velocity
        text('Parent',handles.ax_calculations,...
            'String',['\omega = ',num2str(handles.tline.omega,'%.3g'), ' rad'],...
            'Units','pixels',...
            'Position',[20,text_height],...
            'Interpreter','tex',...
            'FontSize',12,...
            'FontWeight','bold',...
            'FontName','MS Sans Serif',...
            'HorizontalAlignment','left',...
            'Color',handles.FontColor);
        text_height = text_height-diff;
        
        % Wavelength
        text('Parent',handles.ax_calculations,...
            'String',['\lambda = ',num2str(handles.tline.lambda,'%.3g'),' m'],...
            'Units','pixels',...
            'Position',[20,text_height],...
            'Interpreter','tex',...
            'FontSize',12,...
            'FontWeight','bold',...
            'FontName','MS Sans Serif',...
            'HorizontalAlignment','left',...
            'Color',handles.FontColor);
        text_height = text_height-diff;
        
        % If using a step or a ramped step source
    elseif(strcmp(handles.tline.src_config,'step') || strcmp(handles.tline.src_config,'ramped_step'))
        
        % If load is purely resistive
        if(strcmp(handles.tline.load_config,'R'))
            % Load impedance
            text('Parent',handles.ax_calculations,...
                'String',['Z_{L} = ',strrep(char(vpa(handles.tline.zl,3)),'s','(j\omega)'), ' \Omega'],...
                'Units','pixels',...
                'Position',[20,text_height],...
                'Interpreter','tex',...
                'FontSize',12,...
                'FontWeight','bold',...
                'FontName','MS Sans Serif',...
                'HorizontalAlignment','left',...
                'Color',handles.FontColor);
            text_height = text_height-diff;
            
            % Source reflection coeficient
            text('Parent',handles.ax_calculations,...
                'String',['\rho_{S} = ',strrep(char(vpa(handles.tline.GAMMA_S,3)),'s','(j\omega)')],...
                'Units','pixels',...
                'Position',[20,text_height],...
                'Interpreter','tex',...
                'FontSize',12,...
                'FontWeight','bold',...
                'FontName','MS Sans Serif',...
                'HorizontalAlignment','left',...
                'Color',handles.FontColor);
            text_height = text_height-diff;
            
            % Load reflection coeficient
            text('Parent',handles.ax_calculations,...
                'String',['\rho_{L} = ',strrep(char(vpa(handles.tline.GAMMA_L,3)),'s','(j\omega)')],...
                'Units','pixels',...
                'Position',[20,text_height],...
                'Interpreter','tex',...
                'FontSize',12,...
                'FontWeight','bold',...
                'FontName','MS Sans Serif',...
                'HorizontalAlignment','left',...
                'Color',handles.FontColor);
            text_height = text_height-diff;
            
            % Line Length
            text('Parent',handles.ax_calculations,...
                'String',['length = ',num2str(handles.tline.line_length,'%.3g'),' m'],...
                'Units','pixels',...
                'Position',[20,text_height],...
                'Interpreter','tex',...
                'FontSize',12,...
                'FontWeight','bold',...
                'FontName','MS Sans Serif',...
                'HorizontalAlignment','left',...
                'Color',handles.FontColor);
            text_height = text_height-diff;
            
            % Velocity of propagation
            text('Parent',handles.ax_calculations,...
                'String',['v_{p} = ',num2str(handles.tline.vp)],...
                'Units','pixels',...
                'Position',[20,text_height],...
                'Interpreter','tex',...
                'FontSize',12,...
                'FontWeight','bold',...
                'FontName','MS Sans Serif',...
                'HorizontalAlignment','left',...
                'Color',handles.FontColor);
            text_height = text_height-diff;
            
            % If load has a reactive component
        else
            
            % Line Length
            text('Parent',handles.ax_calculations,...
                'String',['length = ',num2str(handles.tline.line_length,'%.3g'),' m'],...
                'Units','pixels',...
                'Position',[20,text_height],...
                'Interpreter','tex',...
                'FontSize',12,...
                'FontWeight','bold',...
                'FontName','MS Sans Serif',...
                'HorizontalAlignment','left',...
                'Color',handles.FontColor);
            text_height = text_height-diff;
            
            % Velocity of propagation
            text('Parent',handles.ax_calculations,...
                'String',['v_{p} = ',num2str(handles.tline.vp)],...
                'Units','pixels',...
                'Position',[20,text_height],...
                'Interpreter','tex',...
                'FontSize',12,...
                'FontWeight','bold',...
                'FontName','MS Sans Serif',...
                'HorizontalAlignment','left',...
                'Color',handles.FontColor);
            text_height = text_height-diff;
            
        end
    end
    
elseif(strcmp(handles.tline.tline_config,'lossy'))
    
    % Characteristic Impedance
    z0_str = ['Z_{0} = ',num2str(handles.tline.z0,'%.3g'),' \Omega'];
    z0_str = format_calc_str(z0_str);
    text('Parent',handles.ax_calculations,...
        'String',z0_str,...
        'Units','pixels',...
        'Position',[20,text_height],...
        'Interpreter','tex',...
        'FontSize',12,...
        'FontWeight','bold',...
        'FontName','MS Sans Serif',...
        'HorizontalAlignment','left',...
        'Color',handles.FontColor);
    text_height = text_height-diff;
    
    % Load Impedance
    zl_str = ['Z_{L} = ',num2str(handles.tline.zl,'%.3g'),' \Omega'];
    zl_str = format_calc_str(zl_str);
    text('Parent',handles.ax_calculations,...
        'String',zl_str,...
        'Units','pixels',...
        'Position',[20,text_height],...
        'Interpreter','tex',...
        'FontSize',12,...
        'FontWeight','bold',...
        'FontName','MS Sans Serif',...
        'HorizontalAlignment','left',...
        'Color',handles.FontColor);
    text_height = text_height-diff;
    
    % Source Reflection Coefficient
    GAMMA_S_str = ['\Gamma_{S} = ',num2str(handles.tline.GAMMA_S,'%.3g')];
    GAMMA_S_str = format_calc_str(GAMMA_S_str);
    text('Parent',handles.ax_calculations,...
        'String',GAMMA_S_str,...
        'Units','pixels',...
        'Position',[20,text_height],...
        'Interpreter','tex',...
        'FontSize',12,...
        'FontWeight','bold',...
        'FontName','MS Sans Serif',...
        'HorizontalAlignment','left',...
        'Color',handles.FontColor);
    text_height = text_height-diff;
    
    % Load Reflection Coefficient
    GAMMA_L_str = ['\Gamma_{L} = ',num2str(handles.tline.GAMMA_L,'%.3g')];
    GAMMA_L_str = format_calc_str(GAMMA_L_str);
    text('Parent',handles.ax_calculations,...
        'String',GAMMA_L_str,...
        'Units','pixels',...
        'Position',[20,text_height],...
        'Interpreter','tex',...
        'FontSize',12,...
        'FontWeight','bold',...
        'FontName','MS Sans Serif',...
        'HorizontalAlignment','left',...
        'Color',handles.FontColor);
    text_height = text_height-diff;
    
    % Propagation Constant
    gamma_str = ['\gamma = ',num2str(handles.tline.gamma,'%.3g'),' 1/m'];
    gamma_str = format_calc_str(gamma_str);
    text('Parent',handles.ax_calculations,...
        'String',gamma_str,...
        'Units','pixels',...
        'Position',[20,text_height],...
        'Interpreter','tex',...
        'FontSize',12,...
        'FontWeight','bold',...
        'FontName','MS Sans Serif',...
        'HorizontalAlignment','left',...
        'Color',handles.FontColor);
    text_height = text_height-diff;
    
    % Attenuation Constant
    text('Parent',handles.ax_calculations,...
        'String',['\alpha = ',num2str(handles.tline.alpha,'%.3g'),' Np/m'],...
        'Units','pixels',...
        'Position',[20,text_height],...
        'Interpreter','tex',...
        'FontSize',12,...
        'FontWeight','bold',...
        'FontName','MS Sans Serif',...
        'HorizontalAlignment','left',...
        'Color',handles.FontColor);
    text_height = text_height-diff;
    
    % Phase Constant
    text('Parent',handles.ax_calculations,...
        'String',['\beta = ',num2str(handles.tline.beta,'%.3g'),' rad/m'],...
        'Units','pixels',...
        'Position',[20,text_height],...
        'Interpreter','tex',...
        'FontSize',12,...
        'FontWeight','bold',...
        'FontName','MS Sans Serif',...
        'HorizontalAlignment','left',...
        'Color',handles.FontColor);
    text_height = text_height-diff;
    
    % Propagation Delay
    text('Parent',handles.ax_calculations,...
        'String',['t_{d} = ',num2str(handles.tline.td,'%.3g'),' s'],...
        'Units','pixels',...
        'Position',[20,text_height],...
        'Interpreter','tex',...
        'FontSize',12,...
        'FontWeight','bold',...
        'FontName','MS Sans Serif',...
        'HorizontalAlignment','left',...
        'Color',handles.FontColor);
    text_height = text_height-diff;
    
    % Wavelength
    text('Parent',handles.ax_calculations,...
        'String',['\lambda = ',num2str(handles.tline.lambda,'%.3g'),' m'],...
        'Units','pixels',...
        'Position',[20,text_height],...
        'Interpreter','tex',...
        'FontSize',12,...
        'FontWeight','bold',...
        'FontName','MS Sans Serif',...
        'HorizontalAlignment','left',...
        'Color',handles.FontColor);
    text_height = text_height-diff;
    
    % Velocity of propagation
    text('Parent',handles.ax_calculations,...
        'String',['v_{p} = ',num2str(handles.tline.vp,'%.3g'),' m/s'],...
        'Units','pixels',...
        'Position',[20,text_height],...
        'Interpreter','tex',...
        'FontSize',12,...
        'FontWeight','bold',...
        'FontName','MS Sans Serif',...
        'HorizontalAlignment','left',...
        'Color',handles.FontColor);
    text_height = text_height-diff;
    
    % Relative Permitivitty
    text('Parent',handles.ax_calculations,...
        'String',['\epsilon_{r} = ',num2str(handles.tline.epsilon_r,'%.3g'),' F/m'],...
        'Units','pixels',...
        'Position',[20,text_height],...
        'Interpreter','tex',...
        'FontSize',12,...
        'FontWeight','bold',...
        'FontName','MS Sans Serif',...
        'HorizontalAlignment','left',...
        'Color',handles.FontColor);
    text_height = text_height-diff;
    
    % Angular Frequency
    text('Parent',handles.ax_calculations,...
        'String',['\omega = ',num2str(handles.tline.omega,'%.3g'),' rad'],...
        'Units','pixels',...
        'Position',[20,text_height],...
        'Interpreter','tex',...
        'FontSize',12,...
        'FontWeight','bold',...
        'FontName','MS Sans Serif',...
        'HorizontalAlignment','left',...
        'Color',handles.FontColor);
    text_height = text_height-diff;
    
    % If lossless
    if(handles.tline.R == 0 && handles.tline.G == 0)
        
        % Voltage standing wave ratio
        text('Parent',handles.ax_calculations,...
            'String',['VSWR = ',num2str(handles.tline.vswr,'%.3g')],...
            'Units','pixels',...
            'Position',[20,text_height],...
            'Interpreter','tex',...
            'FontSize',12,...
            'FontWeight','bold',...
            'FontName','MS Sans Serif',...
            'HorizontalAlignment','left',...
            'Color',handles.FontColor);
        text_height = text_height-diff;
        
    end
    
end

% Save handles structures
save_handles(handles);

end

% Convert convert metric prefixes in strings to numbers
function num_str = prefix2num(prefix_str)

num_str = strrep(prefix_str,'Y','e24');
num_str = strrep(num_str,'Z','e21');
num_str = strrep(num_str,'E','e18');
num_str = strrep(num_str,'P','e15');
num_str = strrep(num_str,'T','e12');
num_str = strrep(num_str,'G','e9');
num_str = strrep(num_str,'M','e6');
num_str = strrep(num_str,'k','e3');
num_str = strrep(num_str,'m','e-3');
num_str = strrep(num_str,'u','e-6');
num_str = strrep(num_str,'n','e-9');
num_str = strrep(num_str,'p','e-12');
num_str = strrep(num_str,'f','e-15');
num_str = strrep(num_str,'a','e-18');
num_str = strrep(num_str,'z','e-21');
num_str = strrep(num_str,'y','e-24');

end

% Load Configuration File
% The filepath is handles.config_file. If handles.config_file is empty the
% default is to open a trasient transmission line
function load_configuration_file(handles)

% If there is no configuration file to load
if(isempty(handles.config_file))
    % Open the transient model as default
    handles.tline = transient_tline;
    % Generate animation data
    handles.tline.update_props;
    % Set animation speed
    set(handles.animation_speed,'UserData',5);
    set(handles.animation_speed,'String',num2str(5));
    % Change transmission line settings text to either lossless or lossy depending on transmission line
    if(strcmp(handles.tline.tline_config,'lossless'))
        set(handles.tline_settings_text,'String','Lossless Transmission Line Settings');
    else
        set(handles.tline_settings_text,'String','Lossy Transmission Line Settings');
    end
    % If there is a configuration file to load
else
    % Load configuration file
    config_data = load(handles.config_file);
    
    % Set animation speed
    set(handles.animation_speed,'UserData',config_data.animation_speed);
    set(handles.animation_speed,'String',num2str(config_data.animation_speed));
    
    % If it is a transient configuration file
    if(strcmp(config_data.tline.animation_type,'transient'))
        % Load transient transmission line object
        handles.tline = transient_tline(config_data.tline);
        % If it is a steady state configuration file
    elseif(strcmp(config_data.tline.animation_type,'steady_state'))
        % Load steady state transmission line object
        handles.tline = steady_state_tline(config_data.tline);
        % If file is not a transient or a steady state file
    else
        % Warn the user
        warning('Configuration file could not be loaded')
    end
    
    % Update plot settings
    set(handles.animation_settings_across_v,'UserData',config_data.v_across);
    set(handles.animation_settings_across_v_f,'UserData',config_data.v_f_across);
    set(handles.animation_settings_across_v_b,'UserData',config_data.v_b_across);
    set(handles.animation_settings_across_v_env,'UserData',config_data.v_env_across);
    set(handles.animation_settings_across_i,'UserData',config_data.i_across);
    set(handles.animation_settings_across_i_f,'UserData',config_data.i_f_across);
    set(handles.animation_settings_across_i_b,'UserData',config_data.i_b_across);
    set(handles.animation_settings_across_i_env,'UserData',config_data.i_env_across);
    set(handles.animation_settings_near_end_v,'UserData',config_data.v_near_end);
    set(handles.animation_settings_near_end_i,'UserData',config_data.i_near_end);
    set(handles.animation_settings_far_end_v,'UserData',config_data.v_far_end);
    set(handles.animation_settings_far_end_i,'UserData',config_data.i_far_end);
    set(handles.animation_settings_current_scale,'UserData',config_data.current_scale);
    set(handles.animation_settings_precision,'UserData',config_data.precision);
    handles.simulation_notes = config_data.simulation_note;
    set(handles.simulation_notes_text,'String',handles.simulation_notes)
    
    % Set voltage across checkmark
    if(config_data.v_across == 1)
        set(handles.animation_settings_across_v,'Checked','on');
    else
        set(handles.animation_settings_across_v,'Checked','off');
    end
    
    % Set forward traveling voltage across checkmark
    if(config_data.v_f_across == 1)
        set(handles.animation_settings_across_v_f,'Checked','on');
    else
        set(handles.animation_settings_across_v_f,'Checked','off');
    end
    
    % Set backward traveling voltage across checkmark
    if(config_data.v_b_across == 1)
        set(handles.animation_settings_across_v_b,'Checked','on');
    else
        set(handles.animation_settings_across_v_b,'Checked','off');
    end
    
    % Set voltage envelope across checkmark
    if(config_data.v_env_across == 1)
        set(handles.animation_settings_across_v_env,'Checked','on');
    else
        set(handles.animation_settings_across_v_env,'Checked','off');
    end
    
    % Set current across checkmark
    if(config_data.i_across == 1)
        set(handles.animation_settings_across_i,'Checked','on');
    else
        set(handles.animation_settings_across_i,'Checked','off');
    end
    
    % Set forward traveling current across checkmark
    if(config_data.i_f_across == 1)
        set(handles.animation_settings_across_i_f,'Checked','on');
    else
        set(handles.animation_settings_across_i_f,'Checked','off');
    end
    
    % Set backward traveling current across checkmark
    if(config_data.i_b_across == 1)
        set(handles.animation_settings_across_i_b,'Checked','on');
    else
        set(handles.animation_settings_across_i_b,'Checked','off');
    end
    
    % Set current envelope across checkmark
    if(config_data.i_env_across == 1)
        set(handles.animation_settings_across_i_env,'Checked','on');
    else
        set(handles.animation_settings_across_i_env,'Checked','off');
    end
    
    % Set voltage near end checkmark
    if(config_data.v_near_end == 1)
        set(handles.animation_settings_near_end_v,'Checked','on');
    else
        set(handles.animation_settings_near_end_v,'Checked','off');
    end
    
    % Set current near end checkmark
    if(config_data.i_near_end == 1)
        set(handles.animation_settings_near_end_i,'Checked','on');
    else
        set(handles.animation_settings_near_end_i,'Checked','off');
    end
    
    % Set voltage far end checkmark
    if(config_data.v_far_end == 1)
        set(handles.animation_settings_far_end_v,'Checked','on');
    else
        set(handles.animation_settings_far_end_v,'Checked','off');
    end
    
    % Set current far end checkmark
    if(config_data.i_far_end == 1)
        set(handles.animation_settings_far_end_i,'Checked','on');
    else
        set(handles.animation_settings_far_end_i,'Checked','off');
    end
    
    % Change transmission line settings text to either lossless or lossy depending on transmission line
    if(strcmp(handles.tline.tline_config,'lossless'))
        set(handles.tline_settings_text,'String','Lossless Transmission Line Settings');
    else
        set(handles.tline_settings_text,'String','Lossy Transmission Line Settings');
    end
end

% Set recalculation flag
handles.recalc_needed = 0;

% Update all edit boxes in GUI and set sources and loads
update_gui(handles);

end


% Update all edit boxes in GUI and set sources and loads
function update_gui(handles)

% Save handles structures
save_handles(handles);

%% Update All Edit Boxes


% Update source amplitude, putting in scientific notation if necessary
if(handles.tline.vs_amp < 10000 && handles.tline.vs_amp > .9999)
    set(handles.vs_amp,'String',num2str(handles.tline.vs_amp));
else
    set(handles.vs_amp,'String',num2str(handles.tline.vs_amp,'%.3g'));
end
set(handles.vs_amp,'UserData',handles.tline.vs_amp);

% Update source frequency, putting in scientific notation if necessary
if(handles.tline.freq < 10000 && handles.tline.freq > .9999)
    set(handles.freq,'String',num2str(handles.tline.freq));
else
    set(handles.freq,'String',num2str(handles.tline.freq,'%.3g'));
end
set(handles.freq,'UserData',handles.tline.freq);

% Update source impedance, putting in scientific notation if necessary
if(handles.tline.zs < 10000 && handles.tline.zs > .9999)
    set(handles.zs,'String',num2str(handles.tline.zs));
else
    set(handles.zs,'String',num2str(handles.tline.zs,'%.3g'));
end
set(handles.zs,'UserData',handles.tline.zs);

% Update load resistance, putting in scientific notation if necessary
if(handles.tline.rl < 10000 && handles.tline.rl > .9999)
    set(handles.rl,'String',num2str(handles.tline.rl));
else
    set(handles.rl,'String',num2str(handles.tline.rl,'%.3g'));
end
set(handles.rl,'UserData',handles.tline.rl);

% Update load inductance, putting in scientific notation if necessary
if(handles.tline.ll < 10000 && handles.tline.ll > .9999)
    set(handles.ll,'String',num2str(handles.tline.ll));
else
    set(handles.ll,'String',num2str(handles.tline.ll,'%.3g'));
end
set(handles.ll,'UserData',handles.tline.ll);

% Update load capacitance, putting in scientific notation if necessary
if(handles.tline.cl < 10000 && handles.tline.cl > .9999)
    set(handles.cl,'String',num2str(handles.tline.cl));
else
    set(handles.cl,'String',num2str(handles.tline.cl,'%.3g'));
end
set(handles.cl,'UserData',handles.tline.cl);

% Update stop time, putting in scientific notation if necessary
if(handles.tline.ts < 10000 && handles.tline.ts > .9999)
    set(handles.ts,'String',num2str(handles.tline.ts));
else
    set(handles.ts,'String',num2str(handles.tline.ts,'%.3g'));
end
set(handles.ts,'UserData',handles.tline.ts);


% If using the transient model
if(strcmp(handles.tline.animation_type,'transient'))
    % Update source rise time, putting in scientific notation if necessary
    if(handles.tline.tr < 10000 && handles.tline.tr > .9999)
        set(handles.tr,'String',num2str(handles.tline.tr));
    else
        set(handles.tr,'String',num2str(handles.tline.tr,'%.3g'));
    end
    set(handles.tr,'UserData',handles.tline.tr);
end

% If using the lossless transmission line
if(strcmp(handles.tline.tline_config,'lossless'))
    
    % Update characteristic impedance, putting in scientific notation if necessary
    if(handles.tline.z0 < 10000 && handles.tline.z0 > .9999)
        set(handles.z0,'String',num2str(handles.tline.z0));
    else
        set(handles.z0,'String',num2str(handles.tline.z0,'%.3g'));
    end
    set(handles.z0,'UserData',handles.tline.z0);
    
    % Update relative permittivity, putting in scientific notation if necessary
    if(handles.tline.epsilon_r < 10000 && handles.tline.epsilon_r > .9999)
        set(handles.epsilon_r,'String',num2str(handles.tline.epsilon_r));
    else
        set(handles.epsilon_r,'String',num2str(handles.tline.epsilon_r,'%.3g'));
    end
    set(handles.epsilon_r,'UserData',handles.tline.epsilon_r);
    
    % Update propagation delay, putting in scientific notation if necessary
    if(handles.tline.td < 10000 && handles.tline.td > .9999)
        set(handles.td,'String',num2str(handles.tline.td));
    else
        set(handles.td,'String',num2str(handles.tline.td,'%.3g'));
    end
    set(handles.td,'UserData',handles.tline.td);
    
end

% If using the lossy transmission line
if(strcmp(handles.tline.tline_config,'lossy'))
    
    % Update inductance per meter of the transmission line, putting in scientific notation if necessary
    if(handles.tline.L < 10000 && handles.tline.L > .9999)
        set(handles.L,'String',num2str(handles.tline.L));
    else
        set(handles.L,'String',num2str(handles.tline.L,'%.3g'));
    end
    set(handles.L,'UserData',handles.tline.L);
    
    % Update capacitance per meter of the transmission line, putting in scientific notation if necessary
    if(handles.tline.C < 10000 && handles.tline.C > .9999)
        set(handles.C,'String',num2str(handles.tline.C));
    else
        set(handles.C,'String',num2str(handles.tline.C,'%.3g'));
    end
    set(handles.C,'UserData',handles.tline.C);
    
    % Update resistance per meter of the transmission line, putting in scientific notation if necessary
    if(handles.tline.R < 10000 && handles.tline.R > .9999)
        set(handles.R,'String',num2str(handles.tline.R));
    else
        set(handles.R,'String',num2str(handles.tline.R,'%.3g'));
    end
    set(handles.R,'UserData',handles.tline.R);
    
    % Update conductance per meter of the transmission line, putting in scientific notation if necessary
    if(handles.tline.G < 10000 && handles.tline.G > .9999)
        set(handles.G,'String',num2str(handles.tline.G));
    else
        set(handles.G,'String',num2str(handles.tline.G,'%.3g'));
    end
    set(handles.G,'UserData',handles.tline.G);
    
    % Update length of transmission line, putting in scientific notation if necessary
    if(handles.tline.line_length < 10000 && handles.tline.line_length > .9999)
        set(handles.line_length,'String',num2str(handles.tline.line_length));
    else
        set(handles.line_length,'String',num2str(handles.tline.line_length,'%.3g'));
    end
    set(handles.line_length,'UserData',handles.tline.line_length);
    
end



%% Update Animation Slider
set(handles.animation_slider,'Value',0);
set(handles.animation_slider,'Min',0);
set(handles.animation_slider,'Max',handles.tline.ts);
slider_step = get(handles.animation_speed,'UserData')/handles.tline.num_pts;
set(handles.animation_slider,'SliderStep',[slider_step 5*slider_step]);


%% Update Images

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Set up images depending on the load being used
if(strcmp(handles.tline.load_config,'R'))
    % Set the load button image
    set_load_button(handles.R_load_button);
    % Set checkmark in the dropdown menu
    set_load_menu_check_marks(handles.tline_settings_load_R);
    % Move load resistor edit box to the correct position
    set(handles.rl,'Position',[660 116 50 20]);
    % Make load resistor edit box visible
    set(handles.rl,'Visible','on');
    % Make load inductor edit box invisible
    set(handles.ll,'Visible','off');
    % Make load capacitor edit box invisible
    set(handles.cl,'Visible','off');
elseif(strcmp(handles.tline.load_config,'L'))
    % Set the load button image
    set_load_button(handles.L_load_button);
    % Set checkmark in the dropdown menu
    set_load_menu_check_marks(handles.tline_settings_load_L);
    % Move load inductor edit box to the correct position
    set(handles.ll,'Position',[660 116 50 20]);
    % Make load inductor edit box visible
    set(handles.ll,'Visible','on');
    % Make load resistor edit box invisible
    set(handles.rl,'Visible','off');
    % Make load capacitor edit box invisible
    set(handles.cl,'Visible','off');
elseif(strcmp(handles.tline.load_config,'C'))
    % Set the load button image
    set_load_button(handles.C_load_button);
    % Set checkmark in the dropdown menu
    set_load_menu_check_marks(handles.tline_settings_load_C);
    % Move load capacitor edit box to the correct position
    set(handles.cl,'Position',[660 116 50 20]);
    % Make load capacitor edit box visible
    set(handles.cl,'Visible','on');
    % Make load resistor edit box invisible
    set(handles.rl,'Visible','off');
    % Make load inductor edit box invisible
    set(handles.ll,'Visible','off');
elseif(strcmp(handles.tline.load_config,'R_ser_L'))
    % Set the load button image
    set_load_button(handles.R_ser_L_load_button);
    % Set checkmark in the dropdown menu
    set_load_menu_check_marks(handles.tline_settings_load_R_ser_L);
    % Move load resistor edit box to the correct position
    set(handles.rl,'Position',[660 149 50 20]);
    % Make load resistor edit box visible
    set(handles.rl,'Visible','on');
    % Move load inductor edit box to the correct position
    set(handles.ll,'Position',[660 104 50 20]);
    % Make load inductor edit box visible
    set(handles.ll,'Visible','on');
    % Make load capacitor edit box invisible
    set(handles.cl,'Visible','off');
elseif(strcmp(handles.tline.load_config,'R_ser_C'))
    % Set the load button image
    set_load_button(handles.R_ser_C_load_button);
    % Set checkmark in the dropdown menu
    set_load_menu_check_marks(handles.tline_settings_load_R_ser_C);
    % Move load resistor edit box to the correct position
    set(handles.rl,'Position',[660 149 50 20]);
    % Make load resistor edit box visible
    set(handles.rl,'Visible','on');
    % Move load capacitor edit box to the correct position
    set(handles.cl,'Position',[660 104 50 20]);
    % Make load capacitor edit box visible
    set(handles.cl,'Visible','on');
    % Make load inductor edit box invisible
    set(handles.ll,'Visible','off');
elseif(strcmp(handles.tline.load_config,'R_ser_L_ser_C'))
    % Set the load button image
    set_load_button(handles.R_ser_L_ser_C_load_button);
    % Set checkmark in the dropdown menu
    set_load_menu_check_marks(handles.tline_settings_load_R_ser_L_ser_C);
    % Move load resistor edit box to the correct position
    set(handles.rl,'Position',[660 175 50 20]);
    % Make load resistor edit box visible
    set(handles.rl,'Visible','on');
    % Move load inductor edit box to the correct position
    set(handles.ll,'Position',[660 130 50 20]);
    % Make load inductor edit box visible
    set(handles.ll,'Visible','on');
    % Move load capacitor edit box to the correct position
    set(handles.cl,'Position',[660 85 50 20]);
    % Make load capacitor edit box visible
    set(handles.cl,'Visible','on');
elseif(strcmp(handles.tline.load_config,'R_par_L'))
    % Set the load button image
    set_load_button(handles.R_par_L_load_button);
    % Set checkmark in the dropdown menu
    set_load_menu_check_marks(handles.tline_settings_load_R_par_L);
    % Move load resistor edit box to the correct position
    set(handles.rl,'Position',[616 113 50 20]);
    % Make load resistor edit box visible
    set(handles.rl,'Visible','on');
    % Move load inductor edit box to the correct position
    set(handles.ll,'Position',[687 113 50 20]);
    % Make load inductor edit box visible
    set(handles.ll,'Visible','on');
    % Make load capacitor edit box invisible
    set(handles.cl,'Visible','off');
elseif(strcmp(handles.tline.load_config,'R_par_C'))
    % Set the load button image
    set_load_button(handles.R_par_C_load_button);
    % Set checkmark in the dropdown menu
    set_load_menu_check_marks(handles.tline_settings_load_R_par_C);
    % Move load resistor edit box to the correct position
    set(handles.rl,'Position',[613 113 50 20]);
    % Make load resistor edit box visible
    set(handles.rl,'Visible','on');
    % Move load capacitor edit box to the correct position
    set(handles.cl,'Position',[693 113 50 20]);
    % Make load capacitor edit box visible
    set(handles.cl,'Visible','on');
    % Make load inductor edit box invisible
    set(handles.ll,'Visible','off');
elseif(strcmp(handles.tline.load_config,'R_par_L_par_C'))
    % Set the load button image
    set_load_button(handles.R_par_L_par_C_load_button);
    % Set checkmark in the dropdown menu
    set_load_menu_check_marks(handles.tline_settings_load_R_par_L_par_C);
    % Move load resistor edit box to the correct position
    set(handles.rl,'Position',[577 113 50 20]);
    % Make load resistor edit box visible
    set(handles.rl,'Visible','on');
    % Move load inductor edit box to the correct position
    set(handles.ll,'Position',[650 113 50 20]);
    % Make load inductor edit box visible
    set(handles.ll,'Visible','on');
    % Move load capacitor edit box to the correct position
    set(handles.cl,'Position',[732 113 50 20]);
    % Make load capacitor edit box visible
    set(handles.cl,'Visible','on');
end


% If using a step source
if(strcmp(handles.tline.src_config,'step'))
    % Move source amplitude edit box to the correct position
    set(handles.vs_amp,'Position',[41 135 50 20]);
    % Make the source rise time edit box invisible
    set(handles.tr,'Visible','off');
    % Make the source frequency edit box invisible
    set(handles.freq,'Visible','off');
    % Set step source check mark state to on for the source menu
    set(handles.tline_settings_source_step,'UserData',1);
    % Turn step source check mark on in the source menu
    set(handles.tline_settings_source_step,'Checked','on');
    % Set ramped step check mark state to off for the source menu
    set(handles.tline_settings_source_ramped_step,'UserData',0);
    % Turn ramped step check mark off in the source menu
    set(handles.tline_settings_source_ramped_step,'Checked','off');
    % Set sine check mark state to off for the source menu
    set(handles.tline_settings_source_sine,'UserData',0);
    % Turn sine check mark off in the source menu
    set(handles.tline_settings_source_sine,'Checked','off');
    % If using a ramped step source
elseif(strcmp(handles.tline.src_config,'ramped_step'))
    % Move source amplitude edit box to the correct position
    set(handles.vs_amp,'Position',[41 160 50 20]);
    % Make the source rise time edit box visible
    set(handles.tr,'Visible','on');
    % Move source rise time edit box to the correct position
    set(handles.tr,'Position',[41 109 50 20]);
    % Make the source frequency edit box invisible
    set(handles.freq,'Visible','off');
    % Set ramped step check mark state to on for the source menu
    set(handles.tline_settings_source_ramped_step,'UserData',1);
    % Turn ramped step check mark on in the source menu
    set(handles.tline_settings_source_ramped_step,'Checked','on');
    % Set step source check mark state to off for the source menu
    set(handles.tline_settings_source_step,'UserData',0);
    % Turn step source check mark off in the source menu
    set(handles.tline_settings_source_step,'Checked','off');
    % Set sine check mark state to off for the source menu
    set(handles.tline_settings_source_sine,'UserData',0);
    % Turn sine check mark off in the source menu
    set(handles.tline_settings_source_sine,'Checked','off');
    % If using a sine source
elseif(strcmp(handles.tline.src_config,'sine'))
    % Move source amplitude edit box to the correct position
    set(handles.vs_amp,'Position',[41 160 50 20]);
    % Make the source frequency edit box visible
    set(handles.freq,'Visible','on');
    % Move source frequency edit box to the correct position
    set(handles.freq,'Position',[41 112 50 20]);
    % Make the source rise time edit box invisible
    set(handles.tr,'Visible','off');
    % Set sine check mark state to on for the source menu
    set(handles.tline_settings_source_sine,'UserData',1);
    % Turn sine check mark on in the source menu
    set(handles.tline_settings_source_sine,'Checked','on');
    % Set step source check mark state to off for the source menu
    set(handles.tline_settings_source_step,'UserData',0);
    % Turn step source check mark off in the source menu
    set(handles.tline_settings_source_step,'Checked','off');
    % Set ramped step check mark state to off for the source menu
    set(handles.tline_settings_source_ramped_step,'UserData',0);
    % Turn ramped step check mark off in the source menu
    set(handles.tline_settings_source_ramped_step,'Checked','off');
end

% If animation type is transient
if(strcmp(handles.tline.animation_type,'transient'))
    
    % Set transient check mark state to on for the animation menu
    set(handles.tline_settings_animation_transient,'UserData',1);
    % Turn transient check mark on in the animation menu
    set(handles.tline_settings_animation_transient,'Checked','on');
    % Set steady state check mark state to off for the animation menu
    set(handles.tline_settings_animation_steady_state,'UserData',0);
    % Turn steady state check mark off in the animation menu
    set(handles.tline_settings_animation_steady_state,'Checked','off');
    
    % Make characteristic impedance edit box visible
    set(handles.z0,'Visible','on');
    % Make relative permittivity edit box visible
    set(handles.epsilon_r,'Visible','on');
    % Make propagation delay edit box visible
    set(handles.td,'Visible','on');
    % Make inductance per meter edit box invisible
    set(handles.L,'Visible','off');
    % Make capacitance per meter edit box invisible
    set(handles.C,'Visible','off');
    % Make resistance per meter edit box invisible
    set(handles.R,'Visible','off');
    % Make conductance per meter edit box invisible
    set(handles.G,'Visible','off');
    % Make line length edit box invisible
    set(handles.line_length,'Visible','off');
    
    % Disable the plot envelope option
    set(handles.animation_settings_across_v_env,'Enable','off');
    set(handles.animation_settings_across_i_env,'Enable','off');
    
    % If animation type is steady state
elseif(strcmp(handles.tline.animation_type,'steady_state'))
    
    % Set steady state check mark state to on for the animation menu
    set(handles.tline_settings_animation_steady_state,'UserData',1);
    % Turn steady state check mark on in the animation menu
    set(handles.tline_settings_animation_steady_state,'Checked','on');
    % Set transient check mark state to off for the animation menu
    set(handles.tline_settings_animation_transient,'UserData',0);
    % Turn transient check mark off in the animation menu
    set(handles.tline_settings_animation_transient,'Checked','off');
    
    % Make inductance per meter edit box visible
    set(handles.L,'Visible','on');
    % Make capacitance per meter edit box visible
    set(handles.C,'Visible','on');
    % Make resistance per meter edit box visible
    set(handles.R,'Visible','on');
    % Make conductance per meter edit box visible
    set(handles.G,'Visible','on');
    % Make line length edit box visible
    set(handles.line_length,'Visible','on');
    % Make characteristic impedance edit box invisible
    set(handles.z0,'Visible','off');
    % Make relative permittivity edit box invisible
    set(handles.epsilon_r,'Visible','off');
    % Make propagation delay edit box invisible
    set(handles.td,'Visible','off');
    % Make source rise time edit box invisible
    set(handles.tr,'Visible','off');
    
    % Enable the plot envelope option
    set(handles.animation_settings_across_v_env,'Enable','on');
    set(handles.animation_settings_across_i_env,'Enable','on');
    
end


% If the transmission line is lossless
if(strcmp(handles.tline.tline_config,'lossless'))
    % Change transmission line settings text to either lossless
    set(handles.tline_settings_text,'String','Lossless Transmission Line Settings');
    % Set lossless check mark state to on for the line menu
    set(handles.tline_settings_line_lossless,'UserData',1);
    % Turn lossless check mark on in the line menu
    set(handles.tline_settings_line_lossless,'Checked','on');
    % Enable lossless option in the line menu
    set(handles.tline_settings_line_lossless,'Enable','on');
    % Set lossy check mark state to off for the line menu
    set(handles.tline_settings_line_lossy,'UserData',0);
    % Turn lossy check mark off in the line menu
    set(handles.tline_settings_line_lossy,'Checked','off');
    % Disable lossy option in the line menu
    set(handles.tline_settings_line_lossy,'Enable','off');
    % If the transmission line is lossy
else
    % Change transmission line settings text to either lossless
    set(handles.tline_settings_text,'String','Lossy Transmission Line Settings');
    % Set lossy check mark state to on for the line menu
    set(handles.tline_settings_line_lossy,'UserData',1);
    % Turn lossy check mark on in the line menu
    set(handles.tline_settings_line_lossy,'Checked','on');
    % Enable lossy option in the line menu
    set(handles.tline_settings_line_lossy,'Enable','on');
    % Set lossless check mark state to off for the line menu
    set(handles.tline_settings_line_lossless,'UserData',0);
    % Turn lossless check mark off in the line menu
    set(handles.tline_settings_line_lossless,'Checked','off');
    % Disable lossless option in the line menu
    set(handles.tline_settings_line_lossless,'Enable','off');
end


end

% Set the selected load buttons image and state to selected and unselect all other buttons
function set_load_button(button_handle)

% Get handles structure
handles = guidata(button_handle);

% Set all buttons image to the unselected image
set(handles.R_load_button,'CData',imread(['images',filesep,get(handles.R_load_button,'Tag'),'.jpg']));
set(handles.L_load_button,'CData',imread(['images',filesep,get(handles.L_load_button,'Tag'),'.jpg']));
set(handles.C_load_button,'CData',imread(['images',filesep,get(handles.C_load_button,'Tag'),'.jpg']));
set(handles.R_ser_L_load_button,'CData',imread(['images',filesep,get(handles.R_ser_L_load_button,'Tag'),'.jpg']));
set(handles.R_ser_C_load_button,'CData',imread(['images',filesep,get(handles.R_ser_C_load_button,'Tag'),'.jpg']));
set(handles.R_ser_L_ser_C_load_button,'CData',imread(['images',filesep,get(handles.R_ser_L_ser_C_load_button,'Tag'),'.jpg']));
set(handles.R_par_L_load_button,'CData',imread(['images',filesep,get(handles.R_par_L_load_button,'Tag'),'.jpg']));
set(handles.R_par_C_load_button,'CData',imread(['images',filesep,get(handles.R_par_C_load_button,'Tag'),'.jpg']));
set(handles.R_par_L_par_C_load_button,'CData',imread(['images',filesep,get(handles.R_par_L_par_C_load_button,'Tag'),'.jpg']));

% Set the specified buttons image to the selected image
set(button_handle,'CData',imread(['images',filesep,get(button_handle,'Tag'),'_sel.jpg']));

% Set all buttons UserData to 0 to indicate button isnt selected
set(handles.R_load_button,'UserData',0);
set(handles.L_load_button,'UserData',0);
set(handles.C_load_button,'UserData',0);
set(handles.R_ser_L_load_button,'UserData',0);
set(handles.R_ser_C_load_button,'UserData',0);
set(handles.R_ser_L_ser_C_load_button,'UserData',0);
set(handles.R_par_L_load_button,'UserData',0);
set(handles.R_par_C_load_button,'UserData',0);
set(handles.R_par_L_par_C_load_button,'UserData',0);

% Set UserData of the specified button_handle to 1 to indicate that it
% is selected
set(button_handle,'UserData',1);

% Save handles structure
guidata(button_handle,handles);

end

% Sets the check mark in the load menu specified by hObject
function set_load_menu_check_marks(hObject)

% Get handles structure
handles = guidata(hObject);

% Set all check mark states to off for the load menu
set(handles.tline_settings_load_R,'UserData',0);
set(handles.tline_settings_load_L,'UserData',0);
set(handles.tline_settings_load_C,'UserData',0);
set(handles.tline_settings_load_R_ser_L,'UserData',0);
set(handles.tline_settings_load_R_ser_C,'UserData',0);
set(handles.tline_settings_load_R_ser_L_ser_C,'UserData',0);
set(handles.tline_settings_load_R_par_L,'UserData',0);
set(handles.tline_settings_load_R_par_C,'UserData',0);
set(handles.tline_settings_load_R_par_L_par_C,'UserData',0);

% Turn all check marks off in the load menu
set(handles.tline_settings_load_R,'Checked','off');
set(handles.tline_settings_load_L,'Checked','off');
set(handles.tline_settings_load_C,'Checked','off');
set(handles.tline_settings_load_R_ser_L,'Checked','off');
set(handles.tline_settings_load_R_ser_C,'Checked','off');
set(handles.tline_settings_load_R_ser_L_ser_C,'Checked','off');
set(handles.tline_settings_load_R_par_L,'Checked','off');
set(handles.tline_settings_load_R_par_C,'Checked','off');
set(handles.tline_settings_load_R_par_L_par_C,'Checked','off');

% Set the check mark state of hObject to on
set(hObject,'UserData',1);
% Turn on the check mark of hObject
set(hObject,'Checked','on');

% Save handles structures
save_handles(handles);

end

% Set figure window visibility when user makes change in dropdown menu
function set_figure_window_visibility(menu_item_handle,fig_handle)

% Get handles structure
handles = guidata(menu_item_handle);

% If check state was off
if(get(menu_item_handle,'UserData') == 0)
    % Set check state to on
    set(menu_item_handle,'UserData',1);
    % Turn check on
    set(menu_item_handle,'Checked','on');
    % Make source selection panel visible
    set(fig_handle,'Visible','on');
    % If check state was on
else
    % Set check state to off
    set(menu_item_handle,'UserData',0)
    % Turn check off
    set(menu_item_handle,'Checked','off');
    % Make source selection panel invisible
    set(fig_handle,'Visible','off');
end

% Save handles structures
save_handles(handles);

end

% Set the selected source buttons image and state to selected and unselect all other buttons
function set_source_button(button_handle)

% Get handles structure
handles = guidata(button_handle);

% Set all buttons image to the unselected image
set(handles.step_source_button,'CData',imread(['images',filesep,get(handles.step_source_button,'Tag'),'.jpg']));
set(handles.ramped_step_source_button,'CData',imread(['images',filesep,get(handles.ramped_step_source_button,'Tag'),'.jpg']));
set(handles.sine_source_button,'CData',imread(['images',filesep,get(handles.sine_source_button,'Tag'),'.jpg']));

% Set the specified buttons image to the selected image
set(button_handle,'CData',imread(['images',filesep,get(button_handle,'Tag'),'_sel.jpg']));

% Set all buttons UserData to 0 to indicate button isnt selected
set(handles.step_source_button,'UserData',0);
set(handles.ramped_step_source_button,'UserData',0);
set(handles.sine_source_button,'UserData',0);

% Set UserData of the specified button_handle to 1 to indicate that it
% is selected
set(button_handle,'UserData',1);

% Save handles structure
guidata(button_handle,handles);

end

% Toggles the check mark of a uimenu object
function toggle_menu_check_mark(hObject)
% If currently checked
if(get(hObject,'UserData') == 1)
    % Set checked state to off
    set(hObject,'UserData',0);
    % Uncheck
    set(hObject,'Checked','off');
    % If currently unchecked
elseif(get(hObject,'UserData') == 0)
    % Set checked state to on
    set(hObject,'UserData',1);
    % Check
    set(hObject,'Checked','on');
end
end

% Sets the check mark in the source menu specified by hObject
function set_source_menu_check_marks(hObject)

% Get handles structure
handles = guidata(hObject);

% Set all check mark states to off for the source menu
set(handles.tline_settings_source_step,'UserData',0);
set(handles.tline_settings_source_ramped_step,'UserData',0);
set(handles.tline_settings_source_sine,'UserData',0);

% Turn all check marks off in the source menu
set(handles.tline_settings_source_step,'Checked','off');
set(handles.tline_settings_source_ramped_step,'Checked','off');
set(handles.tline_settings_source_sine,'Checked','off');

% Set the check mark state of hObject to on
set(hObject,'UserData',1);
% Turn on the check mark of hObject
set(hObject,'Checked','on');

% Save handles structures
save_handles(handles);

end

% Update Axes Names
function update_axes_names(hObject)

% Get handles structure
handles = guidata(hObject);

% Get states of all voltages and currents being plotted
v_across = get(handles.animation_settings_across_v,'UserData');
v_f_across = get(handles.animation_settings_across_v_f,'UserData');
v_b_across = get(handles.animation_settings_across_v_b,'UserData');
i_across = get(handles.animation_settings_across_i,'UserData');
i_f_across = get(handles.animation_settings_across_i_f,'UserData');
i_b_across = get(handles.animation_settings_across_i_b,'UserData');
v_near_end = get(handles.animation_settings_near_end_v,'UserData');
i_near_end = get(handles.animation_settings_near_end_i,'UserData');
v_far_end = get(handles.animation_settings_far_end_v,'UserData');
i_far_end = get(handles.animation_settings_far_end_i,'UserData');


v_across = v_across || v_f_across || v_b_across;
i_across = i_across || i_f_across || i_b_across;

% If plotting voltage and current across the transmission line
if(v_across && i_across)
    set(handles.ax_dist.Title,'String','Voltage and Current Across Transmission Line');
    set(handles.ax_dist.YLabel,'String','Voltage (V) Current (A)');
    % If plotting only voltage across the transmission line
elseif(v_across && ~i_across)
    set(handles.ax_dist.Title,'String','Voltage Across Transmission Line');
    set(handles.ax_dist.YLabel,'String','Voltage (V)');
    % If plotting only current across the transmission line
elseif(i_across && ~v_across)
    set(handles.ax_dist.Title,'String','Current Across Transmission Line');
    set(handles.ax_dist.YLabel,'String','Current (A)');
end

% If plotting voltage and current at the near end of the transmission line
if(v_near_end && i_near_end)
    set(handles.ax_src.Title,'String','Voltage and Current at Near End of Transmission Line');
    set(handles.ax_src.YLabel,'String','Voltage (V) Current (A)');
    % If plotting only voltage at the near end of the transmission line
elseif(v_near_end && ~i_near_end)
    set(handles.ax_src.Title,'String','Voltage at Near End of Transmission Line');
    set(handles.ax_src.YLabel,'String','Voltage (V)');
    % If plotting only current at the near end of the transmission line
elseif(i_near_end && ~v_near_end)
    set(handles.ax_src.Title,'String','Current at Near End of Transmission Line');
    set(handles.ax_src.YLabel,'String','Current (A)');
end

% If plotting voltage and current at the far end of the transmission line
if(v_far_end && i_far_end)
    set(handles.ax_load.Title,'String','Voltage and Current at Far End of Transmission Line');
    set(handles.ax_load.YLabel,'String','Voltage (V) Current (A)');
    % If plotting only voltage at the far end of the transmission line
elseif(v_far_end && ~i_far_end)
    set(handles.ax_load.Title,'String','Voltage at Far End of Transmission Line');
    set(handles.ax_load.YLabel,'String','Voltage (V)');
    % If plotting only current at the far end of the transmission line
elseif(i_far_end && ~v_far_end)
    set(handles.ax_load.Title,'String','Current at Far End of Transmission Line');
    set(handles.ax_load.YLabel,'String','Current (A)');
end

% Save handles structures
save_handles(handles);

end


% Set all of the edit boxs states to inactive
% By setting all of the edit boxes states to inactive, it will highlight
% the text in the edit box when the user clicks the edit box.
function set_edit_boxes_inactive(handles)

% Set all edit boxes to inactive
set(handles.animation_speed,'Enable','inactive');
set(handles.ts,'Enable','inactive');
set(handles.vs_amp,'Enable','inactive');
set(handles.zs,'Enable','inactive');
set(handles.z0,'Enable','inactive');
set(handles.td,'Enable','inactive');
set(handles.rl,'Enable','inactive');
set(handles.ll,'Enable','inactive');
set(handles.cl,'Enable','inactive');

% Save Handles Structure
guidata(handles.tline_settings_fig,handles)

end

% Plot Transmission Line Data
function plot_tline_data(handles)

plot_v_tline = get(handles.animation_settings_across_v,'UserData');
plot_v_fwd_tline = get(handles.animation_settings_across_v_f,'UserData');
plot_v_bck_tline = get(handles.animation_settings_across_v_b,'UserData');
plot_v_env_tline = get(handles.animation_settings_across_v_env,'UserData');
plot_i_tline = get(handles.animation_settings_across_i,'UserData');
plot_i_fwd_tline = get(handles.animation_settings_across_i_f,'UserData');
plot_i_bck_tline = get(handles.animation_settings_across_i_b,'UserData');
plot_i_env_tline = get(handles.animation_settings_across_i_env,'UserData');
plot_v_src = get(handles.animation_settings_near_end_v,'UserData');
plot_v_load = get(handles.animation_settings_far_end_v,'UserData');
plot_i_src = get(handles.animation_settings_near_end_i,'UserData');
plot_i_load = get(handles.animation_settings_far_end_i,'UserData');

current_scale = get(handles.animation_settings_current_scale,'UserData');

% Set minimums and maximums for the plots
y_min_v_src = min([0,1.1*min(handles.tline.v_src) - 0.1*max(handles.tline.v_src)]);
y_max_v_src = 1.1*max(handles.tline.v_src) - 0.1*min(handles.tline.v_src);
y_min_v_load = min([0,1.1*min(handles.tline.v_load) - 0.1*max(handles.tline.v_load)]);
y_max_v_load = 1.1*max(handles.tline.v_load) - 0.1*min(handles.tline.v_load);
y_min_v_tline = min([0,1.1*min(min(handles.tline.v_tline)) - 0.1*max(max(handles.tline.v_tline))]);
y_max_v_tline = 1.1*max(max(handles.tline.v_tline)) - 0.1*min(min(handles.tline.v_tline));
y_min_v_fwd_tline = min([0,1.1*min(min(handles.tline.v_fwd_tline)) - 0.1*max(max(handles.tline.v_fwd_tline))]);
y_max_v_fwd_tline = 1.1*max(max(handles.tline.v_fwd_tline)) - 0.1*min(min(handles.tline.v_fwd_tline));
y_min_v_bck_tline = min([0,1.1*min(min(handles.tline.v_bck_tline)) - 0.1*max(max(handles.tline.v_bck_tline))]);
y_max_v_bck_tline = 1.1*max(max(handles.tline.v_bck_tline)) - 0.1*min(min(handles.tline.v_bck_tline));
y_min_i_src = min([0,1.1*min(handles.tline.i_src) - 0.1*max(handles.tline.i_src)]);
y_max_i_src = 1.1*max(handles.tline.i_src) - 0.1*min(handles.tline.i_src);
y_min_i_load = min([0,1.1*min(handles.tline.i_load) - 0.1*max(handles.tline.i_load)]);
y_max_i_load = 1.1*max(handles.tline.i_load) - 0.1*min(handles.tline.i_load);
y_min_i_tline = min([0,1.1*min(min(handles.tline.i_tline)) - 0.1*max(max(handles.tline.i_tline))]);
y_max_i_tline = 1.1*max(max(handles.tline.i_tline)) - 0.1*min(min(handles.tline.i_tline));
y_min_i_fwd_tline = min([0,1.1*min(min(handles.tline.i_fwd_tline)) - 0.1*max(max(handles.tline.i_fwd_tline))]);
y_max_i_fwd_tline = 1.1*max(max(handles.tline.i_fwd_tline)) - 0.1*min(min(handles.tline.i_fwd_tline));
y_min_i_bck_tline = min([0,1.1*min(min(handles.tline.i_bck_tline)) - 0.1*max(max(handles.tline.i_bck_tline))]);
y_max_i_bck_tline = 1.1*max(max(handles.tline.i_bck_tline)) - 0.1*min(min(handles.tline.i_bck_tline));

y_min_src = min([y_min_v_src*plot_v_src, y_min_i_src*plot_i_src*current_scale]);
y_max_src = max([y_max_v_src*plot_v_src, y_max_i_src*plot_i_src*current_scale]);
y_min_load = min([y_min_v_load*plot_v_load, y_min_i_load*plot_i_load*current_scale]);
y_max_load = max([y_max_v_load*plot_v_load, y_max_i_load*plot_i_load*current_scale]);
y_min_dist = min([y_min_v_tline*plot_v_tline, y_min_v_fwd_tline*plot_v_fwd_tline, y_min_v_bck_tline*plot_v_bck_tline,...
    y_min_i_tline*plot_i_tline*current_scale, y_min_i_fwd_tline*plot_i_fwd_tline*current_scale, y_min_i_bck_tline*plot_i_bck_tline*current_scale]);
y_max_dist = max([y_max_v_tline*plot_v_tline, y_max_v_fwd_tline*plot_v_fwd_tline, y_max_v_bck_tline*plot_v_bck_tline,...
    y_max_i_tline*plot_i_tline*current_scale, y_max_i_fwd_tline*plot_i_fwd_tline*current_scale, y_max_i_bck_tline*plot_i_bck_tline*current_scale]);

% If voltage at the load stays 0,
% set the y limits to a small number
if(y_min_load == 0 && y_max_load == 0)
    y_min_load = -1e-16;
    y_max_load = 1e-16;
end

% If voltage at the source stays 0,
% set the y limits to a small number
if(y_min_src == 0 && y_max_src == 0)
    y_min_src = -1e-16;
    y_max_src = 1e-16;
end

% Set the current axis to the distance axis
axes(handles.ax_dist);
% Clear what is currently in the distance axis
cla;
% Set the limits of the x axis
set(handles.ax_dist,'XLim',[0 handles.tline.dist(end)]);
% Set the limits of the y axis
set(handles.ax_dist,'YLim',[y_min_dist,y_max_dist]);
% Create forward traveling voltage wave animated line handle
h_v_fwd_tline = animatedline('Parent',handles.ax_dist,...
    'Color',handles.v_fwd_tline_color,...
    'LineStyle',':',...
    'Linewidth',3);
% Create backward traveling voltage wave animated line handle
h_v_bck_tline = animatedline('Parent',handles.ax_dist,...
    'Color',handles.v_bck_tline_color,...
    'LineStyle',':',...
    'Linewidth',3);
% Create overall transmission line voltage animated line handle
h_v_tline = animatedline('Parent',handles.ax_dist,...
    'Color',handles.v_tline_color,...
    'Linewidth',3);
% Create top voltage envelope animated line handle
h_v_env_top_tline = animatedline('Parent',handles.ax_dist,...
    'Color',handles.v_env_tline_color,...
    'LineStyle',':',...
    'Linewidth',2);
% Create bottom voltage envelope animated line handle
h_v_env_bot_tline = animatedline('Parent',handles.ax_dist,...
    'Color',handles.v_env_tline_color,...
    'LineStyle',':',...
    'Linewidth',2);

% Create forward traveling current wave animated line handle
h_i_fwd_tline = animatedline('Parent',handles.ax_dist,...
    'Color',handles.i_fwd_tline_color,...
    'LineStyle',':',...
    'Linewidth',3);
% Create backward traveling current wave animated line handle
h_i_bck_tline = animatedline('Parent',handles.ax_dist,...
    'Color',handles.i_bck_tline_color,...
    'LineStyle',':',...
    'Linewidth',3);
% Create overall transmission line current animated line handle
h_i_tline = animatedline('Parent',handles.ax_dist,...
    'Color',handles.i_tline_color,...
    'Linewidth',3);
% Create top current envelope animated line handle
h_i_env_top_tline = animatedline('Parent',handles.ax_dist,...
    'Color',handles.i_env_tline_color,...
    'LineStyle',':',...
    'Linewidth',2);
% Create bottom current envelope animated line handle
h_i_env_bot_tline = animatedline('Parent',handles.ax_dist,...
    'Color',handles.i_env_tline_color,...
    'LineStyle',':',...
    'Linewidth',2);


% Set the current axis to the source axis
axes(handles.ax_src);
% Clear what is currently in the source axis
cla;
% Set the limits of the x axis
set(handles.ax_src,'XLim',[0 handles.tline.ts]);
% Set the limits of the y axis
set(handles.ax_src,'YLim',[y_min_src,y_max_src]);
% Create source voltage animated line handle
h_v_src = animatedline('Parent',handles.ax_src,...
    'Color','b',...
    'Linewidth',3);
% Create source voltage marker animated line handle
h_v_src_marker = animatedline('Parent',handles.ax_src,...
    'Color','r',...
    'Marker','.',...
    'MarkerSize',20);
% Create source current animated line handle
h_i_src = animatedline('Parent',handles.ax_src,...
    'Color','r',...
    'Linewidth',3);
% Create source current marker animated line handle
h_i_src_marker = animatedline('Parent',handles.ax_src,...
    'Color','y',...
    'Marker','.',...
    'MarkerSize',20);

% Set the current axis to the load axis
axes(handles.ax_load);
% Clear what is currently in the load axis
cla;
% Set the limits of the x axis
set(handles.ax_load,'XLim',[0 handles.tline.ts]);
% Set the limits of the y axis
set(handles.ax_load,'YLim',[y_min_load,y_max_load]);
% Create load voltage animated line handle
h_v_load = animatedline('Parent',handles.ax_load,...
    'Color','b',...
    'Linewidth',3);
% Create load voltage marker animated line handle
h_v_load_marker = animatedline('Parent',handles.ax_load,...
    'Color','r',...
    'Marker','.',...
    'MarkerSize',20);
% Create load current animated line handle
h_i_load = animatedline('Parent',handles.ax_load,...
    'Color','r',...
    'Linewidth',3);
% Create load current marker animated line handle
h_i_load_marker = animatedline('Parent',handles.ax_load,...
    'Color','y',...
    'Marker','.',...
    'MarkerSize',20);

% If plotting the overall voltage on the transmission line
if(plot_v_tline)
    % Add the points to the plot
    addpoints(h_v_tline, handles.tline.dist, handles.tline.v_tline(handles.plot_idx,:));
end

% If plotting the forward voltage wave on the transmission line
if(plot_v_fwd_tline)
    % Add the points to the plot
    addpoints(h_v_fwd_tline, handles.tline.dist, handles.tline.v_fwd_tline(handles.plot_idx,:));
end

% If plotting the backward voltage wave on the transmission line
if(plot_v_bck_tline)
    % Add the points to the plot
    addpoints(h_v_bck_tline, handles.tline.dist, handles.tline.v_bck_tline(handles.plot_idx,:));
end

% If plotting the voltage envelope on the transmission line
if(plot_v_env_tline)
    % Add the points to the plot
    addpoints(h_v_env_top_tline, handles.tline.dist, handles.tline.v_env_tline(1,:));
    addpoints(h_v_env_bot_tline, handles.tline.dist, -handles.tline.v_env_tline(1,:));
end

% If plotting the overall current on the transmission line
if(plot_i_tline)
    % Add the points to the plot
    addpoints(h_i_tline, handles.tline.dist, current_scale * handles.tline.i_tline(handles.plot_idx,:));
end

% If plotting the forward current wave on the transmission line
if(plot_i_fwd_tline)
    % Add the points to the plot
    addpoints(h_i_fwd_tline, handles.tline.dist, current_scale * handles.tline.i_fwd_tline(handles.plot_idx,:));
end

% If plotting the backward current wave on the transmission line
if(plot_i_bck_tline)
    % Add the points to the plot
    addpoints(h_i_bck_tline, handles.tline.dist, current_scale * handles.tline.i_bck_tline(handles.plot_idx,:));
end

% If plotting the current envelope on the transmission line
if(plot_i_env_tline)
    % Add the points to the plot
    addpoints(h_i_env_top_tline, handles.tline.dist, current_scale * handles.tline.i_env_tline(1,:));
    addpoints(h_i_env_bot_tline, handles.tline.dist, current_scale * -handles.tline.i_env_tline(1,:));
end

% If plotting the voltage at the source
if(plot_v_src)
    % Add voltage points to the source plot
    addpoints(h_v_src, handles.tline.time(1:handles.plot_idx), handles.tline.v_src(1:handles.plot_idx));
    % Add the source voltage marker to the source plot
    addpoints(h_v_src_marker, handles.tline.time(handles.plot_idx), handles.tline.v_src(handles.plot_idx));
end

% If plotting the current at the source
if(plot_i_src)
    % Add current points to the source plot
    addpoints(h_i_src, handles.tline.time(1:handles.plot_idx), current_scale * handles.tline.i_src(1:handles.plot_idx));
    % Add the source current marker to the source plot
    addpoints(h_i_src_marker, handles.tline.time(handles.plot_idx), current_scale * handles.tline.i_src(handles.plot_idx));
end

% If plotting the voltage at the load
if(plot_v_load)
    % Add voltage points to the load plot
    addpoints(h_v_load, handles.tline.time(1:handles.plot_idx), handles.tline.v_load(1:handles.plot_idx));
    % Add the load voltage marker to the load plot
    addpoints(h_v_load_marker, handles.tline.time(handles.plot_idx), handles.tline.v_load(handles.plot_idx));
end

% If plotting the current at the load
if(plot_i_load)
    % Add current points to the load plot
    addpoints(h_i_load, handles.tline.time(1:handles.plot_idx), current_scale * handles.tline.i_load(1:handles.plot_idx));
    % Add the load current marker to the load plot
    addpoints(h_i_load_marker, handles.tline.time(handles.plot_idx), current_scale * handles.tline.i_load(handles.plot_idx));
end

% Update the plots on all of the axes
drawnow;

% Set all of the edit boxs states to inactive
% By setting the edit boxes states to inactive, it will highlight the
% text in the edit box when the user clicks the edit box
% This function call has no effect on the plot, it is placed here to
% periodically ensure that all of the edit boxes are in the inactive
% state.
set_edit_boxes_inactive(handles);

end


%% Settings Figure File Menu Callbacks

% File => Save
function tline_settings_file_save_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% If no configuration file is loaded
if(isempty(handles.config_file))
    % Simulate pressing save as to prompt user to enter a filename
    tline_settings_file_save_as_callback(handles.tline_settings_file_save_as,0);
    % If a configuration file is loaded
else
    % If animation data is not up to date with current transmission line settings
    if(handles.recalc_needed == 1)
        set(handles.tline_settings_fig, 'pointer', 'watch');
        set(handles.animation_fig, 'pointer', 'watch');
        set(handles.animation_settings_fig, 'pointer', 'watch');
        set(handles.animation_slider_fig, 'pointer', 'watch');
        set(handles.source_select_fig, 'pointer', 'watch');
        set(handles.load_select_fig, 'pointer', 'watch');
        set(handles.legend_fig, 'pointer', 'watch');
        pause(0.01);
        % Update transmission line data
        handles.tline.update_props;
        set(handles.tline_settings_fig, 'pointer', 'arrow');
        set(handles.animation_fig, 'pointer', 'arrow');
        set(handles.animation_settings_fig, 'pointer', 'arrow');
        set(handles.animation_slider_fig, 'pointer', 'arrow');
        set(handles.source_select_fig, 'pointer', 'arrow');
        set(handles.load_select_fig, 'pointer', 'arrow');
        set(handles.legend_fig, 'pointer', 'arrow');
        handles.recalc_needed = 0;
    end
    % Overwrite the configuration file with the current configuration
    tline = handles.tline;
    animation_speed = get(handles.animation_speed,'UserData');
    v_across = get(handles.animation_settings_across_v,'UserData');
    v_f_across = get(handles.animation_settings_across_v_f,'UserData');
    v_b_across = get(handles.animation_settings_across_v_b,'UserData');
    v_env_across = get(handles.animation_settings_across_v_env,'UserData');
    i_across = get(handles.animation_settings_across_i,'UserData');
    i_f_across = get(handles.animation_settings_across_i_f,'UserData');
    i_b_across = get(handles.animation_settings_across_i_b,'UserData');
    i_env_across = get(handles.animation_settings_across_i_env,'UserData');
    v_near_end = get(handles.animation_settings_near_end_v,'UserData');
    i_near_end = get(handles.animation_settings_near_end_i,'UserData');
    v_far_end = get(handles.animation_settings_far_end_v,'UserData');
    i_far_end = get(handles.animation_settings_far_end_i,'UserData');
    current_scale = get(handles.animation_settings_current_scale,'UserData');
    precision = get(handles.animation_settings_precision,'UserData');
    simulation_note = handles.simulation_notes;
    save(handles.config_file,...
        'tline',...
        'animation_speed',...
        'v_across',...
        'v_f_across',...
        'v_b_across',...
        'v_env_across',...
        'i_across',...
        'i_f_across',...
        'i_b_across',...
        'i_env_across',...
        'v_near_end',...
        'i_near_end',...
        'v_far_end',...
        'i_far_end',...
        'current_scale',...
        'precision',...
        'simulation_note');
end

end

% File => Save As
function tline_settings_file_save_as_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set directory
directory = ['config_files', filesep, handles.tline.animation_type, filesep, handles.tline.src_config];

% Get all filenames in directory
files = dir([directory,filesep,'*.mat']);
filenames = {files.name};

% Loop through all of the filenames
for k = 1:length(filenames)
    % Remove the .mat from the filenames
    filenames{k} = filenames{k}(1:end-4);
end

while(1)
    % Get filename from user
    new_filename = inputdlg('Enter Filename:','Save As',[1 40]);
    
    % If no file was entered
    if(isempty(new_filename))
        % Exit function
        return;
    end
    
    % Flag that is set to 1 if filename that the user enters is already used
    file_already_exists = 0;
    
    % Loop through all the file names
    for k = 1:length(filenames)
        % If the file already exists
        if(strcmp(filenames{k},new_filename{1}))
            % Set flag
            file_already_exists = 1;
            % Exit for loop
            break;
        end
    end
    
    % If the file already exists
    if(file_already_exists)
        % Ask user if they want to overwrite the file
        overwrite = questdlg({[new_filename{1},' already exists.'],'Do you want to replace it?'},'Confirm Save As','Yes','No','No');
        % If user wants to overwrite the file
        if(strcmp(overwrite,'Yes'))
            % Exit the while loop
            break;
            % If user does not want to overwrite the file
        else
            % Start at the beginning of the loop again and reprompt the user
            continue
        end
    end
    
    % If the new filename not already used, exit the loop
    break;
end

% If animation data is not up to date with current transmission line settings
if(handles.recalc_needed == 1)
    set(handles.tline_settings_fig, 'pointer', 'watch');
    set(handles.animation_fig, 'pointer', 'watch');
    set(handles.animation_settings_fig, 'pointer', 'watch');
    set(handles.animation_slider_fig, 'pointer', 'watch');
    set(handles.source_select_fig, 'pointer', 'watch');
    set(handles.load_select_fig, 'pointer', 'watch');
    set(handles.legend_fig, 'pointer', 'watch');
    pause(0.01);
    % Update transmission line data
    handles.tline.update_props;
    set(handles.tline_settings_fig, 'pointer', 'arrow');
    set(handles.animation_fig, 'pointer', 'arrow');
    set(handles.animation_settings_fig, 'pointer', 'arrow');
    set(handles.animation_slider_fig, 'pointer', 'arrow');
    set(handles.source_select_fig, 'pointer', 'arrow');
    set(handles.load_select_fig, 'pointer', 'arrow');
    set(handles.legend_fig, 'pointer', 'arrow');
    handles.recalc_needed = 0;
end

% Save new configuration file
tline = handles.tline;
animation_speed = get(handles.animation_speed,'UserData');
v_across = get(handles.animation_settings_across_v,'UserData');
v_f_across = get(handles.animation_settings_across_v_f,'UserData');
v_b_across = get(handles.animation_settings_across_v_b,'UserData');
v_env_across = get(handles.animation_settings_across_v_env,'UserData');
i_across = get(handles.animation_settings_across_i,'UserData');
i_f_across = get(handles.animation_settings_across_i_f,'UserData');
i_b_across = get(handles.animation_settings_across_i_b,'UserData');
i_env_across = get(handles.animation_settings_across_i_env,'UserData');
v_near_end = get(handles.animation_settings_near_end_v,'UserData');
i_near_end = get(handles.animation_settings_near_end_i,'UserData');
v_far_end = get(handles.animation_settings_far_end_v,'UserData');
i_far_end = get(handles.animation_settings_far_end_i,'UserData');
current_scale = get(handles.animation_settings_current_scale,'UserData');
precision = get(handles.animation_settings_precision,'UserData');
simulation_note = handles.simulation_notes;
save([directory, filesep, new_filename{1}],...
    'tline',...
    'animation_speed',...
    'v_across',...
    'v_f_across',...
    'v_b_across',...
    'v_env_across',...
    'i_across',...
    'i_f_across',...
    'i_b_across',...
    'i_env_across',...
    'v_near_end',...
    'i_near_end',...
    'v_far_end',...
    'i_far_end',...
    'current_scale',...
    'precision',...
    'simulation_note');

% Set handles current configuration file to the new file
handles.config_file = [directory, filesep, new_filename{1},'.mat'];

% Save handles structures
save_handles(handles);

end

% File => Add Note
function tline_settings_file_add_note_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Get note from user
sim_note = inputdlg('Enter notes about this simulation:','Simulation Notes', [15 100],handles.simulation_notes);

% As long as the user did not click cancel or the close button
if(~isempty(sim_note))
    % Save the simulation note;
    handles.simulation_notes = sim_note;
    % Update the simulation note window
    set(handles.simulation_notes_text,'String',sim_note{1});
end

% Save handles structures
save_handles(handles);

end

% File => Print to File
function tline_settings_file_print_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Get filename and path from user
[file,path] = uiputfile('*.png','Save Transmission Line Settings Image');

% Take a snapshot of the figure
F = getframe(handles.tline_settings_fig);
% Convert the frame to an image
[X,~] = frame2im(F);
% Save the image
imwrite(X,[path,file]);

end

% File => Preconfigured Files => Transient => Step
function tline_settings_file_preconfig_transient_step_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set directory
directory = ['config_files',filesep,'transient',filesep,'step'];
% Get configuration file from user
filename = uigetfile(directory);
% If no file was entered
if(filename == 0)
    % Exit function
    return;
end
% Save configuration filepath
handles.config_file = [directory,filesep,filename];
% Load configuration file
load_configuration_file(handles);

end

% File => Preconfigured Files => Transient => Ramped Step
function tline_settings_file_preconfig_transient_ramped_step_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set directory
directory = ['config_files',filesep,'transient',filesep,'ramped_step'];
% Get configuration file from user
filename = uigetfile(directory);
% If no file was entered
if(filename == 0)
    % Exit function
    return;
end
% Save configuration filepath
handles.config_file = [directory,filesep,filename];
% Load configuration file
load_configuration_file(handles);

end

% File => Preconfigured Files => Transient => Sine
function tline_settings_file_preconfig_transient_sine_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set directory
directory = ['config_files',filesep,'transient',filesep,'sine'];
% Get configuration file from user
filename = uigetfile(directory);
% If no file was entered
if(filename == 0)
    % Exit function
    return;
end
% Save configuration filepath
handles.config_file = [directory,filesep,filename];
% Load configuration file
load_configuration_file(handles);

end

% File => Preconfigured Files => Steady State => Sine
function tline_settings_file_preconfig_steady_state_sine_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set directory
directory = ['config_files',filesep,'steady_state',filesep,'sine'];
% Get configuration file from user
filename = uigetfile(directory);
% If no file was entered
if(filename == 0)
    % Exit function
    return;
end
% Save configuration filepath
handles.config_file = [directory,filesep,filename];
% Load configuration file
load_configuration_file(handles);

end

% File => Close
function tline_settings_file_close_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Close the figure
tline_settings_fig_close_request_callback(handles.tline_settings_fig,0);

end

%% Create Transmission Line Settings Source Menu

% Source => Source Selection Panel
function tline_settings_source_panel_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility according to user selection in menu
set_figure_window_visibility(hObject,handles.source_select_fig);

% Save handles structures
save_handles(handles);

end

% Source => Step
function tline_settings_source_step_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Simulate pressing the step button in the source select menu
step_source_button_callback(handles.step_source_button,0);

% Set the step check mark and unselect the others
set_source_menu_check_marks(hObject);

% Set recalculation flag
handles.recalc_needed = 1;

% Save handles structures
save_handles(handles);

end

% Source => Ramped Step
function tline_settings_source_ramped_step_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Simulate pressing the ramped step button in the source select menu
ramped_step_source_button_callback(handles.ramped_step_source_button,0);

% Set the ramped step check mark and unselect the others
set_source_menu_check_marks(hObject);

% Set recalculation flag
handles.recalc_needed = 1;

% Save handles structures
save_handles(handles);

end

% Source => Sine
function tline_settings_source_sine_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Simulate pressing the sine button in the source select menu
sine_source_button_callback(handles.sine_source_button,0);

% Set the sine check mark and unselect the others
set_source_menu_check_marks(hObject);

% Set recalculation flag
handles.recalc_needed = 1;

% Save handles structures
save_handles(handles);

end


%% Create Transmission Line Settings Line Menu

% Line => Lossless
function tline_settings_line_lossless_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Line => Lossy
function tline_settings_line_lossy_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

%% Create Transmission Line Settings Load Menu

% Load => Load Selection Panel
function tline_settings_load_panel_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility according to user selection in menu
set_figure_window_visibility(hObject,handles.load_select_fig);

% Save handles structures
save_handles(handles);

end

% Load => R
function tline_settings_load_R_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Simulate pressing the R button in the load select menu
R_load_button_callback(handles.R_load_button,0);

% Set the R check mark and unselect the others
set_load_menu_check_marks(hObject);

end

% Load => L
function tline_settings_load_L_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Simulate pressing the L button in the load select menu
L_load_button_callback(handles.L_load_button,0);

% Set the L check mark and unselect the others
set_load_menu_check_marks(hObject);

end

% Load => C
function tline_settings_load_C_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Simulate pressing the C button in the load select menu
C_load_button_callback(handles.C_load_button,0);

% Set the C check mark and unselect the others
set_load_menu_check_marks(hObject);

end

% Load => R + L
function tline_settings_load_R_ser_L_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Simulate pressing the R+L button in the load select menu
R_ser_L_load_button_callback(handles.R_ser_L_load_button,0);

% Set the R+L check mark and unselect the others
set_load_menu_check_marks(hObject);

end

% Load => R + C
function tline_settings_load_R_ser_C_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Simulate pressing the R+C button in the load select menu
R_ser_C_load_button_callback(handles.R_ser_C_load_button,0);

% Set the R+C check mark and unselect the others
set_load_menu_check_marks(hObject);

end

% Load => R + L + C
function tline_settings_load_R_ser_L_ser_C_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Simulate pressing the R+L+C button in the load select menu
R_ser_L_ser_C_load_button_callback(handles.R_ser_L_ser_C_load_button,0);

% Set the R+L+C check mark and unselect the others
set_load_menu_check_marks(hObject);

end

% Load => R || L
function tline_settings_load_R_par_L_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Simulate pressing the R||L button in the load select menu
R_par_L_load_button_callback(handles.R_par_L_load_button,0);

% Set the R||L check mark and unselect the others
set_load_menu_check_marks(hObject);

end

% Load => R || C
function tline_settings_load_R_par_C_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Simulate pressing the R||C button in the load select menu
R_par_C_load_button_callback(handles.R_par_C_load_button,0);

% Set the R||C check mark and unselect the others
set_load_menu_check_marks(hObject);

end

% Load => R || L || C
function tline_settings_load_R_par_L_par_C_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Simulate pressing the R||L||C button in the load select menu
R_par_L_par_C_load_button_callback(handles.R_par_L_par_C_load_button,0);

% Set the R||L||C check mark and unselect the others
set_load_menu_check_marks(hObject);

end


%% Create Transmission Line Settings Animation Menu

% Animation => Transient
function tline_settings_animation_transient_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set transient check mark state to on for the animation menu
set(hObject,'UserData',1);
% Turn transient check mark on in the animation menu
set(hObject,'Checked','on');
% Set steady state check mark state to off for the animation menu
set(handles.tline_settings_animation_steady_state,'UserData',0);
% Turn steady state check mark off in the animation menu
set(handles.tline_settings_animation_steady_state,'Checked','off');

% Make characteristic impedance edit box visible
set(handles.z0,'Visible','on');
% Make relative permittivity edit box visible
set(handles.epsilon_r,'Visible','on');
% Make propagation delay edit box visible
set(handles.td,'Visible','on');
% Make source rise time edit box visible
set(handles.tr,'Visible','off');
% Make source frequency edit box visible
set(handles.freq,'Visible','off');
% Make inductance per meter edit box invisible
set(handles.L,'Visible','off');
% Make capacitance per meter edit box invisible
set(handles.C,'Visible','off');
% Make resistance per meter edit box invisible
set(handles.R,'Visible','off');
% Make conductance per meter edit box invisible
set(handles.G,'Visible','off');
% Make line length edit box invisible
set(handles.line_length,'Visible','off');

% Convert transmission line from transient to steady state
% Make a steady state transmission line object
tline_trans = transient_tline;
% Copy over applicable transient parameters from the current model
tline_trans.rl = handles.tline.rl;
tline_trans.ll = handles.tline.ll;
tline_trans.cl = handles.tline.cl;
tline_trans.zs = handles.tline.zs;
tline_trans.vs_amp = handles.tline.vs_amp;
% Save the new transient transmission line
handles.tline = tline_trans;

% Save handles structures
save_handles(handles);

% Enable step source options
% Enable step option in the source menu
set(handles.tline_settings_source_step,'Enable','on');
% Enable step source button
set(handles.step_source_button,'Enable','on');

% Enable ramped step source options
% Enable ramped step option in the source menu
set(handles.tline_settings_source_ramped_step,'Enable','on');
% Enable ramped step source button
set(handles.ramped_step_source_button,'Enable','on');

% Disable the plot envelope option and uncheck it in the menu
set(handles.animation_settings_across_v_env,'UserData',0);
set(handles.animation_settings_across_i_env,'UserData',0);
set(handles.animation_settings_across_v_env,'Checked','off');
set(handles.animation_settings_across_i_env,'Checked','off');
set(handles.animation_settings_across_v_env,'Enable','off');
set(handles.animation_settings_across_i_env,'Enable','off');

% Simulate pressing the step source button
step_source_button_callback(handles.step_source_button,0);

% If the transmission line is lossless
if(strcmp(handles.tline.tline_config,'lossless'))
    % Change transmission line settings text to either lossless
    set(handles.tline_settings_text,'String','Lossless Transmission Line Settings');
    % Set lossless check mark state to on for the line menu
    set(handles.tline_settings_line_lossless,'UserData',1);
    % Turn lossless check mark on in the line menu
    set(handles.tline_settings_line_lossless,'Checked','on');
    % Enable lossless option in the line menu
    set(handles.tline_settings_line_lossless,'Enable','on');
    % Set lossy check mark state to off for the line menu
    set(handles.tline_settings_line_lossy,'UserData',0);
    % Turn lossy check mark off in the line menu
    set(handles.tline_settings_line_lossy,'Checked','off');
    % Disable lossy option in the line menu
    set(handles.tline_settings_line_lossy,'Enable','off');
    % If the transmission line is lossy
else
    % Change transmission line settings text to either lossless
    set(handles.tline_settings_text,'String','Lossy Transmission Line Settings');
    % Set lossy check mark state to on for the line menu
    set(handles.tline_settings_line_lossy,'UserData',1);
    % Turn lossy check mark on in the line menu
    set(handles.tline_settings_line_lossy,'Checked','on');
    % Enable lossy option in the line menu
    set(handles.tline_settings_line_lossy,'Enable','on');
    % Set lossless check mark state to off for the line menu
    set(handles.tline_settings_line_lossless,'UserData',0);
    % Turn lossless check mark off in the line menu
    set(handles.tline_settings_line_lossless,'Checked','off');
    % Disable lossless option in the line menu
    set(handles.tline_settings_line_lossless,'Enable','off');
end

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

% Update all edit boxes in GUI and set sources and loads
update_gui(handles);

end

% Animation => Steady State
function tline_settings_animation_steady_state_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set steady state check mark state to on for the animation menu
set(hObject,'UserData',1);
% Turn steady state check mark on in the animation menu
set(hObject,'Checked','on');
% Set transient check mark state to off for the animation menu
set(handles.tline_settings_animation_transient,'UserData',0);
% Turn transient check mark off in the animation menu
set(handles.tline_settings_animation_transient,'Checked','off');

% Make inductance per meter edit box visible
set(handles.L,'Visible','on');
% Make capacitance per meter edit box visible
set(handles.C,'Visible','on');
% Make resistance per meter edit box visible
set(handles.R,'Visible','on');
% Make conductance per meter edit box visible
set(handles.G,'Visible','on');
% Make line length edit box visible
set(handles.line_length,'Visible','on');
% Make characteristic impedance edit box invisible
set(handles.z0,'Visible','off');
% Make relative permittivity edit box invisible
set(handles.epsilon_r,'Visible','off');
% Make propagation delay edit box invisible
set(handles.td,'Visible','off');
% Make source rise time edit box invisible
set(handles.tr,'Visible','off');

% Convert transmission line from transient to steady state
% Make a steady state transmission line object
tline_ss = steady_state_tline;
% Copy over applicable transient parameters from the current model
tline_ss.rl = handles.tline.rl;
tline_ss.ll = handles.tline.ll;
tline_ss.cl = handles.tline.cl;
tline_ss.zs = handles.tline.zs;
tline_ss.vs_amp = handles.tline.vs_amp;

% Save the new steady state transmission line
handles.tline = tline_ss;

% Save handles structures
save_handles(handles);

% Disable step option in the source menu
set(handles.tline_settings_source_step,'Enable','off');
% Disable step source button
set(handles.step_source_button,'Enable','off');

% Disable ramped step option in the source menu
set(handles.tline_settings_source_ramped_step,'Enable','off');
% Disable ramped step source button
set(handles.ramped_step_source_button,'Enable','off');

% Enable the plot envelope option
set(handles.animation_settings_across_v_env,'Enable','on');
set(handles.animation_settings_across_i_env,'Enable','on');

% Simulate pressing the sine source button
sine_source_button_callback(handles.sine_source_button,0);

% If the transmission line is lossless
if(strcmp(handles.tline.tline_config,'lossless'))
    % Change transmission line settings text to either lossless
    set(handles.tline_settings_text,'String','Lossless Transmission Line Settings');
    % Set lossless check mark state to on for the line menu
    set(handles.tline_settings_line_lossless,'UserData',1);
    % Turn lossless check mark on in the line menu
    set(handles.tline_settings_line_lossless,'Checked','on');
    % Enable lossless option in the line menu
    set(handles.tline_settings_line_lossless,'Enable','on');
    % Set lossy check mark state to off for the line menu
    set(handles.tline_settings_line_lossy,'UserData',0);
    % Turn lossy check mark off in the line menu
    set(handles.tline_settings_line_lossy,'Checked','off');
    % Disable lossy option in the line menu
    set(handles.tline_settings_line_lossy,'Enable','off');
    % If the transmission line is lossy
else
    % Change transmission line settings text to either lossless
    set(handles.tline_settings_text,'String','Lossy Transmission Line Settings');
    % Set lossy check mark state to on for the line menu
    set(handles.tline_settings_line_lossy,'UserData',1);
    % Turn lossy check mark on in the line menu
    set(handles.tline_settings_line_lossy,'Checked','on');
    % Enable lossy option in the line menu
    set(handles.tline_settings_line_lossy,'Enable','on');
    % Set lossless check mark state to off for the line menu
    set(handles.tline_settings_line_lossless,'UserData',0);
    % Turn lossless check mark off in the line menu
    set(handles.tline_settings_line_lossless,'Checked','off');
    % Disable lossless option in the line menu
    set(handles.tline_settings_line_lossless,'Enable','off');
end

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

% Update all edit boxes in GUI and set sources and loads
update_gui(handles);

end

% Animation => Animation Settings
function tline_settings_animation_settings_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility according to user selection in menu
set_figure_window_visibility(hObject,handles.animation_settings_fig);

% Save handles structures
save_handles(handles);

end

% Animation => Animation Slider
function tline_settings_animation_slider_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility according to user selection in menu
set_figure_window_visibility(hObject,handles.animation_slider_fig);

% Save handles structures
save_handles(handles);


end

%% Create Transmission Line Settings Help Menu Callbacks

% Help => Show Calculations
function tline_settings_help_calculations_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility according to user selection in menu
set_figure_window_visibility(hObject,handles.calculations_fig);

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Help => Simulation Notes
function tline_settings_help_notes_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Update simulation notes text
set(handles.simulation_notes_text,'String',handles.simulation_notes{1});

% Set figure window visibility according to user selection in menu
set_figure_window_visibility(hObject,handles.simulation_notes_fig);

% Save handles structures
save_handles(handles);

end


%% Animation Figure File Menu Callbacks

% File => Print to File => Top
function animation_file_print_top_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Get filename and path from user
[file,path] = uiputfile('*.png','Save Plot Image');

% Get animation figure dimensions
dimensions = get(handles.animation_fig,'Position');
% Get screen size
screen_size = get(0,'ScreenSize');
% Figure size in pixels
fig_pixels = dimensions .* screen_size;
% Figure width in pixels
fig_width = fig_pixels(3);
% Figure height in pixels
fig_height = fig_pixels(4);
% Border width of the figure
border = 10;

% Take a snapshot of the figure
F = getframe(handles.animation_fig,[border, round(2/3*(fig_height-2*border)), fig_width-2*border, round(1/3*(fig_height-2*border))]);
% Convert the frame to an image
[X,~] = frame2im(F);
% Save the image
imwrite(X,[path,file]);

end

% File => Print to File => Middle
function animation_file_print_middle_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Get filename and path from user
[file,path] = uiputfile('*.png','Save Plot Image');

% Get animation figure dimensions
dimensions = get(handles.animation_fig,'Position');
% Get screen size
screen_size = get(0,'ScreenSize');
% Figure size in pixels
fig_pixels = dimensions .* screen_size;
% Figure width in pixels
fig_width = fig_pixels(3);
% Figure height in pixels
fig_height = fig_pixels(4);
% Border width of the figure
border = 10;

% Take a snapshot of the figure
F = getframe(handles.animation_fig,[border, round(1/3*fig_height+border), fig_width-2*border, round(1/3*(fig_height-2*border))]);
% Convert the frame to an image
[X,~] = frame2im(F);
% Save the image
imwrite(X,[path,file]);

end

% File => Print to File => Bottom
function animation_file_print_bottom_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Get filename and path from user
[file,path] = uiputfile('*.png','Save Plot Image');

% Get animation figure dimensions
dimensions = get(handles.animation_fig,'Position');
% Get screen size
screen_size = get(0,'ScreenSize');
% Figure size in pixels
fig_pixels = dimensions .* screen_size;
% Figure width in pixels
fig_width = fig_pixels(3);
% Figure height in pixels
fig_height = fig_pixels(4);
% Border width of the figure
border = 10;

% Take a snapshot of the figure
F = getframe(handles.animation_fig,[border, 2*border, fig_width-2*border, round(1/3*(fig_height-2*border))]);
% Convert the frame to an image
[X,~] = frame2im(F);
% Save the image
imwrite(X,[path,file]);

end

% File => Print to File => All
function animation_file_print_all_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Get filename and path from user
[file,path] = uiputfile('*.png','Save Plot Image');

% Get animation figure dimensions
dimensions = get(handles.animation_fig,'Position');
% Get screen size
screen_size = get(0,'ScreenSize');
% Figure size in pixels
fig_pixels = dimensions .* screen_size;
% Figure width in pixels
fig_width = fig_pixels(3);
% Figure height in pixels
fig_height = fig_pixels(4);
% Border width of the figure
border = 10;

% Take a snapshot of the figure
F = getframe(handles.animation_fig,[border, border, round(fig_width-2*border), round(fig_height-2*border)]);
% Convert the frame to an image
[X,~] = frame2im(F);
% Save the image
imwrite(X,[path,file]);

end

%% Animation Figure Settings Menu Callbacks

% Animation => Settings => Across => V
function animation_settings_across_v_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Toggle check mark
toggle_menu_check_mark(hObject);
% Update axes names
update_axes_names(hObject);

% As long is there is at least one thing to plot
if((get(handles.animation_settings_across_v,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_env,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_env,'UserData') == 1))
    
    % Plot data
    plot_tline_data(handles);
end

% Save handles structures
save_handles(handles);
end

% Animation => Settings => Across => V_f
function animation_settings_across_v_f_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Toggle check mark
toggle_menu_check_mark(hObject);
% Update axes names
update_axes_names(hObject);

% As long is there is at least one thing to plot
if((get(handles.animation_settings_across_v,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_env,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_env,'UserData') == 1))
    
    % Plot data
    plot_tline_data(handles);
end

% Save handles structures
save_handles(handles);
end

% Animation => Settings => Across => V_b
function animation_settings_across_v_b_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Toggle check mark
toggle_menu_check_mark(hObject);
% Update axes names
update_axes_names(hObject);

% As long is there is at least one thing to plot
if((get(handles.animation_settings_across_v,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_env,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_env,'UserData') == 1))
    
    % Plot data
    plot_tline_data(handles);
end

% Save handles structures
save_handles(handles);
end

% Animation => Settings => Across => V_env
function animation_settings_across_v_env_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Toggle check mark
toggle_menu_check_mark(hObject);
% Update axes names
update_axes_names(hObject);

% As long is there is at least one thing to plot
if((get(handles.animation_settings_across_v,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_env,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_env,'UserData') == 1))
    
    % Plot data
    plot_tline_data(handles);
end

% Save handles structures
save_handles(handles);
end

% Animation => Settings => Across => I
function animation_settings_across_i_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Toggle check mark
toggle_menu_check_mark(hObject);
% Update axes names
update_axes_names(hObject);

% As long is there is at least one thing to plot
if((get(handles.animation_settings_across_v,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_env,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_env,'UserData') == 1))
    
    % Plot data
    plot_tline_data(handles);
end

% Save handles structures
save_handles(handles);
end

% Animation => Settings => Across => I_f
function animation_settings_across_i_f_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Toggle check mark
toggle_menu_check_mark(hObject);
% Update axes names
update_axes_names(hObject);

% As long is there is at least one thing to plot
if((get(handles.animation_settings_across_v,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_env,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_env,'UserData') == 1))
    
    % Plot data
    plot_tline_data(handles);
end

% Save handles structures
save_handles(handles);
end

% Animation => Settings => Across => I_b
function animation_settings_across_i_b_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Toggle check mark
toggle_menu_check_mark(hObject);
% Update axes names
update_axes_names(hObject);

% As long is there is at least one thing to plot
if((get(handles.animation_settings_across_v,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_env,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_env,'UserData') == 1))
    
    % Plot data
    plot_tline_data(handles);
end

% Save handles structures
save_handles(handles);
end

% Animation => Settings => Across => I_env
function animation_settings_across_i_env_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Toggle check mark
toggle_menu_check_mark(hObject);
% Update axes names
update_axes_names(hObject);

% As long is there is at least one thing to plot
if((get(handles.animation_settings_across_v,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_v_env,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_f,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_b,'UserData') == 1) ||...
        (get(handles.animation_settings_across_i_env,'UserData') == 1))
    
    % Plot data
    plot_tline_data(handles);
end

% Save handles structures
save_handles(handles);
end

% Animation => Settings => Near End => V
function animation_settings_near_end_v_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Toggle check mark
toggle_menu_check_mark(hObject);
% Update axes names
update_axes_names(hObject);

% As long is there is at least one thing to plot
if((get(handles.animation_settings_near_end_v,'UserData') == 1) ||...
        (get(handles.animation_settings_near_end_i,'UserData') == 1))
    % Plot data
    plot_tline_data(handles);
end

% Save handles structures
save_handles(handles);

end

% Animation => Settings => Near End => I
function animation_settings_near_end_i_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Toggle check mark
toggle_menu_check_mark(hObject);
% Update axes names
update_axes_names(hObject);

% As long is there is at least one thing to plot
if((get(handles.animation_settings_near_end_v,'UserData') == 1) ||...
        (get(handles.animation_settings_near_end_i,'UserData') == 1))
    % Plot data
    plot_tline_data(handles);
end

% Save handles structures
save_handles(handles);

end

% Animation => Settings => Far End => V
function animation_settings_far_end_v_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Toggle check mark
toggle_menu_check_mark(hObject);
% Update axes names
update_axes_names(hObject);

% As long is there is at least one thing to plot
if((get(handles.animation_settings_far_end_v,'UserData') == 1) ||...
        (get(handles.animation_settings_far_end_i,'UserData') == 1))
    % Plot data
    plot_tline_data(handles);
end

% Save handles structures
save_handles(handles);

end

% Animation => Settings => Far End => I
function animation_settings_far_end_i_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Toggle check mark
toggle_menu_check_mark(hObject);
% Update axes names
update_axes_names(hObject);

% As long is there is at least one thing to plot
if((get(handles.animation_settings_far_end_v,'UserData') == 1) ||...
        (get(handles.animation_settings_far_end_i,'UserData') == 1))
    % Plot data
    plot_tline_data(handles);
end

% Save handles structures
save_handles(handles);

end

% Animation => Settings => Update Current Scale
function animation_settings_current_scale_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Get previous current scale to autofill input dialog
prev_current_scale = get(hObject,'UserData');

% Get new current scale from user
current_scale_cell = inputdlg('Enter Current Scale:',...
    'Current Scale',...
    [1 30],...
    {num2str(prev_current_scale)});

% As long as user entered something and it is a number
if(~isempty(current_scale_cell) && ~isnan(str2double(current_scale_cell{1})))
    % Update the current scale
    set(hObject,'UserData',str2double(current_scale_cell{1}));
    % Set current scale string in legend
    set(handles.current_scale_text,'String',['Current Scale: ',current_scale_cell{1}]);
end



% Save handles structures
save_handles(handles);

end

% Animation => Settings => Update Plot Precision
function animation_settings_precision_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Get previous precision to autofill input dialog
prev_precision = get(hObject,'UserData');

% Get new plot precision from user
precision_cell = inputdlg('Enter Plot Precision:',...
    'Plot Precision',...
    [1 30],...
    {num2str(prev_precision)});

% As long as user entered something and it is a number
if(~isempty(precision_cell) && ~isnan(str2double(precision_cell{1})))
    % Update the current scale
    set(hObject,'UserData',round(str2double(precision_cell{1})));
    handles.tline.precision = round(str2double(precision_cell{1}));
    handles.recalc_needed = 1;
end

% Save handles structures
save_handles(handles);

end

% Animation => Help => Legend
function animation_help_legend_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility according to user selection in menu
set_figure_window_visibility(hObject,handles.legend_fig);

% Save handles structures
save_handles(handles);

end


%% Animation Settings Panel Object Callbacks

% Animation Speed Edit Box Callback
function animation_speed_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
end

% Adjust animation slider step value
slider_step = get(handles.animation_speed,'UserData')/handles.tline.num_pts;
set(handles.animation_slider,'SliderStep',[slider_step slider_step]);

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Save handles structures
save_handles(handles);

end

% Animation Speed Edit Box Button Down Callback
function animation_speed_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Animation Speed Edit Box Key Press Callback
function animation_speed_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Stop Time Edit Box Callback
function ts_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % If the stop time is 0 or negative
    if(str2double(get(hObject,'String')) <= 0)
        % Alert the user that ts must be at least 0
        msgbox('Stop time must be greater than 0')
        % Set the editbox back to the previous value
        set(hObject,'String',num2str(hObject.UserData));
        % If the stop time is valid
    else
        % Set the user data to that number
        set(hObject,'UserData',str2double(get(hObject,'String')));
    end
end

% Set transmission line parameter
handles.tline.ts = str2double(get(hObject,'String'));

% Set animation sliders max time
set(handles.animation_slider,'Max',handles.tline.ts);

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Save handles structures
save_handles(handles);

end

% Stop Time Edit Box Button Down Callback
function ts_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Stop Time Edit Box Key Press Callback
function ts_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end


%% Load Selection Panel Object Callbacks

% Resistor Load Button Callback
function R_load_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set the load button image and button state to selected
set_load_button(hObject);

% Set checkmark in the dropdown menu
set_load_menu_check_marks(handles.tline_settings_load_R);

% Update transmission line load configuration
handles.tline.load_config = 'R';

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Move load resistor edit box to the correct position
set(handles.rl,'Position',[660 116 50 20]);
% Make load resistor edit box visible
set(handles.rl,'Visible','on');
% Make load inductor edit box invisible
set(handles.ll,'Visible','off');
% Make load capacitor edit box invisible
set(handles.cl,'Visible','off');

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Inductor Load Button Callback
function L_load_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set the load button image and button state to selected
set_load_button(hObject);

% Set checkmark in the dropdown menu
set_load_menu_check_marks(handles.tline_settings_load_L);

% Update transmission line load configuration
handles.tline.load_config = 'L';

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Move load inductor edit box to the correct position
set(handles.ll,'Position',[660 116 50 20]);
% Make load inductor edit box visible
set(handles.ll,'Visible','on');
% Make load resistor edit box invisible
set(handles.rl,'Visible','off');
% Make load capacitor edit box invisible
set(handles.cl,'Visible','off');

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Capacitor Load Button Callback
function C_load_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set the load button image and button state to selected
set_load_button(hObject);

% Set checkmark in the dropdown menu
set_load_menu_check_marks(handles.tline_settings_load_C);

% Update transmission line load configuration
handles.tline.load_config = 'C';

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Move load capacitor edit box to the correct position
set(handles.cl,'Position',[660 116 50 20]);
% Make load capacitor edit box visible
set(handles.cl,'Visible','on');
% Make load resistor edit box invisible
set(handles.rl,'Visible','off');
% Make load inductor edit box invisible
set(handles.ll,'Visible','off');

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Resistor in Series with Inductor Load Button Callback
function R_ser_L_load_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set the load button image and button state to selected
set_load_button(hObject);

% Set checkmark in the dropdown menu
set_load_menu_check_marks(handles.tline_settings_load_R_ser_L);

% Update transmission line load configuration
handles.tline.load_config = 'R_ser_L';

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Move load resistor edit box to the correct position
set(handles.rl,'Position',[660 149 50 20]);
% Make load resistor edit box visible
set(handles.rl,'Visible','on');
% Move load inductor edit box to the correct position
set(handles.ll,'Position',[660 104 50 20]);
% Make load inductor edit box visible
set(handles.ll,'Visible','on');
% Make load capacitor edit box invisible
set(handles.cl,'Visible','off');

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Resistor in Series with Capacitor Load Button Callback
function R_ser_C_load_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set the load button image and button state to selected
set_load_button(hObject);

% Set checkmark in the dropdown menu
set_load_menu_check_marks(handles.tline_settings_load_R_ser_C);

% Update transmission line load configuration
handles.tline.load_config = 'R_ser_C';

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Move load resistor edit box to the correct position
set(handles.rl,'Position',[660 149 50 20]);
% Make load resistor edit box visible
set(handles.rl,'Visible','on');
% Move load capacitor edit box to the correct position
set(handles.cl,'Position',[660 104 50 20]);
% Make load capacitor edit box visible
set(handles.cl,'Visible','on');
% Make load inductor edit box invisible
set(handles.ll,'Visible','off');

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Inductor in Series with Capacitor Load Button Callback
function R_ser_L_ser_C_load_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set the load button image and button state to selected
set_load_button(hObject);

% Set checkmark in the dropdown menu
set_load_menu_check_marks(handles.tline_settings_load_R_ser_L_ser_C);

% Update transmission line load configuration
handles.tline.load_config = 'R_ser_L_ser_C';

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Move load resistor edit box to the correct position
set(handles.rl,'Position',[660 175 50 20]);
% Make load resistor edit box visible
set(handles.rl,'Visible','on');
% Move load inductor edit box to the correct position
set(handles.ll,'Position',[660 130 50 20]);
% Make load inductor edit box visible
set(handles.ll,'Visible','on');
% Move load capacitor edit box to the correct position
set(handles.cl,'Position',[660 85 50 20]);
% Make load capacitor edit box visible
set(handles.cl,'Visible','on');

% Set load resistance to equal z0
set(handles.zs,'String',get(handles.z0,'String'));
set(handles.zs,'UserData',get(handles.z0,'UserData'));
handles.tline.zs = handles.tline.z0;

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Resistor in Parallel with Inductor Load Button Callback
function R_par_L_load_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set the load button image and button state to selected
set_load_button(hObject);

% Set checkmark in the dropdown menu
set_load_menu_check_marks(handles.tline_settings_load_R_par_L);

% Update transmission line load configuration
handles.tline.load_config = 'R_par_L';

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Move load resistor edit box to the correct position
set(handles.rl,'Position',[616 113 50 20]);
% Make load resistor edit box visible
set(handles.rl,'Visible','on');
% Move load inductor edit box to the correct position
set(handles.ll,'Position',[687 113 50 20]);
% Make load inductor edit box visible
set(handles.ll,'Visible','on');
% Make load capacitor edit box invisible
set(handles.cl,'Visible','off');

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Resistor in Parallel with Capacitor Load Button Callback
function R_par_C_load_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set the load button image and button state to selected
set_load_button(hObject);

% Set checkmark in the dropdown menu
set_load_menu_check_marks(handles.tline_settings_load_R_par_C);

% Update transmission line load configuration
handles.tline.load_config = 'R_par_C';

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Move load resistor edit box to the correct position
set(handles.rl,'Position',[613 113 50 20]);
% Make load resistor edit box visible
set(handles.rl,'Visible','on');
% Move load capacitor edit box to the correct position
set(handles.cl,'Position',[693 113 50 20]);
% Make load capacitor edit box visible
set(handles.cl,'Visible','on');
% Make load inductor edit box invisible
set(handles.ll,'Visible','off');

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Inductor in Parallel with Capacitor Load Button Callback
function R_par_L_par_C_load_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set the load button image and button state to selected
set_load_button(hObject);

% Set checkmark in the dropdown menu
set_load_menu_check_marks(handles.tline_settings_load_R_par_L_par_C);

% Update transmission line load configuration
handles.tline.load_config = 'R_par_L_par_C';

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Move load resistor edit box to the correct position
set(handles.rl,'Position',[577 113 50 20]);
% Make load resistor edit box visible
set(handles.rl,'Visible','on');
% Move load inductor edit box to the correct position
set(handles.ll,'Position',[650 113 50 20]);
% Make load inductor edit box visible
set(handles.ll,'Visible','on');
% Move load capacitor edit box to the correct position
set(handles.cl,'Position',[732 113 50 20]);
% Make load capacitor edit box visible
set(handles.cl,'Visible','on');


% Set load resistance to equal z0
set(handles.zs,'String',get(handles.z0,'String'));
set(handles.zs,'UserData',get(handles.z0,'UserData'));
handles.tline.zs = handles.tline.z0;

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

%% Source Selection Panel Object Callbacks

% Step Source Button Callback
function step_source_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set the source button image and button state to selected
set_source_button(hObject);

% Set checkmark in the dropdown menu
set_source_menu_check_marks(handles.tline_settings_source_step);

% Update transmission line source configuration
handles.tline.src_config = 'step';

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Move source amplitude edit box to the correct position
set(handles.vs_amp,'Position',[41 135 50 20]);
% Make the source rise time edit box invisible
set(handles.tr,'Visible','off');
% Make the source frequency edit box invisible
set(handles.freq,'Visible','off');

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Ramped Step Source Button Callback
function ramped_step_source_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set the source button image and button state to selected
set_source_button(hObject);

% Set checkmark in the dropdown menu
set_source_menu_check_marks(handles.tline_settings_source_ramped_step);

% Update transmission line source configuration
handles.tline.src_config = 'ramped_step';

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Move source amplitude edit box to the correct position
set(handles.vs_amp,'Position',[41 160 50 20]);
% Make the source rise time edit box visible
set(handles.tr,'Visible','on');
% Move source rise time edit box to the correct position
set(handles.tr,'Position',[41 109 50 20]);
% Make the source frequency edit box invisible
set(handles.freq,'Visible','off');

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Sine Source Button Callback
function sine_source_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set the source button image and button state to selected
set_source_button(hObject);

% Set checkmark in the dropdown menu
set_source_menu_check_marks(handles.tline_settings_source_sine);

% Update transmission line source configuration
handles.tline.src_config = 'sine';

% Update transmission line image
axes(handles.tline_image_ax)
imshow(['images',filesep,handles.tline.animation_type,'_',handles.tline.src_config,'_',handles.tline.tline_config,'_',handles.tline.load_config,'.jpg']);

% Move source amplitude edit box to the correct position
set(handles.vs_amp,'Position',[41 160 50 20]);
% Make the source frequency edit box visible
set(handles.freq,'Visible','on');
% Move source frequency edit box to the correct position
set(handles.freq,'Position',[41 112 50 20]);
% Make the source rise time edit box invisible
set(handles.tr,'Visible','off');

% Set recalculation flag
handles.recalc_needed = 1;

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end


%% Transmission Line Settings Panel Callback Objects

% Source Amplitude Edit Box Callback
function vs_amp_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.vs_amp = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Save handles structures
save_handles(handles);

end

% Source Amplitude Edit Box Button Down Callback
function vs_amp_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Source Amplitude Edit Box Key Press Callback
function vs_amp_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Source Rise Time Edit Box Callback
function tr_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.tr = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Save handles structures
save_handles(handles);

end

% Source Rise Time Edit Box Button Down Callback
function tr_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Source Rise Time Edit Box Key Press Callback
function tr_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Source Frequency Edit Box Callback
function freq_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.freq = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Source Frequency Edit Box Button Down Callback
function freq_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Source Frequency Edit Box Key Press Callback
function freq_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Source Impedance Edit Box Callback
function zs_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % If transmission line load is a resistor, inductor and a
    % capacitror in series or in parallel and a transient transmission
    % line is being used
    if(strcmp(handles.tline.load_config,'R_ser_L_ser_C') ||...
            strcmp(handles.tline.load_config,'R_par_L_par_C') && ...
            strcmp(handles.tline.animation_type,'transient'))
        % Alert the user that the source impedance and the
        % characteristic impedance must be matched with this load configuration
        msgbox('The source impedance must match the characteristic impedance with this load');
        % Set the source resistance to match the characteristic impedance
        set(hObject,'UserData',get(handles.z0,'UserData'));
        % Set the source resistance to match the characteristic impedance
        set(hObject,'String',get(handles.z0,'String'));
    else
        % Set the user data to that number
        set(hObject,'UserData',str2double(get(hObject,'String')));
        % Convert edit box value to scientific notation if necessary
        if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
            set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
        end
    end
end

% Set transmission line parameter
handles.tline.zs = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Source Impedance Edit Box Button Down Callback
function zs_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Source Impedance Edit Box Key Press Callback
function zs_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Characteristic Impedance Edit Box Callback
function z0_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % If transmission line load is a resistor, inductor and a
    % capacitror in series or in parallel and a transient transmission
    % line is being used
    if(strcmp(handles.tline.load_config,'R_ser_L_ser_C') ||...
            strcmp(handles.tline.load_config,'R_par_L_par_C') && ...
            strcmp(handles.tline.animation_type,'transient'))
        % Set the characteristic impedance to that number
        set(hObject,'UserData',str2double(get(hObject,'String')));
        % Alert the user that the source impedance is being updated to
        % match the characteristic impedance
        msgbox('The source impedance was updated to match the characteristic impedance');
        % Set the source resistance to match the characteristic impedance
        set(handles.zs,'UserData',get(handles.z0,'UserData'));
        % Set the source resistance to match the characteristic impedance
        set(handles.zs,'String',get(handles.z0,'String'));
        % Set source resistance transmission line parameter
        handles.tline.zs = get(handles.z0,'UserData');
    else
        % Set the user data to that number
        set(hObject,'UserData',str2double(get(hObject,'String')));
        % Convert edit box value to scientific notation if necessary
        if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
            set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
        end
    end
end

% Set transmission line parameter
handles.tline.z0 = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Characteristic Impedance Edit Box Button Down Callback
function z0_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Characteristic Impedance Edit Box Key Press Callback
function z0_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Relative Permittivity Edit Box Callback
function epsilon_r_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.epsilon_r = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Relative Permittivity Edit Box Button Down Callback
function epsilon_r_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Relative Permittivity Edit Box Key Press Callback
function epsilon_r_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Time Delay of Transmission Line Edit Box Callback
function td_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.td = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set animation sliders max time
set(handles.animation_slider,'Max',handles.tline.ts);

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Time Delay of Transmission Line Edit Box Button Down Callback
function td_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Time Delay of Transmission Line Edit Box Key Press Callback
function td_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Load Resistance Edit Box Callback
function rl_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.rl = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Load Resistance Edit Box Button Down Callback
function rl_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Load Resistance Edit Box Key Press Callback
function rl_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Load Impedance Edit Box Callback
function ll_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.ll = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Load Impedance Edit Box Button Down Callback
function ll_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Load Impedance Edit Box Key Press Callback
function ll_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Load Capacitance Edit Box Callback
function cl_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.cl = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Load Capacitance Edit Box Button Down Callback
function cl_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Load Capacitance Edit Box Key Press Callback
function cl_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Transmission Line Inductance per Unit Length Edit Box Callback
function L_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.L = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Transmission Line Inductance per Unit Length Edit Box Button Down Callback
function L_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Transmission Line Inductance per Unit Length Edit Box Key Press Callback
function L_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Transmission Line Capacitance per Unit Length Edit Box Callback
function C_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.C = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Transmission Line Capacitance per Unit Length Edit Box Button Down Callback
function C_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structure
guidata(hObject,handles);

end

% Transmission Line Capacitance per Unit Length Edit Box Key Press Callback
function C_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Transmission Line Resistance per Unit Length Edit Box Callback
function R_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.R = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Transmission Line Resistance per Unit Length Edit Box Button Down Callback
function R_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Transmission Line Resistance per Unit Length Edit Box Key Press Callback
function R_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Transmission Line Conductance per Unit Length Edit Box Callback
function G_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.G = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Transmission Line Conductance per Unit Length Edit Box Button Down Callback
function G_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Transmission Line Conductance per Unit Length Edit Box Key Press Callback
function G_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end

% Transmission Line Length Edit Box Callback
function line_length_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Convert any prefixes to numbers
set(hObject,'String', prefix2num(get(hObject,'String')));

% If something other than a number is entered
if(isnan(str2double(hObject.String)))
    % Set the editbox back to the previous value
    set(hObject,'String',num2str(hObject.UserData));
    % If a number is entered
else
    % Set the user data to that number
    set(hObject,'UserData',str2double(get(hObject,'String')));
    % Convert edit box value to scientific notation if necessary
    if(get(hObject,'UserData') >= 10000 || get(hObject,'UserData') <= .9999)
        set(hObject,'String',num2str(get(hObject,'UserData'),'%.3g'));
    end
end

% Set transmission line parameter
handles.tline.line_length = str2double(get(hObject,'String'));

% Set recalculation flag
handles.recalc_needed = 1;

% Set the editbox state to inactive. This makes it so when the user
% presses somewhere on the editbox, the KeyPressFcn callback will be
% called.
set(hObject,'Enable','inactive');

% Generate Calculations
generate_calculations_window(handles);

% Save handles structures
save_handles(handles);

end

% Transmission Line Length Edit Box Button Down Callback
function line_length_buttondown_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Allow user to enter a value into the edit box
set(hObject,'Enable','on');
% Save the previous value in the edit box in UserData
set(hObject,'UserData',str2double(get(hObject,'String')));
% Highlight the edit box text
set(hObject,'String',get(hObject,'String'));
% Place the cursor in the edit box
uicontrol(hObject);

% Save handles structures
save_handles(handles);

end

% Transmission Line Length Edit Box Key Press Callback
function line_length_keypress_callback(hObject,event)

% Get handles structure
handles = guidata(hObject);

% On a keypress
switch(event.Key)
    % If the return key is pressed
    case 'return'
        % Disable the editbox temporarily. This removes the
        % cursor from the editbox.
        set(hObject,'Enable','off');
end

% Save handles structures
save_handles(handles);

end


%% Animation Control Panel Callback Objects

% Play Button Callback
function play_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set all of the edit boxs states to inactive
% By setting the edit boxes states to inactive, it will highlight the
% text in the edit box when the user clicks the edit box
% This function call has no effect on the plot, it is placed here to
% periodically ensure that all of the edit boxes are in the inactive
% state.
set_edit_boxes_inactive(handles);

% If recalculation of transmission line parameters is needed
if(handles.recalc_needed)
    set(handles.tline_settings_fig, 'pointer', 'watch');
    set(handles.animation_fig, 'pointer', 'watch');
    set(handles.animation_settings_fig, 'pointer', 'watch');
    set(handles.animation_slider_fig, 'pointer', 'watch');
    set(handles.source_select_fig, 'pointer', 'watch');
    set(handles.load_select_fig, 'pointer', 'watch');
    set(handles.legend_fig, 'pointer', 'watch');
    drawnow;
    % Update transmission line data
    handles.tline.update_props;
    set(handles.tline_settings_fig, 'pointer', 'arrow');
    set(handles.animation_fig, 'pointer', 'arrow');
    set(handles.animation_settings_fig, 'pointer', 'arrow');
    set(handles.animation_slider_fig, 'pointer', 'arrow');
    set(handles.source_select_fig, 'pointer', 'arrow');
    set(handles.load_select_fig, 'pointer', 'arrow');
    set(handles.legend_fig, 'pointer', 'arrow');
    % Recalculation no longer needed until other parameters are changed
    handles.recalc_needed = 0;
    % Move animation slider back to the start
    set(handles.animation_slider,'Value',0);
    % Set the plot index back to the start
    handles.plot_idx = 1;
end

% Toggle play state
% handles.play_button.UserData is initialized to 0 at start up, so on
% the first button press it will be set to 1. Each successive button
% press will toggle the play state between 0 and 1.
play_state = ~get(handles.play_button,'UserData');
set(handles.play_button,'UserData',play_state);

% Set stop state to 0
set(handles.stop_button,'UserData',0);

speed = str2double(get(handles.animation_speed,'String'));

% Animate the data
for k = handles.plot_idx:speed:handles.tline.num_pts
    
    % Get play button state
    play_state = get(handles.play_button,'UserData');
    % Get stop button state
    stop_state = get(handles.stop_button,'UserData');
    
    % Update plot index
    handles.plot_idx = k;
    
    % If play button is pressed
    if(play_state == 1 && stop_state == 0)
        % Make the play button a pause button
        set(handles.play_button,'CData',imread(['images',filesep,'pause_button.png']));
        set(handles.play_button,'BackgroundColor',[1 1 0]);
        % Plot data
        plot_tline_data(handles);
        pause(.01);
        % Calculate slider time
        time = (k/handles.tline.num_pts) * (handles.tline.ts);
        % Set slider time
        set(handles.animation_slider,'Value',time);
        
        % If at the end of the animation
        if(handles.plot_idx + speed > handles.tline.num_pts)
            % Update plot index
            handles.plot_idx = handles.tline.num_pts;
            % Plot data
            plot_tline_data(handles);
            pause(.01);
            
            % Reset the animation
            % Make the pause button a play button
            set(handles.play_button,'CData',imread(['images',filesep,'play_button.png']));
            set(handles.play_button,'BackgroundColor',[0 1 0]);
            % Reset the play button state
            set(handles.play_button,'UserData',0);
            % Reset time slider
            set(handles.animation_slider,'value',0);
            % Reset plot index
            handles.plot_idx = 1;
        end
        % Save handles structures
        save_handles(handles);
        % If pause button is pressed
    elseif(play_state == 0 && stop_state == 0)
        % Make the pause button a play button
        set(handles.play_button,'CData',imread(['images',filesep,'play_button.png']));
        set(handles.play_button,'BackgroundColor',[0 1 0]);
        % Save handles structures
        save_handles(handles);
        % Exit the animation for loop
        break;
    end
    % If the stop button is pressed
    if(stop_state == 1)
        % Make the pause button a play button
        set(handles.play_button,'CData',imread(['images',filesep,'play_button.png']));
        set(handles.play_button,'BackgroundColor',[0 1 0]);
        % Reset the play button state
        set(handles.play_button,'UserData',0)
        % Reset the stop button state
        set(handles.stop_button,'UserData',0)
        % Reset plot index
        handles.plot_idx = 1;
        % Save handles structures
        save_handles(handles);
        stop_button_callback(handles.stop_button,0)
        % Exit the animation for loop
        break;
    end
end

end

% Stop Button Callback
function stop_button_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set play button value to 0 to stop the play function
set(handles.play_button,'UserData',0);
% Set
set(handles.stop_button,'UserData',1);
% Reset time slider
set(handles.animation_slider,'value',0);
% Reset plot index
handles.plot_idx = 1;

% Clear all of the axes
axes(handles.ax_dist);
cla;
axes(handles.ax_src);
cla;
axes(handles.ax_load);
cla;

% Save handles structures
save_handles(handles);

end

% Animation Slider Callback
function animation_slider_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Get the slider position
slider_pos = get(hObject,'Value');

% Adjust plot index
handles.plot_idx = round((slider_pos*(handles.tline.num_pts-1))/(handles.tline.ts))+1;

% Plot data
plot_tline_data(handles);

% Save handles structures
save_handles(handles);

end


%% Figure Close Request Callbacks

% Animation figure close request callback
function animation_fig_close_request_callback(hObject,~)

% Make the animation figure window invisible
set(hObject,'Visible','off');

end

% Load select figure close request callback
function load_select_fig_close_request_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility to off and set check mark to off in load menu
set_figure_window_visibility(handles.tline_settings_load_panel,hObject);

% Save handles structures
save_handles(handles);

end

% Source select figure close request callback
function source_select_fig_close_request_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility to off and set check mark to off in source menu
set_figure_window_visibility(handles.tline_settings_source_panel,hObject);

% Save handles structures
save_handles(handles);

end

% Animation settings figure close request callback
function animation_settings_fig_close_request_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility to off and set settings check mark to off in animation menu
set_figure_window_visibility(handles.tline_settings_animation_settings,hObject);

% Save handles structures
save_handles(handles);

end

% Animation slider figure close request callback
function animation_slider_fig_close_request_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility to off and set slider check mark to off in animation menu
set_figure_window_visibility(handles.tline_settings_animation_slider,hObject);

% Save handles structures
save_handles(handles);

end

% Legend figure close request callback
function legend_fig_close_request_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility to off and set legend check mark to off in settings menu
set_figure_window_visibility(handles.animation_help_legend,hObject);

% Save handles structures
save_handles(handles);

end

% Calculations figure close request callback
function calculations_fig_close_request_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility to off and set calculations check mark to off in settings menu
set_figure_window_visibility(handles.tline_settings_help_calculations,hObject);

% Save handles structures
save_handles(handles);

end

% Simulation notes figure close request callback
function simulation_notes_fig_close_request_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Set figure window visibility to off and set calculations check mark to off in settings menu
set_figure_window_visibility(handles.tline_settings_help_notes,hObject);

% Save handles structures
save_handles(handles);

end

% Settings figure close request callback
function tline_settings_fig_close_request_callback(hObject,~)

% Get handles structure
handles = guidata(hObject);

% Close the animation figure window
delete(handles.animation_fig);

% Close the load select figure window
delete(handles.load_select_fig);

% Close the source select figure window
delete(handles.source_select_fig);

% Close the animation settings figure window
delete(handles.animation_settings_fig);

% Close the animation slider figure window
delete(handles.animation_slider_fig);

% Close the legend figure window
delete(handles.legend_fig);

% Close the calculations figure window
delete(handles.calculations_fig);

% Close the simulation notes figure window
delete(handles.simulation_notes_fig);

% Close the transmission line settings figure window
delete(handles.tline_settings_fig);

end
