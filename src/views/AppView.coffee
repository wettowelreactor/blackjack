class window.AppView extends Backbone.View
  template: _.template '
    <div class="wallet"></div>
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <button class="split-button">Split</button>
    <button class="restart-button">Start a New Game</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
    <div class="status"></div>
  '

  events:
    'click .hit-button': -> @hit()
    'click .stand-button': -> @stand()
    'click .restart-button': -> @restartGame()
    'click .split-button': -> @splitHand()

  hit: ->
    splitAces = false
    # is a second hand and first card is ace
    splitHand = @model.get('splitHand')
    if splitHand and splitHand.first().get('rankName') == 'Ace'
      splitAces = true

    @model.get(@model.get('activeHand')).hit(splitAces)

  initialize: ->
    @render()
    @listenTo @model, 'scoreGame', (params) -> @scoreGame(params)
    @listenTo @model, 'splitPossible', @showSplit
    @listenTo @model, 'bust', @bust
    @listenTo @model, 'stand', @stand
    @model.get('playerHand').checkForBlackjack()
    @model.get('playerHand').checkForSplit()

  transferHand: ->
    if @model.get('splitHand') != null && !@model.get('splitHand').active
      @model.get('playerHand').active = false
      @model.get('playerHand').trigger('change')
      @model.get('splitHand').active = true
      @model.get('splitHand').trigger('change')
      @model.set('activeHand', 'splitHand')
      true
    else
      false

  bust: ->
    if @transferHand() is false
      @model.get('dealerHand').play()

  stand: ->
    if @transferHand() is false
      @model.get('dealerHand').play()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.wallet').html new WalletView(model: @model.get 'wallet').el
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @$el.find('.restart-button').hide()
    @$el.find('.split-button').hide()

  scoreGame: (params) ->
    @$el.find('button').hide()
    @$el.find('.restart-button').show()

    dealerScore = @model.get('dealerHand').scores()[0];

    playerHandResult = @scoreHand('playerHand', dealerScore, params)
    if (@model.get('splitHand'))
      splitHandResult = @scoreHand('splitHand', dealerScore, params)

    if (!splitHandResult)
      @$el.find('.status').html('<h1>' + playerHandResult + '</h1>')
    else
      @$el.find('.status').html('<h1> Hand 1: ' + playerHandResult + ' | Hand 2:' + splitHandResult + '</h1>')

  scoreHand: (hand, dealerScore, params) ->
    playerScore = @model.get(hand).scores()[1]
    playerScore = @model.get(hand).scores()[0] if playerScore > 21
    if params
      return 'BlackJack!'
    else if playerScore > 21
      return 'Bust'
    else if dealerScore > 21
      return 'Dealer Bust'
    else if playerScore > dealerScore
      return 'Player Win'
    else if playerScore == dealerScore
      return 'Push!'
    else
      return 'Dealer Win'

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
    @model.listenTo(@model.get('splitHand'), 'stand', => @model.trigger('stand'))
