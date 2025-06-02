+++
title = 'GeoDistance - Digits'
date = 2024-07-05
draft = false
weight = 1

[params]
    author = 'Kris Thompson'
+++

## Geodistance Precision

What is the distance between points. How many digits of accuracy to put on my location records.

Let's look with the GeoDesic library in Python.

### The Function

First, the function:

```python
import pandas as pd
from geopy.distance import geodesic

def geodist(lat1, lon1, lat2, lon2):
    coords = pd.Series([lat1, lon1, lat2, lon2])
    if coords.isnull().values.any():
        return None
    return round(geodesic((lat1, lon1), (lat2, lon2)).km, 5)
```

### The Test

Using this python cell, we can generate distance based on the last digit; 5th or 6th decimal place.

```python
lat1, lon1 = [-29.912948,-51.18651]
lat2, lon2 = [-29.912948,-51.18650]
dist5 = geodist(lat1, lon1, lat2, lon2) * 1000

lat1, lon1 = [-29.912948,-51.18651]
lat2, lon2 = [-29.912949,-51.18651]
dist6 = geodist(lat1, lon1, lat2, lon2) * 1000

# print meters
print(round(dist5,2)) # 0.97m
print(round(dist6,2)) # 0.11m
```

### The Results

Approximately:

* a five (5) decimal point value can convey one (1) meter of accuracy
* a six (6) decimal point  value can convey ten (10) centimeters of accuracy

The impact of the final digit will vary depending of global location. Your mileage may vary.

### The Conclusion

Processing more than 5 of 6 decimal places is a waste of time and effort. Many GPS devices will more limited accuracy as well.

