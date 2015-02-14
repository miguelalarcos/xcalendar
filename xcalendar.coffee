xday = new ReactiveVar(moment())
@xcalendarId = new ReactiveVar(null)

waitForCalendarEvents = (calendarName) -> Meteor.subscribe 'weekEvents', calendarName, xday.get().toDate()

Template.xcalendar.events
  'click #plusWeek': (e, t) ->
    xday.set xday.get().add(7, 'days')
  'click #minusWeek': (e, t) ->
    xday.set xday.get().add(-7, 'days')
  'click .day-slot': (e,t)->
    atts = t.data
    date_txt = $(e.target).attr('date')
    date = moment(date_txt, 'YYYY-MM-DD HH:mm').toDate()
    if not xevent.findOne(date:date) #hacer esta comprobación tb en un deny en el server
      data = window[atts.callback]()
      dct = {date:date}
      _.extend(dct, data)
      xevent.insert(dct)


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

slotIni = null
slotEnd = null
duration = null
Tracker.autorun ->
  _id = xcalendarId.get()
  if _id
    calendar = xcalendar.findOne(_id)
    slotIni = calendar.slotIni
    slotEnd = calendar.slotEnd
    duration = calendar.duration

Template.xcalendar.helpers
  calendarSelected: -> if xcalendarId.get() then true else false
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
    render = window[this.renderfunction]
    for event in xevent.find().fetch()
      content = render(event)
      m = moment(event.date)
      time = m.format('HH:mm')
      row = 0
      for slot, i in slots(slotIni, slotEnd, duration)
        if slot == time
          row = i
          break
      col = m.day()

      el = $('#' + calendarId + ' tr:eq(' + row + ') td:eq(' + col + ')')
      el.css({'background-color': 'green'})

    return null
  xxevent: (calendarId) ->
    render = window[this.renderfunction]
    ret = xevent.find().fetch()
    for event in ret
      event.content = render(event)
      m = moment(event.date)
      time = m.format('HH:mm')
      row = 0
      for slot, i in slots(slotIni, slotEnd, duration) # slots('09:00','12:00',30)
        if slot == time
          row = i
          break
      col = m.day()

      position = $('#' + calendarId + ' tr:eq(' + row + ') td:eq(' + col + ')').position()
      if position
        left = position.left
        top = position.top
      else
        left = 0
        top = 0
      event.style = 'position: absolute; left: ' + left + 'px; top: ' + top + 'px;'
    return ret

#Template.xcalendar.rendered = ->
#  _id = xevent.insert(date: new Date(), text: 'dummy', calendarId: 'dummy', patientId:'dummy')
#  xevent.remove(_id)


