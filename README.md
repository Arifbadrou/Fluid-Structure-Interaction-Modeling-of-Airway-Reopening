# Fluid-Structure-Interaction-Modeling-of-Airway-Reopening
This repository contains the CFD and FSI models developed to investigate the role of airway wall deformability on liquid plug rupture during airway reopening. The fluid domain is solved using OpenFOAM (interIsoFoam), and the structural domain is solved using CalculiX. Coupling is performed using preCICE with a strongly implicit scheme

## Software Versions

- OpenFOAM v2406
- CalculiX 2.20
- preCICE 3.2.0

## Repository Structure

- `CFD/` – Rigid wall OpenFOAM CFD model
- `FSI/` – Coupled OpenFOAM-CalculiX model with preCICE
