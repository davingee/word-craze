class AssociationsController < ApplicationController
  def create
    word = Word.find(params[:association][:word_id])
    name = params[:association][:name].to_s.strip.downcase

    if name.blank?
      redirect_to root_path(id: word.id) and return
    end

    associated_word = Word.find_or_create_by(name: name)
    associated_word.update(user_word: true)

    unless word.id == associated_word.id
      assoc = Association.find_or_create_by(word_id: word.id, association_id: associated_word.id)
      assoc.increment!(:count)
      assoc.update(user_word: true)

      word.increment!(:associations_count) if assoc.previously_new_record?

      user_assoc = UserAssociation.find_or_create_by(
        word_id: word.id,
        association_id: associated_word.id,
        user_id: current_user&.id
      )
      user_assoc.save
    end

    redirect_to root_path(id: word.id)
  end
end
