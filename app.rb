require 'dotenv/load'
require 'sinatra'
require 'slim'
require 'uri'
require 'thread'
require 'httparty'
require 'byebug'

require_relative 'app/slack_authorizer'

use SlackAuthorizer

class BerMode < Sinatra::Base

  post '/slack/command' do
    username = params["user_name"]
    
    function_params = params["text"].split("|")
    contents = function_params[0]
    channel_id = function_params[1]
    delay = function_params[2] || 0.5

    contents = contents.split(" ")
    channel = channel_id && channel_id != "" ? URI.encode(channel_id.strip) : params["channel_id"]

    threads = []
    token = ENV["SLACK_API_TOKEN"]
    contents.each_with_index do |content, index|
      return if content.empty?
      threads << Thread.new { sleep(index * delay.to_i); result = HTTParty.get("https://slack.com/api/chat.postMessage?token=#{token}&channel=#{channel}&text=#{content}&username=#{username}&as_user=false&link_names=true"); puts result }
    end
    #threads.each(&:join)
    puts "end of function"
    ""
  end

  get '/slack/users' do
    token = ENV["SLACK_API_TOKEN"]
    result = HTTParty.get("https://slack.com/api/users.list?token=#{token}")
    @info_data = JSON.parse(result.body)["members"]
    slim :'user_list'
  end

end