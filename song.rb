class Critter < Struct.new(:name, :qualifier, :aside)
  def epiteth
    [name, qualifier].compact.join(" ")
  end
end

class Song
  DATA = [
    ["horse", nil, "She's dead, of course!"],
    ["cow", nil, "I don't know how she swallowed a cow!"],
    ["goat", nil, "Just opened her throat and swallowed a goat!"],
    ["dog", nil, "What a hog, to swallow a dog!"],
    ["cat", nil, "Imagine that, to swallow a cat!"],
    ["bird", nil, "How absurd to swallow a bird!"],
    [
      "spider",
      "that wriggled and jiggled and tickled inside her",
      "It wriggled and jiggled and tickled inside her.",
    ],
    ["fly", nil, "I don't know why she swallowed the fly. Perhaps she'll die."],
  ]

  attr_reader :critters
  def initialize(data=DATA)
    @critters = data.map {|row| Critter.new(*row)}
  end

  def lyrics
    (1..critters.length).map {|i|
      Verse.for(critters, i)
    }.join("\n")
  end
end

class Verse
  def self.for(critters, i)
    case i
    when 1, critters.length
      ShortVerse
    else
      LongVerse
    end.new(critters.last(i))
  end
end

class ShortVerse
  attr_reader :critters, :critter
  def initialize(critters)
    @critters = critters
    @critter = critters.first
  end

  def to_s
    incident + recap
  end

  private

  def incident
    "I know an old lady who swallowed a %s.\n%s\n" % [
      critter.name,
      critter.aside,
    ]
  end

  def recap
    ""
  end
end

class LongVerse < ShortVerse
  private

  def recap
    "%s\n" % chain +
    "%s\n" % critters.last.aside
  end

  def chain
    critters.each_cons(2).map {|pair|
      motivation(*pair)
    }.join("\n")
  end

  def motivation(predator, prey)
    "She swallowed the %s to catch the %s." % [
      predator.name,
      prey.epiteth,
    ]
  end
end
