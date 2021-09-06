mBldcm (Brushless DC Motor Driver IP)
=====================================

Overview
--------
This is hardware IP of Brushless DC Motor Driver.

Interfaces
----------
* Avalon Memory Mapped (Avalon-MM) I/F
	- I/F between this IP and other controllers, e.g. Micro Controller.
	- To control the motor driver.
	- To get status of the motor driver.
	- Please read [RegisterMap\_mBldcm][RegisterMap] for more detail.
* 6 signals to drive gate to drive BLDCM
	- U-phase signal (High-side/Low-side)
	- V-phase signal (High-side/Low-side)
	- W-phase signal (High-side/Low-side)

[RegisterMap]:/RegisterMap_mBldcm.pdf

Integration
-----------
You can use Intel Platform Designer (Old name: Qsys)
to integrate this IP into your system.

Requirement
-----------
* [LPM\_DIVIDE IP Core (Intel FPGA Integer Arithmetic IP Cores Series)][IntelIntegerIP]

[IntelIntegerIP]:https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/ug/ug_lpm_alt_mfug.pdf

License
-------
Please see `LICENSE.md` file for details.

