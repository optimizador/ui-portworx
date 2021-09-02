require 'sinatra'
require 'rest-client'

set(:cookie_options) do
    { :expires => Time.now + 30*60 }
end

get '/menu' do
  redirect "https://ui.9sxuen7c9q9.us-south.codeengine.appdomain.cloud//"
end

get '/' do
  logger = Logger.new(STDOUT)
  logger.info(request)
  @name = "PORTWORX"
  respuesta = []
  response.set_cookie("llave", value: "valor")
  erb :portworx , :locals => {:respuesta => respuesta}
end

get '/portworx-precio' do

  logger = Logger.new(STDOUT)
  logger.info("Parámetros para dimensionamiento portworx:\n")

  region="#{params['region']}"
  tipo="#{params['tipo']}"
  workers="#{params['workers']}"

  logger.info("Parámetros: region: #{region}, tipo: #{tipo}, workersa: #{workers}")

  urlapi="https://apis-portworx.9sxuen7c9q9.us-south.codeengine.appdomain.cloud"

  request = "#{urlapi}/api/v1/portworxprecio?region=#{region}&tipo=#{tipo}&workers=#{workers}"
  logger.info(request)
  respuesta = RestClient.get "#{request}", {:params => {}}
  respuesta = JSON.parse(respuesta.to_s)
  logger.info(respuesta)
  
  erb :portworx , :locals => {:respuesta => respuesta}
end



