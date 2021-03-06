Package.describe({
  name: 'miguelalarcos:xcalendar',
  version: '0.3.2',
  summary: 'A simple and native calendar for Meteor.',
  git: 'https://github.com/miguelalarcos/xcalendar.git',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.3.1');
  api.use('coffeescript', ['client', 'server']);
  api.use('aldeed:collection2@2.3.2', ['server', 'client']);
  api.use('momentjs:moment@2.8.4',['client','server'])
  api.use('templating', 'client');
  api.use('tracker', 'client');
  api.use('reactive-var', 'client');
  api.addFiles('xcalendar.html', 'client');
  api.addFiles('xcalendar_base.coffee', ['client', 'server']);
  api.addFiles('xcalendar_model.coffee', ['client', 'server']);
  api.addFiles('xcalendar.coffee', 'client');
  api.addFiles('xcalendar.css', 'client');
  api.addFiles('xcalendar_publications.coffee', 'server');
  api.addFiles('xcalendar_deny.coffee', 'server');

  api.export('xCalendar', ['client', 'server']);
});

