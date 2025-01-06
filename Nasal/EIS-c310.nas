# Copyright 2018 Stuart Buchanan
# This file is part of FlightGear.
#
# FlightGear is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# FlightGear is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with FlightGear.  If not, see <http://www.gnu.org/licenses/>.
#
# EIS
var EIS =
{
  new : func (mfd, myCanvas, device, svg)
  {
    var obj = {
      parents : [
        EIS,
        MFDPage.new(mfd, myCanvas, device, svg, "EIS", "")
      ],
    };

    obj.setController(fg1000.EISController.new(obj, svg));

    obj.addTextElements(["ManDisplay1", "ManDisplay2", "RPMDisplay1", "RPMDisplay2", "MBusVolts", "EBusVolts", "MBattAmps", "SBattAmps", "GPHDisplay1", "GPHDisplay2"]);

    obj._fuelFlowPointer1    = PFD.RotatingElement.new(obj.pageName, svg, "FuelFlowPointer1", 7.0, 35, 250.0, [150,100]);
    obj._oilPressurePointer1 = PFD.PointerElement.new(obj.pageName, svg, "OilPressurePointer1", 0, 60.0, 135);
    obj._oilTempPointer1     = PFD.PointerElement.new(obj.pageName, svg, "OilTempPointer1", 0, 300.0, 135);
    obj._EGTPointer1         = PFD.PointerElement.new(obj.pageName, svg, "EGTPointer1", 1200, 1600, 135);
    obj._CHTPointer1         = PFD.PointerElement.new(obj.pageName, svg, "CHTPointer1", 200, 500, 135);
    obj._leftFuelPointer    = PFD.PointerElement.new(obj.pageName, svg, "LeftFuelPointer", 0.0, 80.0, 135);
    obj._rightFuelPointer   = PFD.PointerElement.new(obj.pageName, svg, "RightFuelPointer", 0.0, 80.0, 135);

    obj._RPMPointer1 = PFD.RotatingElement.new(obj.pageName, svg, "RPMPointer1", 0.0, 2700.0, 250.0, [150,100]);
    obj._ManPointer1 = PFD.RotatingElement.new(obj.pageName, svg, "ManPointer1", 10.0, 45.0, 250.0, [150,200]);
    
    obj._fuelFlowPointer2    = PFD.RotatingElement.new(obj.pageName, svg, "FuelFlowPointer2", 7.0, 35, 250.0, [150,100]);
    obj._oilPressurePointer2 = PFD.PointerElement.new(obj.pageName, svg, "OilPressurePointer2", 0, 60.0, 135);
    obj._oilTempPointer2     = PFD.PointerElement.new(obj.pageName, svg, "OilTempPointer2", 0, 300.0, 135);
    obj._EGTPointer2         = PFD.PointerElement.new(obj.pageName, svg, "EGTPointer2", 1200, 1600, 135);
    obj._CHTPointer2         = PFD.PointerElement.new(obj.pageName, svg, "CHTPointer2", 200, 500, 135);

    obj._RPMPointer2 = PFD.RotatingElement.new(obj.pageName, svg, "RPMPointer2", 0.0, 2700.0, 250.0, [150,100]);
    obj._ManPointer2 = PFD.RotatingElement.new(obj.pageName, svg, "ManPointer2", 10.0, 45.0, 250.0, [150,200]);
    

    return obj;
  },

  updateEngineData : func(engineData) {
    me.setTextElement("RPMDisplay1", sprintf("%i", engineData.RPM1));
    me.setTextElement("RPMDisplay2", sprintf("%i", engineData.RPM2));
    me.setTextElement("ManDisplay1", sprintf("%.1f", engineData.Man1));
    me.setTextElement("ManDisplay2", sprintf("%.1f", engineData.Man2));
    me.setTextElement("MBusVolts", sprintf("%.01f", engineData.MBusVolts));
    me.setTextElement("EBusVolts", sprintf("%.01f", engineData.EBusVolts));
    me.setTextElement("MBattAmps", sprintf("%+.01f", engineData.MBattAmps));
    me.setTextElement("SBattAmps", sprintf("%+.01f", engineData.SBattAmps));
    me.setTextElement("GPHDisplay1", sprintf("%.1f", engineData.FuelFlowGPH1));
    me.setTextElement("GPHDisplay2", sprintf("%.1f", engineData.FuelFlowGPH2));


    me._fuelFlowPointer1.setValue(engineData.FuelFlowGPH1);
    me._oilPressurePointer1.setValue(engineData.OilPressurePSI1);
    me._oilTempPointer1.setValue(engineData.OilTemperatureF1);
    me._EGTPointer1.setValue(engineData.EGTNorm1);
    me._CHTPointer1.setValue(engineData.CHTDegF1);

    me._RPMPointer2.setValue(engineData.RPM2);
    me._ManPointer2.setValue(engineData.Man2);
        me._fuelFlowPointer2.setValue(engineData.FuelFlowGPH2);
    me._oilPressurePointer2.setValue(engineData.OilPressurePSI2);
    me._oilTempPointer2.setValue(engineData.OilTemperatureF2);
    me._EGTPointer2.setValue(engineData.EGTNorm2);
    me._CHTPointer2.setValue(engineData.CHTDegF2);

    me._RPMPointer1.setValue(engineData.RPM1);
    me._ManPointer1.setValue(engineData.Man1);
  },

  updateFuelData : func(fuelData) {
    me._leftFuelPointer.setValue(fuelData.LeftFuelUSGal);
    me._rightFuelPointer.setValue(fuelData.RightFuelUSGal);
  },

  # Menu tree .  engineMenu is referenced from most pages as softkey 0:
  # pg.addMenuItem(0, "ENGINE", pg, pg.mfd.EISPage.engineMenu);
  engineMenu : func(device, pg, menuitem) {
    pg.clearMenu();
    pg.resetMenuColors();
    pg.addMenuItem(0, "ENGINE", pg, pg.mfd.EIS.engineMenu);
    pg.addMenuItem(1, "LEAN", pg, pg.mfd.EIS.leanMenu);
    pg.addMenuItem(2, "SYSTEM", pg, pg.mfd.EIS.systemMenu);
    pg.addMenuItem(8, "BACK", pg, pg.topMenu);
    device.updateMenus();
  },

  leanMenu : func(device, pg, menuitem) {
      pg.clearMenu();
      pg.resetMenuColors();
      pg.addMenuItem(0, "ENGINE", pg, pg.mfd.EIS.engineMenu);
      pg.addMenuItem(1, "LEAN", pg, pg.mfd.EIS.leanMenu);
      pg.addMenuItem(2, "SYSTEM", pg, pg.mfd.EIS.systemMenu);
      pg.addMenuItem(3, "CYL SELECT", pg);
      pg.addMenuItem(4, "ASSIST", pg);
      pg.addMenuItem(9, "BACK", pg, pg.mfd.EIS.engineMenu);
      device.updateMenus();
  },

  systemMenu : func(device, pg, menuitem) {
      pg.clearMenu();
      pg.resetMenuColors();
      pg.addMenuItem(0, "ENGINE", pg, pg.mfd.EIS.engineMenu);
      pg.addMenuItem(1, "LEAN", pg, pg.mfd.EIS.leanMenu);
      pg.addMenuItem(2, "SYSTEM", pg, pg.mfd.EIS.systemMenu);
      pg.addMenuItem(3, "RST FUEL", pg, func(dev, pg, mi) { pg.mfd.EIS.getController().setFuelQuantity(0); });
      pg.addMenuItem(4, "GAL REM", pg, pg.mfd.EIS.galRemMenu);
      pg.addMenuItem(5, "BACK", pg, pg.mfd.EIS.engineMenu);
      device.updateMenus();
  },

  galRemMenu : func(device, pg, menuitem) {
    pg.clearMenu();
    pg.resetMenuColors();
    pg.addMenuItem(0, "ENGINE", pg, pg.mfd.EIS.engineMenu);
    pg.addMenuItem(1, "LEAN", pg, pg.mfd.EIS.leanMenu);
    pg.addMenuItem(2, "SYSTEM", pg, pg.mfd.EIS.systemMenu);
    pg.addMenuItem(3, "-10 GAL", pg, func(dev, pg, mi) { pg.mfd.EIS.getController().updateFuelQuantity(-10); } );
    pg.addMenuItem(4, "-1 GAL",  pg, func(dev, pg, mi) { pg.mfd.EIS.getController().updateFuelQuantity(-1); });
    pg.addMenuItem(5, "+1 GAL",  pg, func(dev, pg, mi) { pg.mfd.EIS.getController().updateFuelQuantity(1); });
    pg.addMenuItem(6, "+10 GAL", pg, func(dev, pg, mi) { pg.mfd.EIS.getController().updateFuelQuantity(10); });
    pg.addMenuItem(7, "44 GAL",  pg, func(dev, pg, mi) { pg.mfd.EIS.getController().setFuelQuantity(44); });
    pg.addMenuItem(8, "BACK", pg, pg.mfd.EIS.engineMenu);
    device.updateMenus();
  },

  offdisplay : func() {
    me._group.setVisible(0);

    # Reset the menu colours.  Shouldn't have to do this here, but
    # there's not currently an obvious other location to do so.
    for(var i = 0; i < 12; i +=1) {
      var name = sprintf("SoftKey%d",i);
      me.device.svg.getElementById(name ~ "-bg").setColorFill(0.0,0.0,0.0);
      me.device.svg.getElementById(name).setColor(1.0,1.0,1.0);
    }
    me.getController().offdisplay();
  },
  ondisplay : func() {
    me._group.setVisible(1);
    me.getController().ondisplay();
  },


};
