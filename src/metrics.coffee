# Simple Backbone application that sends post request to the server
# http://private-anon-cfbd0efe2-metricsonjsapi.apiary-mock.com/metrics
# and displays the feedback to the user. This latter is in form of an alert
# for both success and error cases

# Load the application once the DOM is ready, using a `jQuery.ready` shortcut.
$ ->
  ### Metric Model ###
  # simple Metric model has a `url` attribute. Used primarily to during the POST request
  class Metric extends Backbone.Model
    url: 'http://private-anon-cfbd0efe2-metricsonjsapi.apiary-mock.com/metrics'

  ### The Application ###

  # Metric view is the global application, it handles all the interactions with the DOM
  # and processing of data
  class MetricView extends Backbone.View
    # Instead of generating a new element, bind to the existing skeleton of
    # the App already present in the HTML.
    el_tag = "#metricApp"
    el: $(el_tag)

    # Clears the input field and displays the alert every time necessary
    showAlert: (id) ->
      @input.val('')
      alert = $('#alert-' + id);
      alert.appendTo('.page-alerts');
      alert.slideDown();

    # Delegated events for posting new data
    events:
      "click #add-btn": "postNew"

    # Binds and initializes the relevant input with the value entered by the user
    initialize: =>
      @input = this.$("#new-data")

    # Posts new data to the server
    postNew: (e) ->
      Backbone.emulateHTTP = true
      metric = new Metric(
        data : @input.val()
      )
      metric.save null,
        success:((model,response) ->
          @showAlert(1)
        ).bind(this)
        error: ((model,response) ->
          if(response.status == 201)
            @showAlert(1)
          else
            @showAlert(4)
        ).bind(this)

  # Create the an application instance
  App = new MetricView()