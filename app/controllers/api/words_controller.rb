module Api
  class WordsController < ApplicationController
    def associations
      word = Word.find(params[:id])

      scrubbed = Association
        .joins("JOIN words AS w ON w.id = associations.association_id")
        .where(word_id: word.id, scrubbed: true, user_word: false)
        .select("associations.association_id, associations.count, w.name AS word_name")
        .order(Arel.sql("RANDOM()"))
        .limit(10)

      user_made = Association
        .joins("JOIN words AS w ON w.id = associations.association_id")
        .where(word_id: word.id, user_word: true)
        .select("associations.association_id, associations.count, w.name AS word_name")
        .order(Arel.sql("RANDOM()"))
        .limit(15)

      all_assocs = (scrubbed.to_a + user_made.to_a).uniq { |a| a.association_id }

      render json: {
        word: { id: word.id, name: word.name },
        associations: all_assocs.map { |a|
          { id: a.association_id, name: a.word_name, count: a.count }
        }
      }
    end
  end
end
