# Spaceweather

## A. Summary

Retrieves spaceweather measurements from various sources (eg: ACE, NOAA). Current measurements:

- ACE IMF Magnetometer Bz
- ACE Solar Wind Speed
- ACE Particle Density
- Wing Kp Index
- Solar Wind ETA (based on ACE Solar Wind Speed)

## B. Dependencies

The following binaries are required:

1) bc

2) wget

These dependencies are widely available for almost every Linux/BSD distro.

## C. Supported Systems

This should work on any system with BASH 4 or later.

### Installation

1. Clone this repo to your preferred directory (eg: /opt/spaceweather)

  `git clone https://github.com/curtis86/spaceweather`


### Usage

```
Usage: spaceweather <measurement> <options>
Options:
--help     shows this usage info
--verbose  prints verbose output

Measurements:
m_ace_magnetometer_bz
m_ace_particle_density
m_ace_solar_wind_eta
m_ace_solar_wind_speed
m_wing_kp_index
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

From time to time, data measurements by ACE can include a bad or missing data record. In this case, the measurement will return 9999.

## Disclaimer

I'm not a programmer, but I do like to make things! Please use this at your own risk.

## Thanks

Big thanks to NASA and NOAA for making this data so easily available at such high frequencies.

## License

The MIT License (MIT)

Copyright (c) 2015 Curtis K

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
