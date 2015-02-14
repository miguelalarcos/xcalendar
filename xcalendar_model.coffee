@xevent = new Meteor.Collection "Events"
basicEventSchema =
  date:
    type: Date
  text:
    type: String
    optional: true
  calendarId:
    type: String

attachEventSchema = (schema) ->
  _.extend(schema, basicEventSchema)
  xevent.attachSchema(schema)

@xcalendar = new Meteor.Collection "Calendar"
xcalendarSchema = new SimpleSchema
  name:
    type: String
  slotIni:
    type: String
    #regEx: /^[0-9]{5}$/
  slotEnd:
    type: String
  duration:
    type: Number

xcalendar.attachSchema(xcalendarSchema)
