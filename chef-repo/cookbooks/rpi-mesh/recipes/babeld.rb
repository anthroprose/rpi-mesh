git "#{node['babeld']['dir']}/" do
  repository "git://github.com/jech/babeld.git"
  branch "master"
  action :sync
  user 'root'
  group 'root'
end