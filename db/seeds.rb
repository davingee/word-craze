# Seed starter words and associations so the game is immediately playable.
# Each pair creates both words and a bidirectional association.

pairs = [
  ["ocean",   "wave"],    ["ocean",   "fish"],    ["ocean",  "blue"],
  ["sun",     "light"],   ["sun",     "warm"],    ["sun",    "sky"],
  ["fire",    "hot"],     ["fire",    "smoke"],   ["fire",   "burn"],
  ["music",   "sound"],   ["music",   "rhythm"],  ["music",  "joy"],
  ["rain",    "cloud"],   ["rain",    "wet"],     ["rain",   "storm"],
  ["forest",  "tree"],    ["forest",  "green"],   ["forest", "quiet"],
  ["city",    "noise"],   ["city",    "people"],  ["city",   "light"],
  ["dream",   "sleep"],   ["dream",   "imagine"], ["dream",  "night"],
  ["book",    "story"],   ["book",    "read"],    ["book",   "word"],
  ["love",    "heart"],   ["love",    "warm"],    ["love",   "kind"]
]

pairs.each do |word_name, assoc_name|
  word  = Word.find_or_create_by!(name: word_name)  { |w| w.scrubbed = true }
  assoc = Word.find_or_create_by!(name: assoc_name) { |w| w.scrubbed = true }

  a = Association.find_or_create_by!(word_id: word.id, association_id: assoc.id) do |r|
    r.scrubbed = true
    r.count = 3
  end

  word.update_column(:associations_count, word.associations.count)
end

puts "Seeded #{Word.count} words and #{Association.count} associations."
