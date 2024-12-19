import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

(:background)
class batterylifeApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        var v = new batterylifeView();
        return [ v, new batterylifeDelegate(v) ];
    }

    public function getServiceDelegate() as [ServiceDelegate] {
        return [new batterylifeBackground()];
    }

}

function getApp() as batterylifeApp {
    return Application.getApp() as batterylifeApp;
}