class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer, @active) ->

  hit: ->
    @add(@deck.pop())
    if @scores()[0] > 21
      @trigger('bust')

  play: ->
    hiddenCards = @filter((card) -> !card.get('revealed'))
    hiddenCards.forEach((card) -> card.flip())

    while @scores()[0] < 17
      @hit()

    @trigger('scoreGame')

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]

  checkForBlackjack: ->
    if not @isDealer and @scores()[1] == 21
      @trigger('scoreGame', true)

  checkForSplit: ->
    if @models[0].attributes.value == @models[1].attributes.value
      @trigger('splitPossible')
