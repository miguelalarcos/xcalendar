xCalendar
=========

A simple and native calendar for Meteor.

Explanation
-----------

You have a demo [here](http://xcalendar.meteor.com). I would like to create a native Meteor and full calendar; help is welcome :)

You have to implement the next templates ```xCalendarWeekTop```, ```xCalendarWeekHead```, ```xCalendarWeekLeft```, ```xCalendarEvent``` , ```xCalendarSlot```, ```xCalendarDayTop```, ```xCalendarDayHead```, ```xCalendarDayRow``` and ```xCalendarDayEmptyRow```.

For example:

```html
<template name="xCalendarWeekTop">
    {{>xCalendarButtonMinus}}
    {{>xCalendarButtonPlus}}
    {{>xCalendarButtonToday}}
    {{#if displayCancelReprogramming}}
        <a href="" id="cancelReprogramming">Cancel reprogramming</a>
    {{/if}}
    <span>
        <span class="title">{{this.calendar}}</span>
        <span><b>&nbsp;&nbsp;&nbsp;&nbsp;{{formatDateMonthYear this.date}}</b></span>
    </span>
    {{>xCalendarButtonChangeView}}
</template>

<template name="xCalendarEvent">
    <div class="patient-event {{this.status}}">
        <b><a href="" class="delete-event" style="float: right">x</a></b>
        <span style="float: right">&nbsp;&nbsp;</span>
        <b><a href="" class="reprogramming-event" style="float: right">R</a></b>
        <div class="content-patient-event"><div><b>{{this.patient.nhc}}</b></div>{{this.patient.name}} {{this.patient.surname}}, {{sub this.text 25}}</div>
        <div class="xpopup">
            <b>NHC: {{this.patient.nhc}}</b>, {{this.patient.fullName}}, {{formatDateTime this.date}}
            <p>{{this.text}}</p>
        </div>
    </div>
</template>

```

* ```xCalendarWeekTop``` is passed *date* and *calendar* name.
* ```xCalendarWeekHead``` is passed a moment object with the date of that day.
* ```xCalendarWeekLeft``` is passed a text indicating the hour of the appointment, for example '08:30'
* ```xCalendarEvent``` is passed the event object of the appointment.
* ```xCalendarSlot``` is passed a moment object indicating the date of the slot
* ```xCalendarDayTop``` is passed *date* and *calendar* name.
* ```xCalendarDayHead```
* ```xCalendarDayRow``` is passed a object like {slot:slot, doc:event}
* ```xCalendarDayEmptyRow``` is passed the slot text.

You can use several templates already implemented:

```html
<template name="xCalendarButtonMinusDay">
    <button class="ui button"><i class="minus icon"></i></button>
</template>

<template name="xCalendarButtonPlusDay">
    <button class="ui button"><i class="plus icon"></i></button>
</template>

<template name="xCalendarButtonChangeView">
    <button class="ui button">Change view</button>
</template>

<template name="xCalendarButtonMinus">
    <button class="ui button"><i class="minus icon"></i></button>
</template>

<template name="xCalendarButtonPlus">
    <button class="ui button"><i class="plus icon"></i></button>
</template>

<template name="xCalendarButtonToday">
    <button class="ui button">Today</button>
</template>
```

And xCalendar provides the methods to insert, update and remove events:

```coffee
Template.xCalendarEvent.events
  'click .patient-event': (e, t)->
      _id = t.data._id
      onApprove = ->
        text = $('#inputUpdateAskModal').val()
        xCalendar.update _id, {text: text} # dont't use $set, it's done in the xCalendar side
      $('#dateUpdateAskModal').modal(onApprove : onApprove).modal('show')
```

You can extend the event model with your additional fields thanks to ```xCalendar.attachEventSchema``` method. For example:

```coffee
xCalendar.attachEventSchema
  patientId:
    type: String
  status:
    type: String
  text:
    type: String
    optional: true
```

And this is to set the event helpers (you have to add the ```dburles:collection-helpers``` package):
```
xCalendar.setEventHelpers
  patient: ->
    patient.findOne(this.patientId)
```

Last, you set the objects to retrieve with each event (you have to add the ```reywood:publish-composite``` package):

```coffee
xCalendar.publishWeekEvents [
  find: (event) -> patient.find event.patientId
  ]
```

To understand this, here is the implementation of ```xCalendar.publishWeekEvents```:

```coffee
xCalendar.publishWeekEvents = (children) ->
  Meteor.publishComposite 'weekEvents', (calendarId, date) ->
    m = moment(date)
    d1 = m.clone().day(0).startOf('day').toDate()
    d2 = m.clone().day(7).startOf('day').toDate()
    return {
    find: -> xevent.find({calendarId: calendarId, date: {$gte: d1, $lt: d2}})
    children: children
    }
```

css: you can style the tables of the calendar. Use ```#xCalendarDayViewTable``` and ```#xCalendarWeekViewTable```.

TODO:
* i18n
* at the moment, xCalendar is singleton. Think if it would be useful to have different calendar views at the same time in an app.