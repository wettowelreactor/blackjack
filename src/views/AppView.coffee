class window.AppView extends Backbone.View
  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <button class="split-button">Split</button>
    <button class="restart-button">Start a New Game</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
    <div class="status"></div>
  '

  events:
    'click .hit-button': -> @model.get(@model.get('activeHand')).hit()
    'click .stand-button': -> @stand()
    'click .restart-button': -> @restartGame()
    'click .split-button': -> @splitHand()

  initialize: ->
    @render()
    @listenTo @model, 'scoreGame', (params) -> @scoreGame(params)
    @listenTo @model, 'splitPossible', @showSplit
    @listenTo @model, 'bust', @bust
    @model.get('playerHand').checkForBlackjack()
    @model.get('playerHand').checkForSplit()

  transferHand: ->
    if @model.get('splitHand') != null && !@model.get('splitHand').active
      @model.get('playerHand').active = false
      @model.get('splitHand').active = true
      @model.set('activeHand', 'splitHand')
      true
    else
      false

  bust: ->
    if @transferHand() is false
      @scoreGame()

  stand: ->
    if @transferHand() is false
      @model.get('dealerHand').play()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @$el.find('.restart-button').hide()
    @$el.find('.split-button').hide()

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

  showSplit: ->
    @$el.find('.split-button').show()

  splitHand: ->
    @$el.find('.split-button').hide()
    card = @model.get('playerHand').pop();
    @model.get('playerHand').hit()
    newHand = new Hand([card], @model.get('deck'))
    newHand.hit();
    @$('.player-hand-container').append(new HandView(collection: newHand).el)
    @model.set('splitHand', newHand)
    @model.listenTo(@model.get('splitHand'), 'bust', => @model.trigger('bust'))
