bash "fish keys" do
  code <<-EOH
gpg --keyserver keyserver.ubuntu.com --recv-key D880C8E4
gpg -a --export D880C8E4 | apt-key add -
EOH
  action :nothing
end

execute "apt-get update" do
  action :nothing
end

cookbook_file "/etc/apt/sources.list.d/fish_shell.list" do
  source "fish_shell.list"
  mode 0644
  owner "root"
  group "root"
  notifies :run, resources(:bash => "fish keys", :execute => "apt-get update"), :immediately
end

%w{fish}.each do |package|
  package "#{package}" do
    action :install
  end
end

bash "make_default_shell" do
  user "root"
  code <<-EOH
    chsh -s /usr/bin/fish
  EOH
  action :run
end
