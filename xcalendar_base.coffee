xCalendar = {}
xCalendar.onDayClick = ->
xCalendar.insert = (data) -> xevent.insert(data)
xCalendar.update = (_id, data) -> xevent.update _id, {$set: data}
xCalendar.remove = (_id)-> xevent.remove _id