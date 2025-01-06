aircraft.data.save(1);

parts.manager.createCategory("instruments", "Instruments")
				.createPart("clock", "Clock", ["AT420100", "35-380004-1"], 1)
				.createPart("rudder-position-indicator", "Rudder position indicator", ["default"], 1, 1)
				.createPart("turn-coordinator", "Turn coordinator", ["23-328-04"])
				.createCategory("misc", "Miscellaneous")
				.createPart("stall-warning", "Stall warning", ["0511062-7"])
				.createCategory("lighting", "Lighting")
				.createPart("uv-instrument-light", "UV instrument light", ["AN3125-1"], 0, 0, 2)
				.createPart("red-instrument-light", "Red instrument light", ["AN3124-307"])
				.createPart("dome-lights", "Dome lights", ["AN3124-307"])
				.createPart("map-light", "Map light", ["A-1425A-2-12"])
				.createCategory("fuel-system", "Fuel system")
				.createPart("fuel-boost-pump", "Fuel boost pump", ["1C6-10"]);
				
var nasal_dir = getprop("/sim/fg-root") ~ "/Aircraft/Instruments-3d/FG1000/Nasal/";
#io.load_nasal(nasal_dir ~ 'Interfaces/GenericInterfaceController.nas', "fg1000");

var aircraft_dir = getprop("/sim/aircraft-dir");
io.load_nasal(aircraft_dir ~ '/Nasal/c310-InterfaceController.nas', "fg1000");
var interfaceController = fg1000.GenericInterfaceController.getOrCreateInstance();
interfaceController.start();
# Load a customer Interface controller
io.load_nasal(aircraft_dir ~ '/Nasal/c310-EISPublisher.nas', "fg1000");
io.load_nasal(aircraft_dir ~ '/Nasal/EIS-c310.nas', "fg1000");
io.load_nasal(aircraft_dir ~ '/Nasal/EISController.nas', "fg1000");
io.load_nasal(aircraft_dir ~ '/Nasal/EISStyles.nas', "fg1000");
io.load_nasal(aircraft_dir ~ '/Nasal/EISOptions.nas', "fg1000");
var EIS_Class = fg1000.EIS;
interfaceController.start();
var nasal_dir = getprop("/sim/fg-root") ~ "/Aircraft/Instruments-3d/FG1000/Nasal/";
io.load_nasal(nasal_dir ~ 'FG1000.nas', "fg1000");

# Create the FG1000
var fg1000system = fg1000.FG1000.getOrCreateInstance(EIS_Class:EIS_Class, EIS_SVG: "Nasal/MFDPages/EIS-C182T.svg");

# Create a PFD as device 1, MFD as device 2
fg1000system.addPFD(index:2);
fg1000system.addMFD(index:1);

# Map the devices to placement objects Screen{i}, in this case Screen1 and Screen2
fg1000system.display(index:2);
fg1000system.display(index:1);

# Show the devices
#fg1000system.show(index:1);
#fg1000system.show(index:2);

#  Display a GUI version of device 1 at 50% scale.
#fg1000system.displayGUI(index:1, scale:0.5);

# Control the backlighting of the bezel based on the avionics light knob
setlistener("/controls/lighting/uv-instrument-norm", func(n) {
    if (getprop("/systems/electrical/consumers/uv-instrument-light/volts") > 5.0) {
      setprop("/instrumentation/FG1000/Lightmap", n.getValue()*2);
    } else {
      setprop("/instrumentation/FG1000/Lightmap", 0.0);
    }
}, 0, 0);
setlistener("/systems/electrical/outputs/fg1000-mfd", func(n) {
    if (n.getValue() > 0) {
      fg1000system.show(1);
    } else {
      fg1000system.hide(1);
    }
}, 0, 0);

setlistener("/systems/electrical/outputs/fg1000-pfd", func(n) {
    if (n.getValue() > 0) {
#    fg1000system.addPFD(index:2);
#    fg1000system.display(index:2);
      fg1000system.show(2);
    } else {
      fg1000system.hide(2);
    }
}, 0, 0);

