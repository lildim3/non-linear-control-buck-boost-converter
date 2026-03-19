# Buck-Boost Converter Control in MATLAB/Simulink

This repository presents the modeling, simulation, and comparative control design of an averaged inverting buck-boost DC-DC converter in MATLAB/Simulink. The project covers open-loop analysis, linear and nonlinear controller design, disturbance rejection, measurement-noise response, and robustness testing with respect to parameter uncertainty. It combines state-space modeling with multiple control strategies, including linear control, exact feedback linearization, and sliding-mode-based approaches.

## Project Overview

The system under study is an averaged inverting buck-boost converter, modeled in state space using:

- inductor current \(i_L\)
- capacitor voltage \(v_C\)

as the main state variables.

The converter is analyzed around a nominal operating point corresponding to an output voltage of approximately **-22.5 V**, with a nominal duty cycle of approximately **0.65**. The project includes both open-loop and closed-loop simulations and compares controller behavior under realistic operating conditions such as load disturbances, additive measurement noise, and parameter variation.

## Main Objectives

The goals of this project are to:

- derive and simulate an averaged nonlinear model of the buck-boost converter
- analyze open-loop behavior and equilibrium properties
- design and evaluate linear and nonlinear controllers
- compare tracking performance for different control strategies
- test disturbance rejection under load changes
- evaluate sensitivity to measurement noise
- assess robustness to inductance variations in the range of 80% to 120% of the nominal value

## System Model

The converter is modeled as a second-order nonlinear system with:

- \(x_1 = i_L\) — inductor current
- \(x_2 = v_C\) — capacitor voltage
- \(u\) — duty cycle control input

The averaged state-space model is:

\[
\dot{x}_1 = \frac{1-u}{L}x_2 + \frac{E}{L}u
\]

\[
\dot{x}_2 = -\frac{1-u}{C}x_1 - \frac{1}{RC}x_2
\]

The project studies both the nonlinear form and, where needed, linearized models around the nominal operating point.

## Control Approaches

This repository includes multiple stages of controller development.

### 1. Open-Loop Analysis
The open-loop Simulink model is used to examine:

- transient response from initial to nominal state
- phase portrait behavior
- equilibrium characteristics
- sensitivity to noise and inductance variation

The open-loop system is shown to behave like a stable focus around the equilibrium point.

### 2. Linear Control
A linearized model around the operating point is used as the basis for linear controller design. The project includes controller design based on:

- dynamic inversion
- PI regulation
- lead-lag compensation

This part establishes a baseline for comparison with nonlinear controllers.

### 3. Exact Feedback Linearization (eFL)
A nonlinear controller based on exact feedback linearization is implemented by canceling system nonlinearities and transforming the system into a linear input-output form. Integral action is added to improve disturbance rejection and eliminate steady-state error.

The eFL controller is evaluated in terms of:

- reference tracking
- transient speed
- disturbance suppression
- noise rejection
- robustness to parameter changes

### 4. Sliding Mode Control (SMC)
Sliding Mode Control is used as a robust nonlinear control strategy based on the definition of a sliding surface and discontinuous control action that drives the trajectory toward that surface.

The project studies:

- standard SMC
- SMC with integral action
- boundary-layer SMC to reduce chattering

These variants are compared in terms of tracking quality, robustness, and practical implementation tradeoffs.

## Disturbance, Noise, and Robustness Analysis

The controllers are tested under several non-ideal conditions:

### Load Disturbance
Load disturbance is modeled as a change in output resistance \(R\), typically in the range of **20% to 25%**, in order to simulate realistic operating perturbations.

### Measurement Noise
Additive stochastic noise with a standard deviation of **2%** of the nominal output is injected into the output measurement to evaluate noise sensitivity and filtering properties.

### Parameter Uncertainty
Robustness is evaluated by varying inductance \(L\) between:

- **0.8L**
- **0.9L**
- **L**
- **1.1L**
- **1.2L**

This allows comparison of controller sensitivity to plant uncertainty.

## Key Results

The project shows that different control approaches produce significantly different performance profiles:

- the linear controller provides a useful baseline but is more limited outside the local operating region
- exact feedback linearization improves tracking and disturbance rejection by compensating nonlinearities directly
- sliding-mode-based controllers offer stronger robustness, especially under disturbances and parameter mismatch
- adding integral action improves steady-state regulation
- introducing a boundary layer reduces chattering while preserving much of the robustness of SMC

The reports also show that the converter remains strongly nonlinear and that robustness considerations are essential when selecting a practical controller.

## Included Files

### Simulink models
- `openloop.slx`  
  Open-loop averaged buck-boost converter model used for transient and phase-plane analysis.

- `closedloop.slx`  
  Closed-loop converter model with controller implementation and response analysis.

- `eFL_control.slx`  
  Exact feedback linearization controller implementation in Simulink.

- `SMC suzbija poremecaj.slx`  
  Sliding-mode-based control model focused on disturbance suppression.

### MATLAB scripts
- `robusnost_grafici.m`  
  Script for generating robustness plots under parameter variation.

- `NSU_2_3_plot.m`  
  Script used for plotting and post-processing simulation results from the control analysis.

### Report
- `NSU_projekat3.pdf`  
  Comparative analysis report covering modeling, controller design, noise, disturbance rejection, and robustness results.

## How to Run

1. Open the repository in MATLAB.
2. Open the required Simulink model:
   - `openloop.slx`
   - `closedloop.slx`
   - `eFL_control.slx`
   - `SMC suzbija poremecaj.slx`
3. Run the selected simulation.
4. Use the MATLAB scripts to generate comparison and robustness plots if needed.

## Software and Tools

- MATLAB
- Simulink

## Topics

buck-boost-converter, dc-dc-converter, nonlinear-control, sliding-mode-control, feedback-linearization, robust-control, matlab, simulink, power-electronics, control-systems

## Report

The full project report is available here:

[Comparative Analysis Report (PDF)](reports/NSU_projekat3.pdf)# non-linear-control-buck-boost-converter
Modeling, simulation, and comparative control of an inverting buck-boost converter in MATLAB/Simulink, including linear control, exact feedback linearization, sliding-mode control, disturbance rejection, and robustness analysis.
