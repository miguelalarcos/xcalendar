xday = new ReactiveVar(moment())
@xcalendarId = new ReactiveVar(null)

waitForCalendarEvents = -> Meteor.subscribe 'weekEvents', xcalendarId.get(), xday.get().toDate()
setCalendar = (_id) -> xcalendarId.set _id

insertCallback = null
updateCallback = null
setCalendarCallbacks = (conf)->
  insertCallback = conf.insert
  updateCallback = conf.update

Template.xcalendarInner.events
  'click #plusWeek': (e, t) ->
    xday.set xday.get().add(7, 'days')
  'click #minusWeek': (e, t) ->
    xday.set xday.get().add(-7, 'days')
  'click .day-slot': (e,t)->
    atts = t.data
    date_txt = $(e.target).attr('date')
    date = moment(date_txt, 'YYYY-MM-DD HH:mm').toDate()
    callback = (data)->
      dct = {date:date, calendarId: xcalendarId.get()}
      _.extend(dct, data)
      xevent.insert(dct)
    if not xevent.findOne(date:date)
      insertCallback(callback)
  'click .xevent': (e,t)->
    _id = $(e.target).attr('_id')
    callback = (data)->
      xevent.update _id, {$set:data}
    updateCallback(xevent.findOne(_id), callback)

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
  xxevent: (calendarId) ->
    render = window[this.renderfunction]
    #
    m = moment(xday.get())
    d1 = m.clone().day(1).startOf('day').toDate()
    d2 = m.clone().day(8).startOf('day').toDate()
    #
    for event in xevent.find({calendarId: xcalendarId.get(), date: {$gte: d1, $lt: d2}}).fetch() # xevent.find({}).fetch()
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
      el.html(content)
      el.attr('_id', event._id)

    return null
  xevent: (calendarId) ->
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

Template.xcalendarInner.rendered = ->
  evento = xevent.findOne()
  if evento
    _id = evento._id
    text = evento.text
    xevent.update(_id, {$set: {text: text + '.'}})
    xevent.update(_id, {$set: {text: text }})


