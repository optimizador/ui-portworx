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
  respuesta_portworx = []
  respuesta_etcd = []
  respuesta_storage = []
  response.set_cookie("llave", value: "valor")
  erb :portworx , :locals => {:respuesta_portworx => respuesta_portworx, :respuesta_etcd => respuesta_etcd, :respuesta_storage => respuesta_storage}
end

get '/portworx-precio' do

  logger = Logger.new(STDOUT)

  #PORTWORX

  logger.info("Dimensionamiento portworx:\n")

  region="#{params['region']}"
  tipo="#{params['tipo']}"
  workers="#{params['workers']}"

  logger.info("Parámetros portworx: region: #{region}, tipo: #{tipo}, workers: #{workers}")

  urlapi = "https://apis-portworx.9sxuen7c9q9.us-south.codeengine.appdomain.cloud"
  urlapi2 = "https://apis.9sxuen7c9q9.us-south.codeengine.appdomain.cloud"

  request = "#{urlapi}/api/v1/portworxprecio?region=#{region}&tipo=#{tipo}&workers=#{workers}"
  logger.info(request)
  respuesta_portworx = RestClient.get "#{request}", {:params => {}}
  respuesta_portworx = JSON.parse(respuesta_portworx.to_s)
  logger.info(respuesta_portworx)

#STORAGE
  iops = "#{params['iops']}"
  region_storage = "#{params['region_storage']}"
  storage = "#{params['storage_block']}".to_i
  replicas="#{params['replicas']}".to_i
  total_storage = storage * replicas

  logger.info("Parámetros Block Storage: region: #{region_storage}, iops: #{iops}, replicas: #{replicas}, total storage: #{total_storage}")

  request= "#{urlapi2}/api/v1/sizingblockstorage?region=#{region_storage}&iops=#{iops}&storage=#{total_storage}"
  logger.info(request)
  respuesta_storage = RestClient.get "#{request}", {:params => {}}
  respuesta_storage=JSON.parse(respuesta_storage.to_s)
  logger.info(respuesta_storage);
  
  #DB FOR ETCD

  region_etcd = "#{params['region_etcd']}"
  ram_etcd = "#{params['ram_etcd']}"
  storage_etcd ="#{params['storage_etcd']}"
  cores = "#{params['cores']}" 

  logger.info("Parámetros DB ETCD: region: #{region_etcd}, ram: #{ram_etcd}, storage: #{storage_etcd}, cores: #{cores}")

  request_etcd = "#{urlapi}/api/v1/dbforetcdprecio?region=#{region_etcd}&ram=#{ram_etcd}&storage=#{storage_etcd}&cores=#{cores}"
  logger.info(request)
  respuesta_etcd = RestClient.get "#{request_etcd}", {:params => {}}
  respuesta_etcd = JSON.parse(respuesta_etcd.to_s)
  logger.info(respuesta_etcd)

  total = respuesta_portworx[0]["precio"].to_f + respuesta_storage[0]["preciounidadrestante"].to_f + respuesta_storage[0]["precio"].to_f + respuesta_etcd[0]["precio"].to_f
  logger.info("Total a pagar: #{total}")
  
  erb :portworx , :locals => {:respuesta_portworx => respuesta_portworx, :respuesta_etcd => respuesta_etcd, :respuesta_storage => respuesta_storage, :total =>total}
end



