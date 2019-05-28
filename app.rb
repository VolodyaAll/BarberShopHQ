#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:barbershop.db"

class Client < ActiveRecord::Base
end

class Barber < ActiveRecord::Base
end

class Contact < ActiveRecord::Base
end

before do
	@barbers = Barber.order "created_at DESC"
end

get '/' do	
	erb :index
end

get '/visit' do	
	erb :visit
end

get '/contact' do
	erb :contact
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@barber = params[:barber]
	@color = params[:color]
		
	hh = {:username => 'Введите имя',
		:phone => 'Введите телефон',
		:date_time => 'Введите дату и время'}

	@error = hh.select{|key,_| params[key] == ""}.values.join(", ")

	if @error != '' 		
		return erb :visit
	else
		Client.create :name => @username,
						:phone => @phone,
						:datestamp => @date_time,
						:barber => @barber,
						:color => @color
		erb "Dear #{@username}, we will be waiting for you at #{@date_time}. Your barber is #{@barber}, Color: #{@color}. See you! <a href=\"http://localhost:4567\">На главную</a>"		
	end
end

post '/contact' do

	@email = params["email"]
	@message = params["message"]

	hh = {:email => 'Введите Email',
		:message => 'Введите сообщение'}

	@error = hh.select{|key,_| params[key] == ""}.values.join(", ")
	
	if @error == '' 

		Contact.create :email => @email,
						:message => @message
		
		erb "We will send our answer to #{params[:email]}. See you! <a href=\"http://localhost:4567\">На главную</a>"		
	else 
		return erb :contact
	end
end

	


