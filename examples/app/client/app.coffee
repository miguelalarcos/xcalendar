patientId = new ReactiveVar(null)
updateEvent = new ReactiveVar(null)
removeEvent = new ReactiveVar(null)
reprogrammingEvent = new ReactiveVar(null)

modal = {}

modal.modalShow = new ReactiveVar('')
modal.template = new ReactiveVar(null)
#modal.elementModalRendered = null

modal.close = ->
  #Blaze.remove(modal.elementModalRendered)
  modal.modalShow.set ''

modal.render = (template, data, onOkCallback) ->
  modal.onOkCallback = onOkCallback
  modal.modalShow.set 'show'
  modal.template.set template
  #el = $('#modalId .center')[0]
  #modal.elementModalRendered = Blaze.renderWithData(template, data, el)

Template.modal.helpers
  modalShow: -> modal.modalShow.get()
  template: -> modal.template.get()

Template.modal1.events
  'click button.close': (e,t)->
    val = $(t.find('input')).val()
    modal.onOkCallback(val)
    modal.close()


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
      onApprove = ->
        text = $('#inputDateAskModal').val()
        $('#inputDateAskModal').val('')
        xCalendar.update _id, {text: text, status: 'pending'}
      onDeny = ->
        xCalendar.remove _id
        $('#inputDateAskModal').val('')
      $('#dateAskModal').modal(onApprove : onApprove, onDeny: onDeny).modal('show')

Template.xCalendarEvent.events
  'click .reprogramming-event':(e,t)->
    reprogrammingEvent.set t.data
  'click .delete-event': (e, t)->
    removeEvent.set t.data
    _id = t.data._id
    onApprove = ->
      xCalendar.remove _id
    $('#dateRemoveAskModal').modal(onApprove : onApprove).modal('show')
  'click .patient-event': (e, t)->
    if $(e.target).hasClass('delete-event') or $(e.target).hasClass('reprogramming-event')
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
  event: -> updateEvent.get() or {} # why??? (works)

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
  'click button.show-modal':(e,t)->
    f = (x)-> console.log x
    modal.render('modal1', {}, f)
  'click .patient': (e,t)->
    _id = $(e.target).attr('_id')
    patientId.set _id
    console.log 'patient id set'
  'click .calendar': (e,t)->
    _id = $(e.target).attr('_id')
    reprogrammingEvent.set null
    xCalendar.setCalendar _id
    console.log 'calendar id set'

#Template.xCalendarEvent.rendered = ->
#  for el in this.findAll('.patient-event')
#    $(el).popup()