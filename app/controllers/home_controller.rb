class HomeController < ApplicationController
  def index
    @word = if params[:association_id]
      Word.find_by(id: params[:association_id])
    elsif params[:id]
      Word.find_by(id: params[:id])
    else
      random_word
    end
  end

  def search
    if params[:q].blank?
      redirect_to root_path and return
    end

    @word = Word.find_or_create_by(name: params[:q].strip.downcase)
    @word.update(user_word: true)
    redirect_to root_path(id: @word.id)
  end

  def about
  end
end
