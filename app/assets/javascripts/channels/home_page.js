App.messages = App.cable.subscriptions.create('HomePageChannel', {
  received: function(data) {
  }
});
