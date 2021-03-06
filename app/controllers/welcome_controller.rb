class WelcomeController < ApplicationController

   def index
      return @image_results_list if @image_results_list
      if params[:search_tattoos]
         image_search = GoogleSearchResults.new(q: "#{ params[:search_tattoos] } tattoos", tbm: "isch", serp_api_key: ENV['SERP_API_KEY'])
         @image_results_list = image_search.get_hash[:images_results][0..8]
      end
   end
end
