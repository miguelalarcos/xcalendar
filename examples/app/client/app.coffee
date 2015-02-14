patientId = new ReactiveVar(null)

attachEventSchema
  patientId:
    type: String

@patientCallback = ->
  patientId: patientId.get()
  text: patient.findOne(patientId.get()).name

@renderDatePatient = (event) ->
  event.patientId

#Template.home.helpers
#  calendar: -> xcalendar.get()

class @HomeController extends RouteController
  waitOn: ->
    waitForCalendar()
    Meteor.subscribe 'patients'

Template.home.helpers
  patient: -> patient.find({})

Template.home.events
  'click .patient': (e,t)->
    _id = $(e.target).attr('_id')
    patientId.set _id
