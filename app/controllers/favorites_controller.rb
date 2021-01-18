class FavoritesController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    unless @book.favorited_by?(current_user)
      favorite = @book.favorites.new(user_id: current_user.id)
      favorite.save
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    if @book.favarited_by?(current_user)
      favorite = current_user.favorites.find_by(book_id: @book.id)
      favorite.destroy
    end
  end
end
