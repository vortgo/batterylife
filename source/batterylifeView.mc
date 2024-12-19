import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Time;
import Toybox.Timer;
import Toybox.Lang;


class batterylifeView extends WatchUi.View {

    var statusElem;
    var lastStartedAtElem;
    var sinceLastChargeElem;

    private var _updateTimer as Timer.Timer;



    function initialize() {
        View.initialize();


        _updateTimer = new Timer.Timer();
        _updateTimer.start(method(:requestUpdate), 1000, true);
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        statusElem = View.findDrawableById("status") as Text;
        lastStartedAtElem = View.findDrawableById("last_start") as Text;
        sinceLastChargeElem = View.findDrawableById("since_last_charge") as Text;

        updateStatus(false);
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        var status = Storage.getValue("status");
        var lastStart = Storage.getValue("last_start_at");
        var chargeTime = Storage.getValue("charge_time");

        if(status != null) {
            updateStatus(status );
        }

        if (lastStart != null) {
            lastStartedAtElem.setText(lastStart);
        } else {
             lastStartedAtElem.setText("- - -");
        }

        if (chargeTime != null) {
            var nowUnixTime = Time.now().value();
            var diffSeconds = nowUnixTime - chargeTime;

            var days = diffSeconds / 86400; 
            var hours = (diffSeconds % 86400) / 3600;
            var minutes = (diffSeconds % 3600) / 60;
            var seconds = diffSeconds % 60;
            var sinceLastCharge = Lang.format("$1$ day(s) $2$:$3$:$4$", [days.format("%02d"), hours.format("%02d"), minutes.format("%02d"), seconds.format("%02d")]);
            sinceLastChargeElem.setText(sinceLastCharge);
        } else {
            sinceLastChargeElem.setText("- - -");
        }

        View.onUpdate(dc);
    }

    function onHide() as Void {
        
    }

    function updateStatus(status) as Void {
        if (status) {
            statusElem.setText("ACTIVE");
            statusElem.setColor(Graphics.COLOR_GREEN);
        } else {
            statusElem.setText("INACTIVE");
            statusElem.setColor(Graphics.COLOR_RED);
        }

        WatchUi.requestUpdate();
    }

    function updateLastStartedAt(lastStartedAt) as Void {
        lastStartedAtElem.setText(lastStartedAt);
        WatchUi.requestUpdate();
    }

    function updateSinceLastCharge(sinceLastCharge) as Void {
        sinceLastChargeElem.setText(sinceLastCharge);
        WatchUi.requestUpdate();
    }

     public function requestUpdate() as Void {
        WatchUi.requestUpdate();
    }

}
