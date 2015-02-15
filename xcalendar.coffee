xday = new ReactiveVar(moment())
xcalendarId = new ReactiveVar(null)
#eventDom = []

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

Template.xcalendarInner.events
  'click #plusWeek': (e, t) ->
    xday.set xday.get().add(7, 'days')
  'click #minusWeek': (e, t) ->
    xday.set xday.get().add(-7, 'days')
  'click .day-slot': (e,t)->
    if $(e.target).hasClass('day-slot')
      date_txt = $(e.target).attr('date')
      date = moment(date_txt, 'YYYY-MM-DD HH:mm').toDate()
      if not xevent.findOne(date:date)
        xCalendar.onDayClick({date:date, calendarId: xcalendarId.get()})

slots = (ini, end, interval)->
  ret = []
  ini = ini.split(':')
  end = end.split(':')
  ini = moment().hour(ini[0]).minute(ini[1]).startOf('minute')
  end = ini.clone().hour(end[0]).minute(end[1]).startOf('minute')
  while ini.isBefore(end)
    ret.push ini.format('HH:mm')
    ini.add(interval, 'minutes')
  return ret


#Tracker.autorun ->
#  _id = xcalendarId.get()
#  if _id
#    calendar = xcalendar.findOne(_id)
#    slotIni = calendar.slotIni
#    slotEnd = calendar.slotEnd
#    duration = calendar.duration

Template.xcalendar.helpers
  calendarSelected: -> if xcalendarId.get() then true else false
Template.xcalendarInner.helpers
  head: ->
    ret = ['']
    for i in [1..5]
      m = xday.get().clone().day(i).format('YYYY-MM-DD')
      ret.push m
    ret
  slot: -> slots(slotIni, slotEnd, duration) #slots('09:00','12:00',30)
  day: (slot)->
    slot = slot.split(':')
    hour = parseInt(slot[0])
    minute = parseInt(slot[1])
    ret = []
    for i in [1..5]
      m = xday.get().clone().day(i).hour(hour).minute(minute).format('YYYY-MM-DD HH:mm')
      ret.push m
    return ret

  xevent: (calendarId) ->
    #for eventD in eventDom
    #  Blaze.remove eventD
    #eventDom = []
    #template = this.template
    ret = xevent.find().fetch()
    for event in ret
      #event.content = render(event)
      m = moment(event.date)
      time = m.format('HH:mm')
      row = 0
      for slot, i in slots(slotIni, slotEnd, duration) # slots('09:00','12:00',30)
        if slot == time
          row = i
          break
      col = m.day()

      parent = $('#' + calendarId + ' tr:eq(' + row + ') td:eq(' + col + ')')#[0]
      #eventDom.push Blaze.renderWithData(Template[template], event, parent)
    #return null
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