setlistener("/sim/signals/fdm-initialized", func {
  aircraft.data.add(
    "instrumentation/comm[0]/volume",
    "instrumentation/comm[0]/frequencies/selected-mhz",
    "instrumentation/comm[0]/frequencies/standby-mhz",
    "instrumentation/comm[0]/test-btn",
    "instrumentation/nav[0]/volume",
    "instrumentation/nav[0]/audio-btn",
    "instrumentation/nav[0]/power-btn",
    "instrumentation/nav[0]/frequencies/selected-mhz",
    "instrumentation/nav[0]/frequencies/standby-mhz",
    "instrumentation/comm[1]/volume",
    "instrumentation/comm[1]/frequencies/selected-mhz",
    "instrumentation/comm[1]/frequencies/standby-mhz",
    "instrumentation/comm[1]/test-btn",
    "instrumentation/nav[1]/audio-btn",
    "instrumentation/nav[1]/power-btn",
    "instrumentation/nav[1]/frequencies/selected-mhz",
    "instrumentation/nav[1]/frequencies/standby-mhz",
    "consumables/fuel/tank/level-norm",
    "consumables/fuel/tank[1]/level-norm",
    "consumables/fuel/tank[2]/level-norm",
    "consumables/fuel/tank[3]/level-norm",
    "controls/lighting/instruments-norm",
    "controls/lighting/panel-norm",
    "controls/lighting/dome-norm",
  );
});

var maxStartingTime = 6;

var setAdfFrequency = func(digit, n, m) {
	var v = getprop("instrumentation/adf[0]/frequencies/selected-khz-digits" ~ digit);
	if( digit == 2) {
		v = v + 10 * getprop("instrumentation/adf[0]/frequencies/selected-khz-digits3");
		setprop("instrumentation/adf[0]/frequencies/selected-khz-digits3", 0);
	}
	v = math.mod(v + n + m, m);
	setprop("instrumentation/adf[0]/frequencies/selected-khz-digits" ~ digit, v);
	var newFreq = getprop("instrumentation/adf[0]/frequencies/selected-khz-digits0") +
	10*getprop("instrumentation/adf[0]/frequencies/selected-khz-digits1") + 
	100*getprop("instrumentation/adf[0]/frequencies/selected-khz-digits2") + 
	1000*getprop("instrumentation/adf[0]/frequencies/selected-khz-digits3");
	if( newFreq >= 200 and newFreq <= 1800) {
		setprop("instrumentation/adf[0]/frequencies/selected-khz", newFreq);
	}
}

var calcDigits = func( v, prop, ndigit ) {
	v = int( v );
	for( var i = 0; i < ndigit ; i=i+1 ) {
		v2 = int( v / 10 );
		r = v - v2 * 10;
		setprop( prop~i, r );
		v = v2;
	}
}

var MainSystem = {
	# parents: [Updatable],
	
	reset: func {
		
	},

	update: func(dt) {
		
		calcDigits( getprop("instrumentation/adf[0]/frequencies/selected-khz"), 
			    "instrumentation/adf[0]/frequencies/selected-khz-digits", 4);
	},
};


var loop = updateloop.UpdateLoop.new(components: [MainSystem], update_period: 0.1, enable: 1);

var disengageLeftStarterTimer = maketimer(maxStartingTime, func {
	props.globals.setBoolValue("/controls/engines/engine[0]/starter-button", 0);
	props.globals.setBoolValue("/controls/engines/engine[0]/master-alt", 1);
	startRightEngineTimer.start();
});
disengageLeftStarterTimer.singleShot = 1;
disengageLeftStarterTimer.simulatedTime = 1;
var disengageRightStarterTimer = maketimer(maxStartingTime, func {
	props.globals.setBoolValue("/controls/engines/engine[1]/starter-button", 0);
	props.globals.setBoolValue("/controls/engines/engine[1]/master-alt", 1);
	autostartElectricsAfterEngineStart();
});
disengageRightStarterTimer.singleShot = 1;
disengageRightStarterTimer.simulatedTime = 1;
var disengageStarterTimers = [disengageLeftStarterTimer, disengageRightStarterTimer];

