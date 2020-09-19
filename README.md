# Compressed Sensing Simulation

<h1>
  Introduction
</h1>
<p>
This repository contains codes for simulating compressed single pixel imaging. I developed the codes as part of my master's thesis, "Single Pixel Camera Based Spatial Frequency Domain imaging for Non-Contact Tissue Characterization", which is available in this repository as well. The principle behind single pixel imaging is the redundant characteristics of images can be exploited to achieve sub-Nyquist sampling. This is a MATLAB simulation, but I have plans to write an implementation in Python considering how expensive a MATLAB license can be outside of academia.
</p>

<h1>
  Contents
</h1>
<p>
  This repository contains the following:
</P>
<li>
  run: Main file used to run the simulation.
</li>
<li>
  spcSimulation: Function that generates a measurement basis, which are used to sample a target image/scenery.
</li>
<li>
  reconstruct: Function that reconstructs the simulated single pixel camera measurements from "spcSimulation.m" using a specified compressed sensing algorithm.
</li>
