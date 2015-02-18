patientId = new ReactiveVar(null)
reprogrammingEvent = new ReactiveVar(null)

Template.xCalendarWeekLeft.helpers
  display: (hour)->
    if /\d\d:30/.test(hour)
      false
    else
      true

Template.xCalendarDayRow.events
  'click td': (e,t)->
    _id = $(e.target).parent().attr('_id')
    status = t.data.doc.status
    if status is undefined or status == 'pending'
      status = 'done'
    else if status == 'done'
      status = 'failed'
    else if status == 'failed'
      status = 'pending'
    xCalendar.update _id, {status: status}

Template.xCalendarWeekTop.helpers
  displayCancelReprogramming: -> if reprogrammingEvent.get() then true else false

Template.xCalendarWeekTop.events
  'click #cancelReprogramming': (e, t)-> reprogrammingEvent.set null

Template.xCalendarSlot.events
  'click .empty-slot': (e,t)->
    date = t.data.toDate()
    event = reprogrammingEvent.get()
    if event
      xCalendar.update event._id, {date: date}
      reprogrammingEvent.set null
    else
      event = {date:date, patientId: patientId.get(), status: 'reserved'}
      _id = xCalendar.insert event
      event = xevent.findOne(_id)
      onOk = (dct) ->xCalendar.update(_id, {text: dct.text, status: 'pending'})
      onCancel = -> xCalendar.remove _id
      $('#modalInsertEventId textarea').val('')
      modal.show('modalInsertEvent', event, onOk, onCancel)

Template.xCalendarEvent.events
  'click .reprogramming-event':(e,t)->
    reprogrammingEvent.set t.data
  'click .delete-event': (e, t)->
    _id = t.data._id
    modal.show('modalRemoveEvent', t.data, -> xCalendar.remove(_id))
  'click .patient-event': (e, t)->
    if $(e.target).hasClass('delete-event') or $(e.target).hasClass('reprogramming-event') or $(e.target).hasClass('xpopup')
      return
    _id = t.data._id
    onOk = (dct) ->
      xCalendar.update(_id, {text: dct.text})
    modal.show('modalUpdateEvent', t.data, onOk)


class @HomeController extends RouteController
  waitOn: ->
    xCalendar.waitForCalendarEvents()
    Meteor.subscribe 'patients'
    Meteor.subscribe 'calendars'

Template.home.helpers
  patients: -> patient.find({})
  calendars: -> xcalendar.find({})

Template.home.events
  'click .patient': (e,t)->
    _id = $(e.target).attr('_id')
    patientId.set _id
    console.log 'patient id set'
  'click .calendar': (e,t)->
    _id = $(e.target).attr('_id')
    reprogrammingEvent.set null
    xCalendar.setCalendar _id
    console.log 'calendar id set'

