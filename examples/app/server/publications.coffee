Meteor.publish 'patients', ->
  patient.find({})

Meteor.publish 'calendars', ->
  xcalendar.find({})

publishWeekEvents [
  find: (event) -> patient.find event.patientId
  ]