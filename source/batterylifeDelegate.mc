import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;


class batterylifeDelegate extends WatchUi.BehaviorDelegate {
    var view;
    var status;
    var isBackgroundTaskRunning;
    var lastStartedAt;

     private const TIMER_DURATION_DEFAULT = (5 * 60);    // 5 minutes


    function initialize(v as batterylifeView) {
        view = v;
        BehaviorDelegate.initialize();

        isBackgroundTaskRunning = Background.getTemporalEventRegisteredTime();
        if (isBackgroundTaskRunning != null) {
            status = true;
        } else {
            Storage.setValue("last_start_at", null);
            Storage.setValue("charge_time", null);
            status = false; 
        }
        Storage.setValue("status", status);
    }

    function onSelect() as Boolean {
        status = !status;
        Storage.setValue("status", status);
        isBackgroundTaskRunning = Background.getTemporalEventRegisteredTime();

        if (status && isBackgroundTaskRunning == null) {
            var time = new Time.Duration(TIMER_DURATION_DEFAULT);
            Background.registerForTemporalEvent(time);
            Storage.setValue("last_start_at", getCurrentTimestamp());
            Storage.setValue("charge_time", Time.now().value());
        } else {
            Background.deleteTemporalEvent();
            Storage.setValue("last_start_at", null);
            Storage.setValue("charge_time", null);
        }


        return true;
    }

    function getCurrentTimestamp() as Lang.String {
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        return Lang.format( "$1$-$2$-$3$ $4$:$5$:$6$",
                [
                    today.year,
                    today.month.format("%02d"),
                    today.day.format("%02d"),
                    today.hour.format("%02d"),
                    today.min.format("%02d"),
                    today.sec.format("%02d"),
                ]
            );
    }
}