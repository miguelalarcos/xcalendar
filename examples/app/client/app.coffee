patientId = new ReactiveVar(null)
calendarId = @xcalendarId

attachEventSchema
  patientId:
    type: String

@patientCallback = (callback) ->
  onApprove = ->
    text = $('#inputDateAskModal').val()
    callback
      patientId: patientId.get()
      text: text
  $('#dateAskModal').modal(onApprove : onApprove).modal('show')

Template.dateAskModal.helpers
  patient_: -> patient.findOne(patientId.get())
  
@renderDatePatient = (event) ->
  event.text

class @HomeController extends RouteController
  waitOn: ->
    waitForCalendarEvents('agenda01')
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
    calendarId.set _id
    console.log 'calendar id set'
