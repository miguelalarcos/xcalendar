xevent.deny
  insert: (userId, doc)->
    if xevent.findOne(calendarId: doc.calendarId, date: doc.date)
      true
    else
      false