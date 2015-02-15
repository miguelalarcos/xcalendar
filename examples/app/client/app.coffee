patientId = new ReactiveVar(null)
updateEvent = new ReactiveVar(null)
removeEvent = new ReactiveVar(null)

Template.xCalendarLeft.helpers
  display: (hour)->
    if /\d\d:30/.test(hour)
      'not-display'

Template.dateSlotTemplate.events
  'click .empty-slot': (e,t)->
    onApprove = ->
      text = $('#inputDateAskModal').val()
      $('#inputDateAskModal').val('')
      date_txt = t.data
      date = moment(date_txt, 'YYYY-MM-DD HH:mm').toDate()
      event = {date: date}
      event.patientId = patientId.get()
      event.text = text
      xCalendar.insert event
    $('#dateAskModal').modal(onApprove : onApprove).modal('show')

Template.dateEventTemplate.events
  'click .delete-event': (e, t)->
    removeEvent.set t.data
    _id = t.data._id
    onApprove = ->
      xCalendar.remove _id
    $('#dateRemoveAskModal').modal(onApprove : onApprove).modal('show')
  'click .patient-event': (e, t)->
    if not $(e.target).hasClass('patient-event')
      return
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

Template.dateEventTemplate.rendered = ->
  for el in this.findAll('.patient-event')
    $(el).popup()