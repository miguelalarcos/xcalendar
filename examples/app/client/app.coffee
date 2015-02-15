patientId = new ReactiveVar(null)
updateEvent = new ReactiveVar(null)

xCalendar.onDayClick = (event) ->
    onApprove = ->
      text = $('#inputDateAskModal').val()
      $('#inputDateAskModal').val('')
      event.patientId = patientId.get()
      event.text = text
      xCalendar.insert event
    $('#dateAskModal').modal(onApprove : onApprove).modal('show')

Template.dateEventTemplate.events
  'click .delete-event': (e, t)->
    xCalendar.remove t.data._id
  'click .patient-event': (e, t)->
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

#@renderDatePatient = (event) ->
#  Blaze.toHTMLWithData(Template.datePatient, event)

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
