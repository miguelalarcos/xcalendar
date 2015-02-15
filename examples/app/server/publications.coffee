Meteor.publish 'patients', ->
  patient.find({})

Meteor.publish 'calendars', ->
  xcalendar.find({})

xCalendar.publishWeekEvents [
  find: (event) -> patient.find event.patientId
  ]