{ config, pkgs, ... }:

let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    requests
    yt-dlp
    caldav
    slixmpp
  ]);

  dailyInfo = pkgs.writeText "main.py" ''
# -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
# Libraries
# -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
# News
import yt_dlp
# Calendar
import caldav
from datetime import datetime, date, timedelta
from zoneinfo import ZoneInfo
# Weather
import requests
# XMPP
import asyncio
from slixmpp import ClientXMPP

# -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
# Constants
# -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
# News
PLAYLIST_URL = "https://www.youtube.com/playlist?list=PLFLBjMW4wU7gYcRxzvIV9oAL7VIqmJbOW"
opts = {
    "extract_flat": True,
    "playlistend": 1,
    "quiet": True,
}

# Calendar
URL = "https://calendario.gabrielcachadina.com/"
USERNAME = "${config.globals.radicale_user}"
PASSWORD = "${config.globals.radicale_pass}"

tz = ZoneInfo("Europe/Madrid")
today = datetime.now(tz).date()
start = datetime.combine(today, datetime.min.time(), tzinfo=tz)
end = start + timedelta(days=1)

# Weather
URL_WEATHER = "https://api.open-meteo.com/v1/forecast"
params = {
    "latitude": 38.8779,
    "longitude": -6.9706,

    "daily": "sunrise,sunset",

    "hourly": (
        "temperature_2m,"
        "precipitation_probability,"
        "cloud_cover"
    ),

    # Badajoz local time
    "timezone": "Europe/Madrid",

    "forecast_days": 1,
}

# -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
# NEWS
# -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

PLAYLIST_URLS = [
    "https://www.youtube.com/playlist?list=PLFLBjMW4wU7gYcRxzvIV9oAL7VIqmJbOW",
    "https://www.youtube.com/playlist?list=PLZhRxE9191zPN4uc07ytohaXcS13qEgm2",
]

opts = {
    "extract_flat": True,
    "playlistend": 1,
    "quiet": True,
}

news_urls = []

with yt_dlp.YoutubeDL(opts) as ydl:
    for playlist_url in PLAYLIST_URLS:
        info = ydl.extract_info(playlist_url, download=False)

        latest = info["entries"][0]

        if latest and latest.get("id"):
            news_urls.append(
                f"https://www.youtube.com/watch?v={latest['id']}"
            )

result_news = "\n".join([
    "====================",
    "Noticias:",
    "====================",
    *news_urls,
    "",
])

print(result_news)


# -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
# CALENDAR
# -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
calendar_lines = []

with caldav.DAVClient(
    url=URL,
    username=USERNAME,
    password=PASSWORD,
    auth_type="basic",
) as client:

    principal = client.principal()

    calendar_lines.append("=" * 20)
    calendar_lines.append(
        f"Calendario"
    )
    calendar_lines.append("=" * 20)

    for calendar in principal.calendars():
        calendar_name = calendar.get_display_name()

        if calendar_name.upper() == "TODO":
            continue

        events = calendar.search(
            start=start,
            end=end,
            event=True,
            expand=True,
        )

        if not events:
            continue


        for event in events:
            component = event.icalendar_component

            for vevent in component.walk():
                if vevent.name != "VEVENT":
                    continue

                summary = str(vevent.get("SUMMARY", "Untitled"))
                dtstart = vevent.get("DTSTART")
                dtend = vevent.get("DTEND")

                if not dtstart:
                    continue

                start_value = dtstart.dt
                end_value = dtend.dt if dtend else None

                if isinstance(start_value, datetime):
                    start_value = start_value.astimezone(tz)

                    if end_value and isinstance(end_value, datetime):
                        end_value = end_value.astimezone(tz)

                    calendar_lines.append(
                        f"🕐 {start_value.strftime('%H:%M')}"
                        f"–{end_value.strftime('%H:%M') if end_value else '?'}"
                    )
                    calendar_lines.append(f"   {summary}")

                elif isinstance(start_value, date):
                    calendar_lines.append(f"☀️  {summary}")
                    calendar_lines.append("    All day")

                calendar_lines.append("")

result_calendar = "\n".join(calendar_lines)

print(result_calendar)

# -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
# Weather
# -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
response = requests.get(URL_WEATHER, params=params)
response.raise_for_status()

data = response.json()


hourly = data["hourly"]
times = hourly["time"]
temperatures = hourly["temperature_2m"]
rain_probability = hourly["precipitation_probability"]
cloud_cover = hourly["cloud_cover"]