var startRightEngineTimer = maketimer(3, func {
	autostartEngine(1);
});
startRightEngineTimer.singleShot = 1;
startRightEngineTimer.simulatedTime = 1;

var autostartEngine = func(i) {
	if (!props.globals.getNode("/engines/engine[" ~ i ~ "]/running").getBoolValue()) {
		props.globals.setIntValue("/controls/fuel/selector[" ~ i ~ "]", 1);
		props.globals.setBoolValue("/controls/engines/engine[" ~ i ~ "]/left-magneto", 1);
		props.globals.setBoolValue("/controls/engines/engine[" ~ i ~ "]/right-magneto", 1);
		props.globals.setDoubleValue("/controls/engines/engine[" ~ i ~ "]/throttle", 0);
		props.globals.setDoubleValue("/controls/engines/engine[" ~ i ~ "]/propeller-pitch", 1);
		props.globals.setDoubleValue("/controls/engines/engine[" ~ i ~ "]/mixture", 1);
		props.globals.setBoolValue("/controls/engines/engine[" ~ i ~ "]/starter-button", 1);
		disengageStarterTimers[i].start();
	}
};

var autostopEngine = func(i) {
	if (props.globals.getNode("/engines/engine[" ~ i ~ "]/running").getBoolValue()) {
		props.globals.setIntValue("/controls/fuel/selector[" ~ i ~ "]", 0);
		props.globals.setBoolValue("/controls/engines/engine[" ~ i ~ "]/left-magneto", 0);
		props.globals.setBoolValue("/controls/engines/engine[" ~ i ~ "]/right-magneto", 0);
		props.globals.setDoubleValue("/controls/engines/engine[" ~ i ~ "]/throttle", 0);
		props.globals.setDoubleValue("/controls/engines/engine[" ~ i ~ "]/propeller-pitch", 1);
		props.globals.setDoubleValue("/controls/engines/engine[" ~ i ~ "]/mixture", 0);
		props.globals.setBoolValue("/controls/engines/engine[" ~ i ~ "]/starter-button", 0);
	}
};

var autostartElectricsBeforeEngineStart = func {
	props.globals.setBoolValue("/controls/electric/battery-switch", 1);
	props.globals.setBoolValue("/controls/lighting/beacon", 1);
	props.globals.setDoubleValue("/controls/lighting/uv-instrument-norm", 1);
	props.globals.setBoolValue("/controls/lighting/uv-instrument-starter-button-pressed[0]", 1);
	props.globals.setBoolValue("/controls/lighting/uv-instrument-starter-button-pressed[1]", 1);
	props.globals.setDoubleValue("/controls/lighting/red-instrument-norm", 1);
}

var autostartElectricsAfterEngineStart = func {
	props.globals.setBoolValue("/controls/lighting/nav-lights", 1);
	props.globals.setIntValue("/controls/lighting/landing-light[0]", 1);
	props.globals.setIntValue("/controls/lighting/landing-light[1]", 1);
}

var autostopElectrics = func {
	props.globals.setBoolValue("/controls/lighting/nav-lights", 0);
	props.globals.setBoolValue("/controls/lighting/beacon", 0);
	props.globals.setIntValue("/controls/lighting/landing-light[0]", -1);
	props.globals.setIntValue("/controls/lighting/landing-light[1]", -1);
	props.globals.setBoolValue("/controls/engines/engine[0]/master-alt", 0);
	props.globals.setBoolValue("/controls/engines/engine[1]/master-alt", 0);
	props.globals.setBoolValue("/controls/electric/battery-switch", 0);
}

var autostart = func {
	autostopElectrics();
	autostartElectricsBeforeEngineStart();
	autostartEngine(0);
};

var autostop = func {
	startRightEngineTimer.stop();
	autostopEngine(0);
	autostopEngine(1);
	autostopElectrics();
};

var autostartstop = func {
	var running = props.globals.getNode("/engines/engine[0]/running").getBoolValue() and props.globals.getNode("/engines/engine[1]/running").getBoolValue();
	if (!running) {
		autostart();
	} else {
		autostop();
	}
};

