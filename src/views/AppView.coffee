class window.AppView extends Backbone.View
  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <button class="restart-button">Start a New Game</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
    <div class="status"></div>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('playerHand').stand()
    'click .restart-button': -> @restartGame()

  initialize: ->
    @render()
    @listenTo @model, 'bust', @playerBust

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @$el.find('.restart-button').hide()

  playerBust: ->
    @$el.find('.status').html('<h1>Bust</h1>')
    @$el.find('button').hide()
    @$el.find('.restart-button').show()

  restartGame: ->
    @model.initGame()
    @render()
