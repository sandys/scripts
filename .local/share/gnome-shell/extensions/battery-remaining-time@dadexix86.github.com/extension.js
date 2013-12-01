/*
 * Gnome Shell Extension: battery-remaining-time
 *
 * Copyright © 2012 Davide Alberelli <dadexix86@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Alternatively, you can redistribute and/or modify this program under the
 * same terms that the “gnome-shell” or “gnome-shell-extensions” software
 * packages are being distributed by The GNOME Project.
 *
 */

const St = imports.gi.St;
const Lang = imports.lang;
const Status = imports.ui.status;
const Panel = imports.ui.panel;
const Main = imports.ui.main;
const Myself = imports.misc.extensionUtils.getCurrentExtension();
const Convenience = Myself.imports.convenience;

function init() {
}

const SETTING_SHOW_ICON='showicon';
const SETTING_SHOW_ARROW_ON_CHARGE='showarrowoncharge';
const SETTING_SHOW_PERCENTAGE='showpercentage';
const SETTING_SHOW_TIME='showtime';
const SETTING_SHOW_ON_CHARGE='showoncharge';
const SETTING_SHOW_ON_FULL='showonfull';
const SETTING_DEBUG='debug';

let settings = Convenience.getSettings('org.gnome.shell.extensions.battery-remaining-time');
let debug = Convenience.getSettings().get_boolean(SETTING_DEBUG);

function monkeypatch(batteryArea) {

    // add a method to the original power indicator that replaces the single
    // icon with the combo icon/label(s); this is dynamically called the first time
    // a battery is found in the _updateLabel() method
    
    let showIcon, showArrowOnCharge, showPercentage, showOnCharge, showTime, showOnFull;
    
    batteryArea._setParameters = function setParameters(){
        if (debug){
            global.log("Updating parameters");
        }
        showIcon = Convenience.getSettings().get_boolean(SETTING_SHOW_ICON);
        showArrowOnCharge = Convenience.getSettings().get_boolean(SETTING_SHOW_ARROW_ON_CHARGE);
        showPercentage = Convenience.getSettings().get_boolean(SETTING_SHOW_PERCENTAGE);
        showTime = Convenience.getSettings().get_boolean(SETTING_SHOW_TIME);
        showOnCharge = Convenience.getSettings().get_boolean(SETTING_SHOW_ON_CHARGE);
        showOnFull = Convenience.getSettings().get_boolean(SETTING_SHOW_ON_FULL);
    }
    
    batteryArea._replaceIconWithBox = function replaceIconWithBox() {
        if (this._withLabel)
            return;
        this._withLabel = true;

        let icon = this.actor.get_children()[0];

        // remove the initial actor of the single icon
        this.actor.remove_actor(icon);

        // create a new box layout, composed of a) a "bin", b) the label
        let box = new St.BoxLayout({ name: 'batteryBox' });
        this.actor.add_actor(box);

        // create the bin and eventually put the original icon into it
        let iconBox = new St.Bin();
        iconBox.child = icon;
        if (showIcon) {
            box.add(iconBox, { y_align: St.Align.MIDDLE, y_fill: false });
        }

        this._label = new St.Label();
        box.add(this._label, { y_align: St.Align.MIDDLE, y_fill: false });

    };

    // do the exact opposite: replace the box with the original icon and
    // destroy the bin/box. i.e. revert the original behavior, useful
    // when disabling the extension :-)
    batteryArea._replaceBoxWithIcon = function replaceBoxWithIcon() {
        if (!this._withLabel)
            return;
        this._withLabel = false;

        let box = this.actor.get_children()[0];
        let bin = box.get_children()[0];
        let label = box.get_children()[1];
        let icon = bin.child;

        this.actor.remove_actor(box);
        icon.reparent(this.actor);

        label.destroy();
        bin.destroy();
        box.destroy();
    }
    
    // now, we must ensure that our time label is updated
    // hence, create a function that enumerates the devices and, if one or more
    // batteries are found, updates the label with the time remaining
    batteryArea._updateLabel = function updateLabel() {
        this._proxy.GetDevicesRemote(Lang.bind(this, function(devices, error) {
            if (error) {
                if (this._withLabel) {
                    this._label.set_text("");
                }
                return;
            }

            let results, totalMatch, totalTime, totalPercentage, totalCharging, arrow;
            
            batteryArea._setParameters();
            batteryArea._replaceIconWithBox();
            totalTime = -1;
            
            [results]=devices;
            if(debug){
                global.log("devices = " + devices.toString());
            }
            
            for (let i = 0; i < results.length; i++) {
                let [device_id, device_type, icon, percent, charging, seconds] = results[i];
                
                if(debug){
                    global.log("results[" + i.toString() + "] = " + results[i].toString());
                }
                
                if (device_type != Status.power.UPDeviceType.BATTERY)
                    continue;

                if (totalTime < 0){
                    totalTime = seconds;
                    totalPercentage = Math.round(percent);
                    totalCharging = charging;
                    if(debug){
                        global.log("first battery");
                    }
                } else {// If there is more than one battery we sum up
                    totalTime = totalTime + seconds;
                    totalPercentage = Math.round((totalPercentage + percent)/2);
                    totalCharging = Math.min(totalCharging, charging);
                    if(debug){
                        global.log("more than one battery");
                    }
                }

                totalMatch = [totalTime,totalPercentage,totalCharging];
                if (debug){
                    global.log("Intermediate totalMatch: " + totalMatch.toString());
                }
                
            }

            if (debug){
                global.log("Final totalMatch:" + totalMatch.toString());
            }
            
            this.displayString = ' ';
            
            if (totalMatch[0] > 60){
                let time = Math.round(totalMatch[0] / 60);
                let minutes = time % 60;
                let hours = Math.floor(time / 60);
                this.timeString = C_("battery time remaining","%d:%02d").format(hours,minutes);
            } else {
                this.timeString = '-- ';
            }
             
            let arrow;

            if (showArrowOnCharge)
                arrow = decodeURIComponent(escape('↑ ')).toString();
            else
                arrow = ' ';

            if (totalMatch[2] == 1){
                if(!showOnCharge)
                    hideBattery();
                else{
                    this.displayString = arrow;
                    if (showPercentage)
                        this.displayString = this.displayString + totalMatch[1].toString() + '%';
                    if (showTime)
                        this.displayString = this.displayString + ' (' + this.timeString + ')';
                    showBattery();
                }
            } else {
                if (totalMatch[2] == 4){
                    if (!showOnFull)
                        hideBattery();
                    else {
                        this.timeString = decodeURIComponent(escape('∞'));
                        this.displayString = ' ';
                        if (showPercentage)
                            this.displayString = this.displayString + '100%';
                        if (showTime)
                            this.displayString = this.displayString + ' (' + this.timeString + ')';
                        showBattery();
                    }
                } else {
                    this.displayString = ' ';
                    if (showPercentage)
                        this.displayString = this.displayString + totalMatch[1].toString() + '%';
                    if (showTime)
                        this.displayString = this.displayString + ' (' + this.timeString + ')';
                }
            }
            
            if (debug){
                global.log("displayString:" + this.displayString.toString());
            }

            if (!this._withLabel) {
                this._replaceIconWithBox();
            }
            
            this._label.set_text(this.displayString);
        }));
    };
}

