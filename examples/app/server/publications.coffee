Meteor.publish 'patients', ->
  patient.find({})

Meteor.publish 'calendars', ->
  xcalendar.find({})