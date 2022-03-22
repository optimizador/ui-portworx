require 'sinatra'
require 'rest-client'
require 'thin' 

set(:cookie_options) do
  { expires: Time.now + 30 * 60 }
end

get '/menu' do
  redirect 'http://169.57.7.203:30543/'
end

get '/' do
  logger = Logger.new(STDOUT)
  logger.info(request)
  @name = 'PORTWORX'
  respuesta_cluster = []
  respuesta_portworx = []
  respuesta_etcd = []
  respuesta_storage = []
  response.set_cookie('llave', value: 'valor')
  erb :portworx,
      locals: { respuesta_cluster: respuesta_cluster, respuesta_portworx: respuesta_portworx, respuesta_etcd: respuesta_etcd,
                respuesta_storage: respuesta_storage }
end

get '/portworx-precio' do
  logger = Logger.new(STDOUT)

  # CLUSTER
  logger.info("Dimensionamiento portworx:\n")

  urlapi = 'https://apis-portworx.ioi17ary7au.us-south.codeengine.appdomain.cloud'
  urlapi2 = 'https://apis.9sxuen7c9q9.us-south.codeengine.appdomain.cloud'

  tipo_cluster = params['cluster_type'].to_s # IKS o OCP
  cluster_workers = params['workers'].to_s
  cluster_region = params['region'].to_s
  infra_type = params['tipo'].to_s
  flavor = params['flavor'].to_s

  logger.info("Parámetros cluster: tipo: #{tipo_cluster}, workers: #{cluster_workers}, region: #{cluster_region}, infraestructura: #{infra_type}, flavor:#{flavor}")

  if tipo_cluster == 'ocp'
    request_cluster = "#{urlapi2}/api/v1/preciocluster?region=#{cluster_region}&wn=#{cluster_workers}&flavor=#{flavor}&infra_type=#{infra_type}"
    logger.info(request_cluster)
    respuesta_cluster = RestClient.get request_cluster.to_s, { params: {} }
    respuesta_cluster = JSON.parse(respuesta_cluster.to_s)
    logger.info(respuesta_cluster)
  end

  if tipo_cluster == 'iks'
    request_cluster = "#{urlapi2}/api/v1/ikspreciocluster?region=#{cluster_region}&wn=#{cluster_workers}&flavor=#{flavor}&infra_type=#{infra_type}"
    logger.info(request_cluster)
    respuesta_cluster = RestClient.get request_cluster.to_s, { params: {} }
    respuesta_cluster = JSON.parse(respuesta_cluster.to_s)
    logger.info(respuesta_cluster)
  end

  # PORTWORX

  region = cluster_region
  tipo = infra_type
  workers = cluster_workers

  logger.info("Parámetros portworx: region: #{region}, tipo: #{tipo}, workers: #{workers}")

  request = "#{urlapi}/api/v1/portworxprecio?region=#{region}&tipo=#{tipo}&workers=#{workers}"
  logger.info(request)
  respuesta_portworx = RestClient.get request.to_s, { params: {} }
  respuesta_portworx = JSON.parse(respuesta_portworx.to_s)
  logger.info(respuesta_portworx)

  # STORAGE
  iops = params['iops'].to_s
  region_storage = params['region_storage'].to_s
  storage = params['storage_block'].to_s.to_i
  replicas = params['replicas'].to_s.to_i
  total_storage = storage * replicas

  logger.info("Parámetros Block Storage: region: #{region_storage}, iops: #{iops}, replicas: #{replicas}, total storage: #{total_storage}")

  request = "#{urlapi2}/api/v1/sizingblockstorage?region=#{region_storage}&iops=#{iops}&storage=#{total_storage}"
  logger.info(request)
  respuesta_storage = RestClient.get request.to_s, { params: {} }
  respuesta_storage = JSON.parse(respuesta_storage.to_s)
  logger.info(respuesta_storage)

  # DB FOR ETCD

  region_etcd = params['region_etcd'].to_s
  ram_etcd = params['ram_etcd'].to_s
  storage_etcd = params['storage_etcd'].to_s
  cores = params['cores'].to_s

  logger.info("Parámetros DB ETCD: region: #{region_etcd}, ram: #{ram_etcd}, storage: #{storage_etcd}, cores: #{cores}")

  request_etcd = "#{urlapi}/api/v1/dbforetcdprecio?region=#{region_etcd}&ram=#{ram_etcd}&storage=#{storage_etcd}&cores=#{cores}"
  logger.info(request)
  respuesta_etcd = RestClient.get request_etcd.to_s, { params: {} }
  respuesta_etcd = JSON.parse(respuesta_etcd.to_s)
  logger.info(respuesta_etcd)

  total = respuesta_cluster[0]['precio'].to_f + respuesta_portworx[0]['precio'].to_f + respuesta_storage[0]['preciounidadrestante'].to_f + respuesta_storage[0]['precio'].to_f + respuesta_etcd[0]['precio'].to_f
  logger.info("Total a pagar: #{total}")

  erb :portworx,
      locals: { respuesta_cluster: respuesta_cluster, respuesta_portworx: respuesta_portworx, respuesta_etcd: respuesta_etcd,
                respuesta_storage: respuesta_storage, total: total }
end
