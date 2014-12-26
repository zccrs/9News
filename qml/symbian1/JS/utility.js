.pragma library

function humandate(_dateline) {
    var thatday = new Date(_dateline * 1000);
    var now = parseInt(new Date().valueOf() / 1000);
    var cha = now - _dateline;
    if (cha < 180) {
        return qsTr("Just now");
    } else if (cha < 3600) {
        return Math.floor(cha / 60) + qsTr("minutes ago");
    } else if (cha < 86400) {
        return Math.floor(cha / 3600) + qsTr("hours ago");
    } else if (cha < 172800) {
        return qsTr("Yesterday ") + thatday.getHours() + ":" + thatday.getMinutes();
    } else if (cha < 259200) {
        return qsTr("The day bofore yesterday ") + thatday.getHours() + ":" + thatday.getMinutes();
    } else if (cha < 345600) {
        return Math.floor(cha / 86400) + qsTr("days ago");
    } else {
        return thatday.getFullYear() + "-" + (thatday.getMonth() + 1) + "-" + thatday.getDate();
    }
}
