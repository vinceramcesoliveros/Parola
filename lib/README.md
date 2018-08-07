# SQL STATEMENTS TO NoSQL Statements

## Users
> Select all events for users
1. `Select eventName,eventDesc,eventDate,eventLocation from events`

> 
## Events
> Select all number of attendees from an event
1. `Select count(users.userid) from eventAttendees`

> When a user creates an event, We want to get the URL, event name, etc. 
1. `INSERT INTO event values (eventID,BeaconUUID,Major,Minor,...)`

> 
## Organizations
> It's just a description when the user clicks the author
1. `Select OrgName where eventName = ''`
