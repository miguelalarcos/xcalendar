Meteor.publish 'weekEvents', (calendarId, date) ->
  m = moment(date)
  d1 = m.clone().day(1).startOf('day').toDate()
  d2 = m.clone().day(8).startOf('day').toDate()
  xevent.find({calendarId: calendarId, date: {$gte: d1, $lt: d2}})