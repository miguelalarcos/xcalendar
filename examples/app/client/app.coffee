patientId = new ReactiveVar(null)
updateEvent = new ReactiveVar(null)

attachEventSchema
  patientId:
    type: String

setEventHelpers
  patient: ->
    patient.findOne(this.patientId)

setCalendarCallbacks
  insert: (callback)->
    onApprove = ->
      text = $('#inputDateAskModal').val()
      callback
        patientId: patientId.get()
        text: text
    $('#dateAskModal').modal(onApprove : onApprove).modal('show')
  update: (event, callback)->
    updateEvent.set event
    onApprove = ->
      text = $('#inputUpdateAskModal').val()
      callback {text: text}
      updateEvent.set null
    console.log updateEvent.get()
    $('#dateUpdateAskModal').modal(onApprove : onApprove).modal('show')

Template.dateAskModal.helpers
  patient: -> patient.findOne(patientId.get())

Template.dateUpdateAskModal.helpers
  event: -> updateEvent.get() or {}

@renderDatePatient = (event) ->
  event.patient().name + '<br>' + event.text

class @HomeController extends RouteController
  waitOn: ->
    waitForCalendarEvents()
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
    setCalendar _id
    console.log 'calendar id set'
