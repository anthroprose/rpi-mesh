execute "hostname" do
  command "echo #{node['nginx']['default_domain']} > /etc/hostname;hostname -F /etc/hostname"
end

Array(node['dependencies']).each do |p|
  package p do
    action :install
  end
end

########################## NGINX

template "/etc/php5/cgi/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode "0655"
  variables()
end

directory "/etc/nginx/ssl/" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

Array(node['nginx']['sites']).each do |u|

	Chef::Log.info "Generating site configuration for: " << u['domain']

  if u.has_key?('uwsgi_port') then
  	template "/etc/uwsgi/apps-enabled/#{u['domain']}.ini" do
  	  source "uwsgi.erb"
  	  owner "root"
  	  group "root"
  	  variables(
  		:port => u['uwsgi_port'],
  		:directory => u['directory']
  	  )
  	end
	end
	
	template "/etc/nginx/sites-enabled/#{u['domain']}.conf" do
	  source "nginx-site.erb"
	  owner "root"
	  group "root"
	  variables(
		:uwsgi_port => u['uwsgi_port']||'',
		:directory => u['directory'],
		:domain => u['domain'],
		:proxy => u['proxy']||'false',
		:https => u['https']||'false',
		:proxy_location => u['proxy_location']||''
	  )
	  notifies :restart, "service[nginx]"
	end
	
  script "create-ssl-certs-#{u['domain']}" do
    not_if { File.exists?("/etc/nginx/ssl/#{u[:domain]}.crt") }
    interpreter "bash"
    timeout 3600
    user "root"
    group "root"
    cwd "/etc/nginx/ssl/"
    code <<-EOH
      openssl req -new -x509 -nodes -out /etc/nginx/ssl/#{u[:domain]}.crt -keyout /etc/nginx/ssl/#{u[:domain]}.key -subj \"/C=#{node[:nginx][:ssl][:country]}/ST=#{node[:nginx][:ssl][:state]}/L=#{node[:nginx][:ssl][:city]}/O=#{u[:domain]}/OU=#{u[:domain]}/CN=#{u[:domain]}/emailAddress=webmaster@#{u[:domain]}\"
    EOH
  end

end


if node['babeld']['dir'] != '' then

  include_recipe "rpi-mesh::babeld"

end
