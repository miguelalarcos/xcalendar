xday = new ReactiveVar(moment.utc())
xcalendarId = new ReactiveVar(null)

xCalendar.insert = (data) ->
  data.calendarId = xcalendarId.get()
  xevent.insert(data)
xCalendar.update = (_id, data) -> xevent.update _id, {$set: data}
xCalendar.remove = (_id)-> xevent.remove _id

slotIni = null
slotEnd = null
duration = null

xCalendar.waitForCalendarEvents = -> Meteor.subscribe 'weekEvents', xcalendarId.get(), xday.get().toDate()
xCalendar.setCalendar = (_id) ->
  calendar = xcalendar.findOne(_id)
  slotIni = calendar.slotIni
  slotEnd = calendar.slotEnd
  duration = calendar.duration
  xcalendarId.set _id

Template.xCalendarButtonPlus.events
  'click #plusWeek': (e, t) ->
    xday.set xday.get().add(7, 'days')
Template.xCalendarButtonMinus.events
  'click #minusWeek': (e, t) ->
    xday.set xday.get().add(-7, 'days')
Template.xCalendarButtonToday.events
  'click #xCalendarToday': (e,t)->
    xday.set moment.utc()

slots = (ini, end, interval)->
  ret = []
  ini = ini.split(':')
  end = end.split(':')
  ini = moment.utc().hour(ini[0]).minute(ini[1]).startOf('minute')
  end = ini.clone().hour(end[0]).minute(end[1]).startOf('minute')
  while ini.isBefore(end)
    ret.push ini.format('HH:mm')
    ini.add(interval, 'minutes')
  return ret


Template.xcalendar.helpers
  calendarSelected: -> if xcalendarId.get() then true else false

Template.xcalendarInner.helpers
  top: ->
    calendar: xcalendar.findOne(xcalendarId.get()).name
    date: xday.get()
  head: ->
    ret = ['']
    for i in [1..5]
      m = xday.get().clone().day(i).startOf('day')
      ret.push m
    ret
  slot: -> slots(slotIni, slotEnd, duration)
  day: (slot)->
    slot = slot.split(':')
    hour = parseInt(slot[0])
    minute = parseInt(slot[1])
    ret = []
    for i in [1..5]
      m = xday.get().clone().local().day(i).hour(hour).minute(minute).startOf('minute')#.format('YYYY-MM-DD HH:mm')
      ret.push m
    return ret

  xevent: (calendarId) ->
    ret = xevent.find().fetch()
    for event in ret
      m = moment(event.date)
      time = m.format('HH:mm')
      row = 0
      for slot, i in slots(slotIni, slotEnd, duration) # slots('09:00','12:00',30)
        if slot == time
          row = i
          break
      col = m.day()

      parent = $('#' + calendarId + ' tr:eq(' + row + ') td:eq(' + col + ')')#[0]

      position = parent.position()
      if position
        left = position.left
        top = position.top
      else
        left = 0
        top = 0
      event.style = 'position: absolute; left: ' + left + 'px; top: ' + top + 'px;'
    return ret

Template.xcalendarInner.rendered = ->
  evento = xevent.findOne()
  if evento
    _id = evento._id
    text = evento.text
    xevent.update(_id, {$set: {text: text + '.'}})
    xevent.update(_id, {$set: {text: text }})


