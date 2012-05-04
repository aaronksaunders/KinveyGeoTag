#!/bin/sh

# This is a simple script that just seeds some geodata to your backend using
# curl.  To run this script, just do ./seedData.sh from the project directory
# Note that you'll need to escape any single quotes in your notes other
# wise you'll get errors

# This is some restaurant data from Sydney Austrailia from Google Places
# (Powered by Google!) Xcode's debugger lets you set the simulator to Sydney

# To use this with the sample app, just replace app-key with your app-key
# Replace master-secret with your master secret
# Replace '{"note":"Darling Harbour","_geoloc":[151.198518,-33.871149]}'
#   with your note and it's location

# Each entry is 3 lines, there can be no space after the '\' at the end

curl --user app-key:master-secret \
    -H "Content-Type: application/json" -X POST -d '{"note":"Darling Harbour","_geoloc":[151.198518,-33.871149]}' \
    https://baas.kinvey.com/appdata/app-key/mapNotes/

curl --user app-key:master-secret \
    -H "Content-Type: application/json" -X POST -d '{"note":"Cruising Restaurants Of Sydney","_geoloc":[151.201636,-33.867798]}' \
    https://baas.kinvey.com/appdata/app-key/mapNotes/

curl --user app-key:master-secret \
    -H "Content-Type: application/json" -X POST -d '{"note":"Crinitis Darling Harbour","_geoloc":[151.198782,-33.872197]}' \
    https://baas.kinvey.com/appdata/app-key/mapNotes/

curl --user app-key:master-secret \
    -H "Content-Type: application/json" -X POST -d '{"note":"Al Ponte Harbour View Restaurant","_geoloc":[151.198955,-33.871467]}' \
    https://baas.kinvey.com/appdata/app-key/mapNotes/

curl --user app-key:master-secret \
    -H "Content-Type: application/json" -X POST -d '{"note":"Kazbah","_geoloc":[151.201523,-33.86887]}' \
    https://baas.kinvey.com/appdata/app-key/mapNotes/

curl --user app-key:master-secret \
    -H "Content-Type: application/json" -X POST -d '{"note":"JBs Bar & Grill","_geoloc":[151.198518,-33.871149]}' \
    https://baas.kinvey.com/appdata/app-key/mapNotes/
