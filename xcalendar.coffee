xday = new ReactiveVar(moment.utc())
xcalendarId = new ReactiveVar(null)
isWeekView = new ReactiveVar(true)

xCalendar.insert = (data) ->
  data.calendarId = xcalendarId.get()
  xevent.insert(data)
xCalendar.update = (_id, data) -> xevent.update _id, {$set: data}
xCalendar.remove = (_id)-> xevent.remove _id

slotIni = new ReactiveVar(null)
slotEnd = new ReactiveVar(null)
duration = new ReactiveVar(null)
days = new ReactiveVar(null)

xCalendar.waitForCalendarEvents = -> Meteor.subscribe 'weekEvents', xcalendarId.get(), xday.get().toDate()
xCalendar.setCalendar = (_id) ->
  calendar = xcalendar.findOne(_id)
  slotIni.set calendar.slotIni
  slotEnd.set calendar.slotEnd
  duration.set calendar.duration
  days.set calendar.days
  xcalendarId.set _id

Template.xCalendarButtonPlus.events
  'click button': (e, t) ->
    xday.set xday.get().add(7, 'days')
Template.xCalendarButtonMinus.events
  'click button': (e, t) ->
    xday.set xday.get().add(-7, 'days')
Template.xCalendarButtonToday.events
  'click button': (e,t)->
    xday.set moment.utc()
Template.xCalendarButtonChangeView.events
  'click button': (e,t) ->
    isWeekView.set not isWeekView.get()
Template.xCalendarButtonMinusDay.events
  'click button': (e,t) -> xday.set xday.get().add(-1, 'days')
Template.xCalendarButtonPlusDay.events
  'click button': (e,t) -> xday.set xday.get().add(1, 'days')


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

Template.xCalendarButtonChangeView.helpers
  caption: -> if isWeekView.get() then 'Day view' else 'Week view'

Template.xcalendar.helpers
  calendarSelected: -> if xcalendarId.get() then true else false
  xcalendarId: -> xcalendarId.get()

Template.xCalendarInnerDay.helpers
  existsAppointment: (slot)->
    day = xday.get().clone().local().format('YYYY-MM-DD')
    d = moment(day + ' ' + slot, 'YYYY-MM-DD HH:mm').toDate()
    xevent.findOne(date:d)
  slot: -> slots(slotIni.get(), slotEnd.get(), duration.get())
  top: ->
    calendar: xcalendar.findOne(xcalendarId.get()).name
    date: xday.get()
  xevent: (slot) ->
    day = xday.get().clone().local().format('YYYY-MM-DD')
    d = moment(day + ' ' + slot, 'YYYY-MM-DD HH:mm').toDate()
    {doc: xevent.findOne(date:d), slot: slot}

Template.xcalendarInner.helpers
  existsAppointment: (m)->
    d = m.toDate()
    xevent.findOne(date:d)
  isWeekView: -> isWeekView.get()
  top: ->
    calendar: xcalendar.findOne(xcalendarId.get()).name
    date: xday.get()
  head: ->
    ret = ['']
    for i in days.get()
      m = xday.get().clone().day(i).startOf('day')
      ret.push m
    ret
  slot: -> slots(slotIni.get(), slotEnd.get(), duration.get())
  day: (slot)->
    slot = slot.split(':')
    hour = parseInt(slot[0])
    minute = parseInt(slot[1])
    ret = []
    for i in days.get()
      m = xday.get().clone().local().day(i).hour(hour).minute(minute).startOf('minute')
      ret.push m
    return ret
  xevent: (m) ->
    d = m.toDate()
    xevent.findOne(date:d)
