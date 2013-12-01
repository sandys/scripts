/*
 * Copyright (C) 2012 Thiago Bellini <hackedbellini@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 * Most of this code was forked from media-player-indicator:
 *   https://extensions.gnome.org/extension/55/media-player-indicator/
 *
 */

const Gtk = imports.gi.Gtk;
const Lang = imports.lang;

const Gettext = imports.gettext.domain('battery-remaining-time');
const _ = Gettext.gettext;

const Convenience = imports.misc.extensionUtils.getCurrentExtension().imports.convenience;

let settings;
let boolSettings;

function _createBoolSetting(setting) {
  let hbox = new Gtk.Box({orientation: Gtk.Orientation.HORIZONTAL});

  let settingLabel = new Gtk.Label({label: boolSettings[setting].label,
                                    xalign: 0});

  let settingSwitch = new Gtk.Switch({active: settings.get_boolean(setting)});
  settingSwitch.connect('notify::active', function(button) {
    settings.set_boolean(setting, button.active);
  });

  if (boolSettings[setting].help) {
    settingLabel.set_tooltip_text(boolSettings[setting].help);
    settingSwitch.set_tooltip_text(boolSettings[setting].help);
  }

  hbox.pack_start(settingLabel, true, true, 0);
  hbox.add(settingSwitch);

  return hbox;
}

/*
   Shell-extensions handlers
*/

function init() {
  let schema = 'org.gnome.shell.extensions.battery-remaining-time';
  settings = Convenience.getSettings(schema);

  boolSettings = {
    showarrowoncharge: {
      label: _("Show the arrow."),
      help: _("Show or hide the arrow near the text when charging. (default: ON)")
    },
    showpercentage: {
      label: _("Show the percentage."),
      help: _("Show or hide the percentage near the time. (default: ON)")
    },
    showtime: {
      label: _("Show the time."),
      help: _("Show or hide the time near the icon. (default: ON)")
    },
    showoncharge: {
      label: _("Show when charging."),
      help: _("Show or hide at all when charging. (default: ON)")
    },
    showonfull: {
      label: _("Show when full."),
      help: _("Show or hide at all when full. (default: ON)")
    },
    showicon: {
      label: _("Show the icon. Needs reload."),
      help: _("Show or hide the icon near the text. (default: ON)")
    },
    debug: {
      label: _("Debug mode. Needs reload."),
      help: _("Show or hide debug messages in Looking Glass. (default: OFF)")
    },
  };
}

function buildPrefsWidget() {
  let frame = new Gtk.Box({orientation: Gtk.Orientation.VERTICAL,
                           border_width: 10});
  let vbox = new Gtk.Box({orientation: Gtk.Orientation.VERTICAL,
                          margin: 20, margin_top: 10});

  // Add all bool settings
  for (setting in boolSettings) {
    let hbox = _createBoolSetting(setting);
    vbox.add(hbox);
  }

  frame.add(vbox);
  frame.show_all();

  return frame;
}
