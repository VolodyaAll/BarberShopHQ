#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:barbershop.db"

class Client < ActiveRecord::Base
	validates :name, presence: true
	validates :phone, presence: true
	validates :datestamp, presence: true
	validates :color, presence: true
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
	c = Client.new params[:client]
	if c.save
		erb "Спасибо, Вы записались."	
	else
		@error = c.errors.full_messages.first
		erb :visit
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

	


