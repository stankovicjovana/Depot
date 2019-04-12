class StoreController < ApplicationController
  include CurrentCart
  skip_before_action :authorize
  before_action :set_cart
  
  def index
  	if params[:set_locale]
      redirect_to store_index_url(locale: params[:set_locale])
    else
      @products = Product.order(:title)
    end

  	if session[:count] == nil
  		session[:count] = 1
  	else
  		session[:count] = session[:count] + 1
  	end

  	puts "***** store_index action count:"
  	puts session[:count]
  end
end
