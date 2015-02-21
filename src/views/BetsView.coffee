class window.BetsView extends Backbone.View
  singleHandTemplate: _.template '<h1><%= bet %></h1> \
                                  <button class="raise">Raise</button>
                                  <button class="lower">Lower</button>
                                  <button class="finishBet">Bet</button>'
  splitHandTemplate: _.template '<h1><%= sideBet %></h1>'

  events:
    'click .finishBet': -> @model.finishBet()

  initialize: ->
    @listenTo(@model, 'add remove change', => @render())
    @render()

  render: ->
    @$el.html @singleHandTemplate @model.attributes
    if @model.get('splitHand')
      @$el.append @splitHandTemplate @model.attributes
