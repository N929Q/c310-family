# 512 Colorado's Fork of the Cessna 310 Family
Let's take the 310 to the level of the 172p!

### Currently Working:
* Paintable Exterior with a decent paintjob
* Paintkit Materials
* T310P variant *There are switches for radio and avionics- they need to be turned on* 
	* 63gal Aux Tanks
	* KNS-80 (Enables GPS through Route Manager)
	* King KFC-200 Avionics
	* Autopilot
* Drop in replacement fuel.xml based on the c182. Just until the bugs are worked out.
* Panel update for 1953 panel adding COMM, NAV, and ADF from the c140 and c150 (Those radios look old enough to not break the experience)

### Known Issues / Things I've Broken:
* Prop Feather animation broken- I duplicated the axises in Blender but have since learned it's not so simple...
* Fuel flow gauge needs to be adapted for other engines. IDK if it was factory on the A, but seems it was there in 1955...
* CHT gauges (T310 only)
* Pressure-based fuel system has a leak. Right system leaks from selected tank when left system in position other than off. 

### Fixed Issues / Modifications:
* Parking brake handle modified, activate by clicking bracket (This was done because the rod on the handle was clickable behind the switches)
* Both fuel gauges were reading left tank- now reads selected tank, will show empty when fuel is off or on crossfeed.
* Autopilot and ADF switches purposed for radios and avionics power
* Toe brakes animation right pedal was reversed
* Added save states for radios and fuel
* Changed angle of rotating beacon animated light to keep it off the panel (Beige panel)
* Yoke animation was passing through panel at full forward deflection.

### To Implement:
* Multiple Panel Options
* KNS-80
* NAV/COMM radios
* King KFC-200 w/ Autopilot
* FG1000 w/ Autopilot
* T310P Variant
* Textures for panel (To allow the classic and modern panels to coexist better)
* Checklists
* I'm just getting started


# Cessna 310 family
The Cessna 310 family modelled for FlightGear

## Installation

Put the contents of this repository into a directory of your choice by either
* `git clone`ing it:
	```sh
	~$ cd /some/path/Aircraft
	/some/path/Aircraft$ git clone https://github.com/TheFGFSEagle/c310-family
	```
* or downloading the repository as a ZIP file and unzipping it with your favorite archive manager into `/some/path/Aircraft/c310-family` (make sure to remove the trailing `-master` from the directory name !)

Then, tell FlightGear to search `/some/path/Aircraft` for aircraft by either
* adding `/some/path/Aircraft` to the list of additional aircraft folders in the Addons tab of FGLauncher
* or passing `--aircraft-dir=/some/path/Aircraft` on the command line.

### IMPORTANT:
**No matter which of the methods above you use, make sure that you put this into `/some/path/Aircraft/c310-family` and pass `/some/path/Aircraft` to FlightGear to search for aircraft in - if you change `Aircraft/c310-family` to anything else, FlightGear will NOT be able to find and load the 3D model !**

## Contents

* Cessna 310A

## Status

This aircraft is currently being worked on by @ysopflying, chad3006 (on the forum) and @TheFGFSEagle.

### Features
* Exterior 3D model only missing some details like gear actuators etc.
* Interior model: Seats, fuel selectors, engine controls, doors, yokes, most switches, most instruments, all circuit breakers, … are modelled and fully interactive.
* FDM: Work in progress by @ysopflying, using wind tunnel data from a C310P and OpenVSP to adapt that to the C310A.
* Systems: Propeller feathering, oil system, engine overheating, lights …
* Equipment: Optional auxiliary fuel tanks, right landing light and rotating beacon are available
* Some failures are implemented
