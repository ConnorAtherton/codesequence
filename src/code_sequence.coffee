#
# We will fill in letters in a loop further down
#
# http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes
keymap = {
  "up":        38,
  "down":      40,
  "left":      37,
  "right":     39,
  "enter":     13,
  "space":     32,
  "shift":     16,
  "ctrl":      17,
  "alt":       18,
  "option":    18,
  "caps":      20,
  "escape":    27
  "backspace": 8,
  "tab":       9,
  "meta":      91,
  "super":     91, # linux
  "command":   91, # mac
  "win":       91, # windows

  # arithmetic operators
  "multiply": 107,
  "add": 107,
  "subtract": 107,
  "divide": 107,
  "decimal": 107,
  "dot": 107,
  "decimalPoint": 107,

  # punctuation
  "equals": 100
  "dash": 100
}

# Numbers
# 48-57
i = 47
n = 0
while i++ < 57
  keymap[n] = i
  keymap["num#{n}"] = i + 48
  n++

# Letters
# 65-90
i = 65;
keymap[String.fromCharCode(i).toLowerCase()] = i while i++ < 90

# function keys
i = 112;
keymap["f#{i}"] = i while i++ < 123

internalSequences = {
  'konami': 'up+up+down+down+left+right+left+right+a+b',
  'world': 'up+right+down+left'
}

class CodeSequence
  constructor: (@sequence, @callback) ->
    @keydownSequence = ''
    @triggered = false

    # Format the sequence correctly
    @constructSequence()

    # Start listening for the sequence
    @addEvent(document, 'keyup', @keyHandler)

  addEvent: (elem, evt, fn) ->
    if elem.addEventListener
      elem.addEventListener(evt, fn.bind(@), false);
    else
      elem.attachEvent('on' + evt, fn.bind(@));

  keyHandler: (e) ->
    @keydownSequence += e.keyCode

    # If it is not greater than the sequence
    # then we can do a straight comparison with
    # chopping the string
    if @keydownSequence.length > @sequence.length
      @keydownSequence = @keydownSequence.substring(@keydownSequence.length - @sequence.length);

    if @keydownSequence == @sequence
      @keydownSequence = []
      @callback()
      @triggered = true

  constructSequence: ->
    # if there are no + present in the string we check for
    # a matching *special* in-built sequence in the library
    if (internalSequence = internalSequences[@sequence])
      @sequence = internalSequence

    # - parse by +
    # - loop through the array and map the letter sequence to
    #   a stored map of key codes
    # - leave numbers unaltered
    @sequence = @sequence.split '+'
      .map((key) ->
        key = key.toLowerCase()
        if key is aNumber(key) then key else keymap[key]
      ).join('')

# Helper
aNumber = (val) ->
  typeof arg == 'number'

# attach to global object
this.CodeSequence = CodeSequence