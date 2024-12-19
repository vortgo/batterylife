import Toybox.Application.Storage;
import Toybox.Background;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;


(:background)
class batterylifeBackground extends System.ServiceDelegate {

    public function initialize() {
        ServiceDelegate.initialize();
    }

    public function onTemporalEvent() as Void {
        var myStats = System.getSystemStats();

        var lastBattery = Storage.getValue("battery");
        if (lastBattery == null) {
            lastBattery = 0;
        }

        var currentBattery = myStats.battery;
        if (currentBattery > lastBattery) {
            Storage.setValue("charge_time", Time.now().value());
            Storage.setValue("battery", currentBattery);
        }
    }
}

