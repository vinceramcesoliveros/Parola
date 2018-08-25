# PAROLA

[![Join the chat at https://gitter.im/IT180-Parola/Lobby](https://badges.gitter.im/IT180-Parola/Lobby.svg)](https://gitter.im/IT180-Parola/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Coverage Status](https://coveralls.io/repos/github/ram231/Parola/badge.svg?branch=master)](https://coveralls.io/github/ram231/Parola?branch=master)

  ### Current Progress: 12%
  - [✅] Bluetooth Low Energy using Flutter blue

  - [ PENDING ] Configure Beacons on Parola.

> There will be more features to be added next few days

### August 5 Notes.
- ✅ Login to Home Page
- ❌ Content of the Home Page
- ✅ Will use Firestore instead of Firebase Realtime Database
- ❌ Event Page
- ❌ Create Event
- ❌ Scan Page
- ❌ Description of Event Page
- ❌ Fixing Beacons

### August 7 Notes
- Re-organized the files to follow the principle of **"100 lines of code"**
- Still struggling for Data modeling in the Cloud firestore

### August 8 Notes
- Added Connectivity, to ensure that if a user has no internet connection, it will give a toast that it has no internet connection
- Added Images for the Event. Still under construction. Please bear with my effort.

### August 15 Notes
- Added Flutter Bluetooth just to test out the connection of the beacon.
- Reinvent the architecture for enabling beacon, I should minimize the usage of SetState method.

### August 18 Notes
- Display the properties of the beacon to scan devices. I will need to work out for this one.

UUID | Major | Minor
------------ | -------------|-------------|
23A01AF0-232A-4518-9C0E-323FB773F5EF|0xACE6|0x51F0
