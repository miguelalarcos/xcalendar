@xevent = new Meteor.Collection "Events"
basicEventSchema =
  date:
    type: Date
  text:
    type: String
    optional: true
  calendarId:
    type: String

xCalendar.attachEventSchema = (schema) ->
  _.extend(schema, basicEventSchema)
  xevent.attachSchema(schema)

xCalendar.setEventHelpers = (helpers) ->
  xevent.helpers helpers

@xcalendar = new Meteor.Collection "Calendar"
xcalendarSchema = new SimpleSchema
  name:
    type: String
  slotIni:
    type: String
  slotEnd:
    type: String
  duration:
    type: Number
  days:
    type: [Number]

xcalendar.attachSchema(xcalendarSchema)
