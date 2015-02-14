Package.describe({
  name: 'miguelalarcos:xcalendar',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: 'A simple and native calendar for Meteor.',
  // URL to the Git repository containing the source code for this package.
  git: 'https://github.com/miguelalarcos/xcalendar.git',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.3.1');
  api.use('coffeescript', ['client', 'server']);
  api.use('aldeed:collection2', ['server', 'client']);
  api.use('momentjs:moment',['client','server'])
  api.use('templating', 'client');
  api.use('tracker', 'client');
  api.use('reactive-var', 'client');
  api.addFiles('xcalendar.html', 'client');
  api.addFiles('xcalendar_model.coffee', ['client', 'server']);
  api.addFiles('xcalendar.coffee', 'client');
  api.addFiles('xcalendar.css', 'client');
  api.addFiles('xcalendar_publications.coffee', 'server');

  api.export('attachEventSchema', 'client');
  api.export('waitForCalendarEvents', 'client');
  api.export('setCalendar', 'client');
  api.export('setEventHelpers', 'client');
  api.export('publishWeekEvents', 'server');
});

