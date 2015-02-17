xCalendar.publishWeekEvents = (children) ->
  Meteor.publishComposite 'weekEvents', (calendarId, date) ->
    m = moment(date)
    d1 = m.clone().day(0).startOf('day').toDate()
    d2 = m.clone().day(7).startOf('day').toDate()
    return {
    find: -> xevent.find({calendarId: calendarId, date: {$gte: d1, $lt: d2}})
    children: children
    }