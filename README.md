# Spaceweather

## A. Summary

Retrieves spaceweather measurements from various sources (eg: DSCOVR, ACE, WING). Current supported measurements:

- DSCOVR IMF Magnetometer Bz
- DSCOVR IMF Mangetometer Bt
- DSCOVR Plasma Particle Density
- DSCOVR Plasma Particle Speed
- ACE IMF Magnetometer Bz
- ACE Solar Wind Speed
- ACE Particle Density
- Wing Kp Index (Current, 1-hour and 4-hour forecast)
- Solar Wind ETA (based on ACE or DSCOVR Plasma Speed)

See some of the data in action at https://spaceweather.xyz/

**Note:** In July 2016, NOAA/SWPC switched from ACE to DSCOVR for space weather data. I would recommend doing the same.

## B. Dependencies

The following binaries are required:

1) bc

2) wget

These dependencies are widely available for almost every Linux/BSD distro.

## C. Supported Systems

This should work on any system with BASH 4 or later. Tested on CentOS Linux and OS X 10.11.16

### Installation

1. Clone this repo to your preferred directory (eg: /opt/spaceweather)

  `git clone https://github.com/curtis86/spaceweather`


### Usage

```
Usage: spaceweather <measurement> <options>

Options:
--help     shows this usage info
--verbose  prints verbose output
--update   updates datasources and exits

Supported measurements:

m_ace_magnetometer_bz
m_ace_particle_density
m_ace_solar_wind_eta
m_ace_solar_wind_speed
m_dscovr_magnetometer_bt
m_dscovr_magnetometer_bz
m_dscovr_plasma_density
m_dscovr_plasma_speed
m_dscovr_solar_wind_eta
m_wing_kp_four_hour_forecast
m_wing_kp_index
m_wing_kp_one_hour_forecast
```

### Sample output

```
# ./spaceweather m_ace_magnetometer_bz m_ace_particle_density m_ace_solar_wind_eta m_ace_solar_wind_speed m_wing_kp_index

m_ace_magnetometer_bz: -0.5
m_ace_particle_density: 1.6
m_ace_solar_wind_eta: 48
m_ace_solar_wind_speed: 518.1
m_wing_kp_index: 3.67
```

## Notes

From time to time, data measurements can include a bad or missing data record. In this case, the measurement will return 9999.

## Disclaimer

I'm not a programmer, but I do like to make things! Please use this at your own risk.

## Thanks

Big thanks to SWPC & NOAA for making this data so easily available at such high frequencies. Thanks to ACE (Advanced Composition Explorer) for all its hard work over the years!

## License

The MIT License (MIT)

Copyright (c) 2016 Curtis K

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
