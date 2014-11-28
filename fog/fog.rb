#!/usr/bin/env ruby
 
require 'fog'
require 'yaml'
 
class Server
  attr_accessor :api
  attr_accessor :name
  attr_accessor :provider
  attr_accessor :flavor_id
  attr_accessor :image_id
  attr_accessor :key_name
  attr_accessor :availability_zone
  attr_accessor :nics
  attr_accessor :subnet_id
  attr_accessor :security_group_ids
 
  def self.create_from_file(file)
    server_options = YAML.load_file(file)
    if server_options.class != Array  then
      server_options = [server_options]
    end
    servers = []
    server_options.each do |server_option| 
      server = Server.new(server_option)
      server.create
      servers.push server
    end
    return servers
  end
 
  def initialize(server_option = {})
    @provider = server_option["provider"]
    @name = server_option["name"]
    @flavor_id = server_option["flavor_id"]
    @image_id = server_option["image_id"]
    @key_name = server_option["key_name"]
    @availability_zone = server_option["availability_zone"]
    @nics = set_nics(server_option["networks"])
    @subnet_id = server_option["subnet_id"]
    @security_group_ids = server_option["security_group_ids"]
    @api = get_api()
  end
 
  def create()
    if @provider == "openstack" then
      @api.servers.create(
        :name => @name,
        :flavor_ref => @flavor_id,
        :image_ref => @image_id,
        :key_name => @key_name,
        :availability_zone => @availability_zone,
        :nics => @nics,
        :security_groups => @security_group_ids,
      )
    elsif @provider == "AWS" then
      @api.servers.create(
        :tags => {'Name' => @name},
        :flavor_id => @flavor_id,
        :image_id => @image_id,
        :key_name => @key_name,
        :groups => @security_group_ids,
      )
    end
  end
 
  def set_nics(networks = [])
    if @provider == "openstack" then
      network_api = get_network_api
      @nics = []
      networks.each do |network|
        @nics.push({"net_id" => network_api.networks.all(:name => network).first.id})
      end
    end
    return @nics
  end
 
  private
  def get_api()
    if @provider == "openstack" then
      Fog::Compute.new({
          :provider            => @provider,
          :openstack_auth_url  => ENV['OS_AUTH_URL'] || "",
          :openstack_username  => ENV['OS_USERNAME'] || "",
          :openstack_tenant    => ENV['OS_TENANT_NAME'] || "",
          :openstack_api_key   => ENV['OS_API_KEY'] || "",
          :openstack_region    => ENV['OS_REGION_NAME'] || ""
      })
    elsif @provider == "AWS" then
      Fog::Compute.new({
          :provider              => @provider,
          :aws_access_key_id     => ENV["AWS_ACCESS_KEY_ID"] || "",
          :aws_secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"] || "",
          :region                => ENV["AWS_REGION"] || ""
      })
    end
  end
 
  def get_network_api()
    Fog::Network.new({
        :provider            => @provider,
        :openstack_auth_url  => ENV['OS_AUTH_URL'] || "",
        :openstack_username  => ENV['OS_USERNAME'] || "",
        :openstack_tenant    => ENV['OS_TENANT_NAME'] || "",
        :openstack_api_key   => ENV['OS_API_KEY'] || "",
        :openstack_region    => ENV['OS_REGION_NAME'] || "",
    })
  end
end
 
Server.create_from_file(ARGV[0])
