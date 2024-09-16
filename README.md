# Transmission Line Transient Analysis

## Overview
This repository provides a MATLAB-based simulation for analyzing the transient voltage on a transmission line terminated by inductive or capacitive loads. The simulation computes the voltage \( V(z,t) \) of the transmission line at the input terminal as a function of time and allows users to visualize the results through a graphical user interface (GUI).

## Repository Structure

- **`tline_sim.m`**: MATLAB GUI file for interactive simulation. Provides a user-friendly interface to input parameters and view results.
  
- **`transient_tline.m`**: Script for modeling the transient behavior of the transmission line. Computes the voltage response based on the input parameters.
  
- **`steady_state_tline.m`**: Script for modeling the steady-state behavior of the transmission line. Provides the long-term voltage distribution after transients have settled.

- **`images/`**: Folder containing images used in the simulation, such as diagrams and plots.

- **`config_files/`**: Folder with preconfigured simulation files that can be loaded through the GUI to simplify setup.

## Parameters

The following parameters are used in the simulation:

- **Vo**: Voltage source
- **Rg**: Internal resistance of the voltage source
- **l**: Length of the transmission line
- **u**: Velocity of the wave through the line
- **R0**: Characteristic impedance (resistive component)
- **X0**: Characteristic impedance (reactive component)
- **LL**: Inductive load
- **CL**: Capacitive load

## How to Use

1. **Setup**: Clone or download this repository to your local machine. Ensure MATLAB is installed on your system.
   ```bash
   git clone https://github.com/kedar-73/transmission-line-simulation.git

2. Run GUI: Open MATLAB and navigate to the repository directory. Run tline_sim.m to launch the GUI.
   ```bash
   cd ~/transmission-line-simulation
   tline_sim

3. Input Parameters: Use the GUI to input the required parameters for your simulation.

4. Run Simulation: After entering the parameters, execute the simulation to observe the transient and steady-state responses.

5. View Results: The results and visualizations will be displayed in the GUI.

## Made by-Kedar Singh
