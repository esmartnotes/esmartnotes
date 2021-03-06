	class ApiController < ApplicationController
	protect_from_forgery :except => :create

	def index
		@apis = Api.order('created_at desc').limit(1)
	end

	def show
		@apis = Api.order('created_at desc').limit(1)
		render plain: @apis.first.url + "~" + @apis.first.id.to_s
	end

	def new
	end

	def create
		@api = Api.new(api_params)

		keywords = @api.url.strip.downcase.split(" ")

		if keywords[0] == "scroll"
			url = @api.url.strip.downcase

		elsif keywords[0] == "bing"
			keywords.delete_at(0)
			url = "http://www.bing.com/search?q="
			keywords.each do |k|
				url += k + " "
			end
		elsif keywords[0] == "wikipedia"
			keywords.delete_at(0)
			url = "http://en.wikipedia.org/wiki/Special:Search?search="
			keywords.each do |k|
				url += k + " "
			end
		else
			url = "http://www."
			keywords.each_with_index do |k,i|
				# if the final word, replace incorrect "come" with "com"
				if i == keywords.length-1
					url += k.delete(' ').gsub("come", "com")
				else
					url += k.delete(' ')
				end
			end
		end

		@api.url = url

	  	@api.save
		render plain: ""
	end

	private
	def api_params
		params.require(:api).permit(:url)
	end
	end