function hideBattery() {
    for (var i = 0; i < Main.panel._rightBox.get_children().length; i++) {
        if (Main.panel._statusArea['battery'] == 
            Main.panel._rightBox.get_children()[i]._delegate ||
            Main.panel._statusArea['batteryBox'] == 
            Main.panel._rightBox.get_children()[i]._delegate) {
            if (debug){
                global.log("Battery Remaing Time: hiding battery.");
            }
            Main.panel._rightBox.get_children()[i].hide();
            break;
        }
    }
}

function showBattery() {
    for (var i = 0; i < Main.panel._rightBox.get_children().length; i++) {
        if (Main.panel._statusArea['battery'] == 
            Main.panel._rightBox.get_children()[i]._delegate ||
            Main.panel._statusArea['batteryBox'] == 
            Main.panel._rightBox.get_children()[i]._delegate) {
            if (debug){
                global.log("Battery Remaing Time: showing battery.");
            }
            Main.panel._rightBox.get_children()[i].show();
            break;
        }
    }
}

function enable() {
    // monkey-patch the existing battery icon, called "batteryArea" henceforth
    let batteryArea = Main.panel._statusArea['battery'];
    if (!batteryArea){
        if (debug){
            global.log("No battery Area!");
        }
        return;
    }

    monkeypatch(batteryArea);

    // hook our extension to the signal and do the initial update
    batteryArea._labelSignalId = batteryArea._proxy.connect('g-properties-changed', Lang.bind(batteryArea, batteryArea._updateLabel));
    batteryArea._setParameters();
    batteryArea._updateLabel();                 
}

function disable() {
    let batteryArea = Main.panel._statusArea['battery'];
    if (!batteryArea){
        return;
    }

    try {
        if (batteryArea._labelSignalId) {
            batteryArea._proxy.disconnect(batteryArea._labelSignalId);
        }
        batteryArea._replaceBoxWithIcon();
    } finally {
        delete batteryArea._replaceIconWithBox;
        delete batteryArea._replaceBoxWithIcon;
        delete batteryArea._updateLabel;
        delete batteryArea._labelSignalId;
        delete batteryArea._label;
        delete batteryArea._withLabel;
        delete batteryArea._setParameters;
    }
}

