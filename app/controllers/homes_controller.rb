require 'httparty'
class HomesController < ApplicationController
  def index
    @buildings = Building.first
    @hash = Gmaps4rails.build_markers(@buildings) do |b, marker|
      marker.lat b.lat
      marker.lng b.long
    end
  end

  def create
    # input1 = {ColumnNames: ["zipcode", "unitsres", "yearbuilt", "risk4"], Values: [ [ "0", "0", "0", "0" ], [ "0", "0", "0", "0" ] ] }
    # inputs = {input1: input1, GlobalParameters: {}}
    # data = {Inputs: inputs}
    zip = params[:zip]
    units = params[:units]
    year = params[:year]
    # if zip.nil? || units.nil? || year.nil?
    #   redirect_to :back, :flash => { :error => "please fill in the fields" }
    #   return
    # end

    data = {Inputs: {input1: {ColumnNames: ["zipcode", "unitsres", "yearbuilt", "risk4"], Values:[ ["#{zip}","#{units}","#{year}",'0'],['0','0','0','0'] ]}}, GlobalParameters: {}}

    url = 'https://ussouthcentral.services.azureml.net/workspaces/a1e2d213b96746008d92b0ae9b20ac8e/services/1209d6f6216244e8b7deaa22616b131c/execute?api-version=2.0&details=true'
    api_key = 'H+6DtWyrP+os0tnqqSVMYsOUweRfKS7edQVRXmxa5joNiBGaZXiTTWZcL/Dr8PniuJGKHp5QkeaUzA1bWiJDEQ==' # Replace this with the API key for the web service

    headers = { 'Content-Type' => 'application/json'}
    headers['Authorization'] = "Bearer #{api_key}"
    @result = HTTParty.post(url, :body => data.to_json, :headers => headers )
    @res = @result["Results"]["output1"]["value"]["Values"][0][4] #note: 1 is -ve 0 is +ve
    if @res == "1"
      vote = 'negative'
    else
      vote = 'positive'
    end
    redirect_to :controller => 'homes', :action => 'index', :vote => "#{vote}"
  end

  def about
  end

end
