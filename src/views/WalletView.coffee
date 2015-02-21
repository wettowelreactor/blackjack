class window.WalletView extends Backbone.View
  el: '<h1>'
  template: _.template '<%= funds %>'

  initialize: ->
    @listenTo(@model, 'add remove change', => @render())
    @render()

  render: ->
    @$el.html @template @model.attributes
