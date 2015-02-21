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
    @listenTo @model, 'scoreGame', (params) -> @scoreGame(params)
    @model.get('playerHand').checkForBlackjack()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @$el.find('.restart-button').hide()

  scoreGame: (params) ->
    @$el.find('button').hide()
    @$el.find('.restart-button').show()

    playerScore = @model.get('playerHand').scores()[1]
    playerScore = @model.get('playerHand').scores()[0] if playerScore > 21
    dealerScore = @model.get('dealerHand').scores()[0];

    if params
      @$el.find('.status').html('<h1>BlackJack!</h1>')
    else if playerScore > 21
      @$el.find('.status').html('<h1>Bust</h1>')
    else if dealerScore > 21
      @$el.find('.status').html('<h1>Dealer Bust</h1>')
    else if playerScore > dealerScore
      @$el.find('.status').html('<h1>Player Win</h1>')
    else if playerScore == dealerScore
      @$el.find('.status').html('<h1>Push!</h1>')
    else
      @$el.find('.status').html('<h1>Dealer Win</h1>')

  restartGame: ->
    @model.initGame()
    @render()
