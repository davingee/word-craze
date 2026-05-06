class WordsController < ApplicationController
  def index
    @words = Word.order(:name).page(params[:page])
  end

  def show
    @word = Word.find(params[:id])
  end

  def new
    require_login
    @word = Word.new
  end

  def create
    require_login
    @word = Word.new(word_params)
    if @word.save
      redirect_to @word, notice: "Word created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    require_login
    @word = Word.find(params[:id])
  end

  def update
    require_login
    @word = Word.find(params[:id])
    if @word.update(word_params)
      redirect_to @word, notice: "Word updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    require_login
    @word = Word.find(params[:id])
    @word.destroy
    redirect_to words_url, notice: "Word removed."
  end

  def flag_or_r_rated
    word = Word.find(params[:id])
    case params[:type]
    when "flagged"
      word.increment!(:flagged)
      flash[:notice] = "Word flagged as spam."
    when "r_rated"
      word.increment!(:r_rated)
      flash[:notice] = "Word marked as R-rated."
    end
    redirect_to root_path
  end

  private

  def word_params
    params.require(:word).permit(:name, :scrubbed, :user_word)
  end
end
