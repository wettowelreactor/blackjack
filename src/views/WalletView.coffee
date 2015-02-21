class window.WalletView extends Backbone.View
  className: 'wallet'
  template: _.template '<h1><%= funds %></h1>'

  initialize: ->
    @listenTo(@model, 'add remove change', => @render())
    @render()

  render: ->
    @$el.html @template @model.attributes
