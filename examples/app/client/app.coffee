patientId = new ReactiveVar(null)
updateEvent = new ReactiveVar(null)
removeEvent = new ReactiveVar(null)
reprogrammingEvent = new ReactiveVar(null)

Template.xCalendarLeft.helpers
  display: (hour)->
    if /\d\d:30/.test(hour)
      false
    else
      true

Template.xDayCalendarRowTemplate.events
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

Template.xCalendarTop.helpers
  displayCancelReprogramming: -> if reprogrammingEvent.get() then true else false

Template.xCalendarTop.events
  'click #cancelReprogramming': (e, t)-> reprogrammingEvent.set null

Template.xSlotTemplate.events
  'click .empty-slot': (e,t)->
    #date_txt = t.data
    #date = moment(date_txt, 'YYYY-MM-DD HH:mm').toDate()
    date = t.data.toDate()
    console.log date
    event = reprogrammingEvent.get()
    if event
      xCalendar.update event._id, {date: date}
      reprogrammingEvent.set null
    else
      onApprove = ->
        text = $('#inputDateAskModal').val()
        $('#inputDateAskModal').val('')
        event = {date: date}
        event.patientId = patientId.get()
        event.text = text
        xCalendar.insert event
      $('#dateAskModal').modal(onApprove : onApprove).modal('show')

Template.xEventTemplate.helpers
  sub: (txt, len)->
    if txt.length > len
      return txt[0..len] + '...'
    else
      return txt

Template.xEventTemplate.events
  'click .reprogramming-event':(e,t)->
    reprogrammingEvent.set t.data
  'click .delete-event': (e, t)->
    removeEvent.set t.data
    _id = t.data._id
    onApprove = ->
      xCalendar.remove _id
    $('#dateRemoveAskModal').modal(onApprove : onApprove).modal('show')
  'click .patient-event': (e, t)->
    if $(e.target).hasClass('patient-event') or $(e.target).hasClass('content-patient-event')
      updateEvent.set t.data
      _id = t.data._id
      onApprove = ->
        text = $('#inputUpdateAskModal').val()
        xCalendar.update _id, {text: text}
      $('#dateUpdateAskModal').modal(onApprove : onApprove).modal('show')

Template.dateAskModal.helpers
  patient: -> patient.findOne(patientId.get())

Template.dateUpdateAskModal.helpers
  event: -> updateEvent.get() or {} # why???

Template.dateRemoveAskModal.helpers
  event: -> removeEvent.get() or {}

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
    #calendarId.set _id
    xCalendar.setCalendar _id
    console.log 'calendar id set'

Template.xEventTemplate.rendered = ->
  for el in this.findAll('.patient-event')
    $(el).popup()