# Daily Data
daily = data["daily"]
date = daily["time"][0]
sunrise = daily["sunrise"][0]
sunset = daily["sunset"][0]

# Min_Max Temperatures
temp_min = min(temperatures)
temp_max = max(temperatures)
min_index = temperatures.index(temp_min)
max_index = temperatures.index(temp_max)
min_time = times[min_index][11:16]
max_time = times[max_index][11:16]
# Get hours with significant temperature changes
hottest_temp = temperatures[max_index]
coldest_temp = temperatures[min_index]

# Rain
max_rain_probability = max(rain_probability)
if max_rain_probability == 0:
    rain_status = "No rain expected 🌧️❌"
elif max_rain_probability <= 20:
    rain_status = "Very low chance of rain 🌦️"
elif max_rain_probability <= 40:
    rain_status = "Low chance of rain 🌦️"
elif max_rain_probability <= 60:
    rain_status = "Moderate chance of rain 🌦️"
else:
    rain_status = "High chance of rain 🌧️"

# Sunshine
average_cloud = sum(cloud_cover) / len(cloud_cover)
if average_cloud <= 10:
    sunshine = "Very sunny ☀️"
elif average_cloud <= 30:
    sunshine = "Mostly sunny 🌤️"
elif average_cloud <= 60:
    sunshine = "Partly cloudy ⛅"
else:
    sunshine = "Mostly cloudy ☁️"

result_weather = f"""
====================
Tiempo
====================
🌡️  TEMPERATURE
   Minimum:           {temp_min:.1f} °C  at {min_time}
   Maximum:           {temp_max:.1f} °C  at {max_time}

☀️  SUNSHINE
   Conditions:        {sunshine}
   Average clouds:    {average_cloud:.1f}%
   Sunrise:           {sunrise[11:16]}
   Sunset:            {sunset[11:16]}

🌧️  RAIN
   Maximum chance:    {max_rain_probability}%
   Status:            {rain_status}
"""

print(result_weather)


# -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
# XMPP
# -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
result = "\n".join([
    result_news,
    result_calendar,
    result_weather
])

class XMPPClient(ClientXMPP):
    def __init__(self, jid, password, recipient, message):
        super().__init__(jid, password)

        self.recipient = recipient
        self.message = message

        self.add_event_handler("session_start", self.session_start)

        # XMPP errors
        self.add_event_handler("failed_auth", self.failed_auth)
        self.add_event_handler("connection_failed", self.connection_failed)
        self.add_event_handler("disconnected", self.disconnected_handler)
        self.add_event_handler("stanza_error", self.stanza_error)

    async def session_start(self, event):
        print("XMPP: session started", flush=True)

        self.send_presence()
        print("XMPP: presence sent", flush=True)

        await self.get_roster()
        print("XMPP: roster received", flush=True)

        self.send_message(
            mto=self.recipient,
            mbody=self.message,
            mtype="chat"
        )

        print("XMPP: message sent", flush=True)

        await asyncio.sleep(1)

        print("XMPP: disconnecting", flush=True)
        self.disconnect()

    def failed_auth(self, event):
        print("XMPP ERROR: authentication failed", flush=True)
        print(f"XMPP ERROR DETAILS: {event}", flush=True)
        self.disconnect()

    def connection_failed(self, event):
        print("XMPP ERROR: connection failed", flush=True)
        print(f"XMPP ERROR DETAILS: {event}", flush=True)

    def stanza_error(self, event):
        print("XMPP ERROR: stanza error", flush=True)
        print(f"XMPP ERROR DETAILS: {event}", flush=True)

    def disconnected_handler(self, event):
        print("XMPP: disconnected", flush=True)

async def main():
    client = XMPPClient(
        jid="bot@xmpp.gabrielcachadina.com",
        password="${config.globals.dailyinfo_XMPPbotPass}",
        recipient="gabriel@xmpp.gabrielcachadina.com",
        message=result
    )

    client.connect()
    await client.disconnected


if __name__ == "__main__":
    asyncio.run(main())
  '';

in
{
  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  # Daily Info
  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  systemd.services.daily-info = {
    description = "Send news, calendar and weather";

    serviceConfig = {
      Type = "oneshot";

      User = config.globals.username;

      ExecStart = "${pythonEnv}/bin/python ${dailyInfo}";
    };
  };

  systemd.timers.daily-info = {
    description = "Run daily info";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "7:00";
      Persistent = true;
    };
  };
}

