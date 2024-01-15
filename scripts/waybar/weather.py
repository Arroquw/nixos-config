#!/usr/bin/env nix-shell
#!nix-shell -i python -p python3 python310Packages.hjson python310Packages.requests

"""
Weather script for Waybar.
"""

from datetime import datetime
import json
import requests

WEATHER_CODES = {
    "113": "☀️",
    "116": "⛅",
    "119": "☁️",
    "122": "☁️",
    "143": "☁️",
    "176": "🌧️",
    "179": "🌧️",
    "182": "🌧️",
    "185": "🌧️",
    "200": "⛈️ ",
    "227": "🌨️",
    "230": "🌨️",
    "248": "☁️ ",
    "260": "☁️ ",
    "263": "🌧️",
    "266": "🌧️",
    "281": "🌧️",
    "284": "🌧️",
    "293": "🌧️",
    "296": "🌧️",
    "299": "🌧️",
    "302": "🌧️",
    "305": "🌧️",
    "308": "🌧️",
    "311": "🌧️",
    "314": "🌧️",
    "317": "🌧️",
    "320": "🌨️",
    "323": "🌨️",
    "326": "🌨️",
    "329": "❄️ ",
    "332": "❄️ ",
    "335": "❄️ ",
    "338": "❄️ ",
    "350": "🌧️",
    "353": "🌧️",
    "356": "🌧️",
    "359": "🌧️",
    "362": "🌧️",
    "365": "🌧️",
    "368": "🌧️",
    "371": "❄️",
    "374": "🌨️",
    "377": "🌨️",
    "386": "🌨️",
    "389": "🌨️",
    "392": "🌧️",
    "395": "❄️ ",
}

data = {}


weather = requests.get("https://wttr.in/Haarsteeg?format=j1").json()
# print(weather)


def format_time(time):
    """
    Format time.
    """
    return time.replace("00", "").zfill(2)


def format_temp(field):
    """
    Format temperature.
    """
    return (hour[field] + "°").ljust(3)


def format_chances(hour):
    """
    Format chances.
    """
    chances = {
        "chanceoffog": "Fog",
        "chanceoffrost": "Frost",
        "chanceofovercast": "Overcast",
        "chanceofrain": "Rain",
        "chanceofsnow": "Snow",
        "chanceofsunshine": "Sunshine",
        "chanceofthunder": "Thunder",
        "chanceofwindy": "Wind",
    }
    conditions = []
    for key, value in chances.items():
        if int(hour[key]) > 0:
            conditions.append(value + " " + hour[key] + "%")
    return ", ".join(conditions)


data["text"] = (
    WEATHER_CODES[weather["current_condition"][0]["weatherCode"]]
    + " "
    + weather["current_condition"][0]["FeelsLikeC"]
    + "°"
)

data["tooltip"] = (
    f"<b>"
    f"{weather['current_condition'][0]['weatherDesc'][0]['value']} "
    f"{weather['current_condition'][0]['temp_C']}°C</b>\n"
)
data["tooltip"] += f"Feels like: {weather['current_condition'][0]['FeelsLikeC']}°C\n"
data["tooltip"] += f"Wind: {weather['current_condition'][0]['windspeedKmph']}Km/h\n"
data["tooltip"] += f"Humidity: {weather['current_condition'][0]['humidity']}%\n"
for i, day in enumerate(weather["weather"]):
    data["tooltip"] += "\n<b>"
    if i == 0:
        data["tooltip"] += "Today, "
    if i == 1:
        data["tooltip"] += "Tomorrow, "
    data["tooltip"] += f"{day['date']}</b>\n"
    data["tooltip"] += f"⬆️ {day['maxtempC']}° ⬇️ {day['mintempC']}° "
    data[
        "tooltip"
    ] += f"🌅 {day['astronomy'][0]['sunrise']} 🌇 {day['astronomy'][0]['sunset']}\n"
    for hour in day["hourly"]:
        if i == 0:
            if int(format_time(hour["time"])) < datetime.now().hour - 2:
                continue
        data["tooltip"] += (
            f"{format_time(hour['time'])} "
            f"{WEATHER_CODES[hour['weatherCode']]} "
            f"{format_temp('tempC')} "
            f"{format_temp('FeelsLikeC')} "
            f"{hour['weatherDesc'][0]['value']}, "
            f"{format_chances(hour)}\n"
        )


print(json.dumps(data))
