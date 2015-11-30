Vagrant.configure("2") do |config|


  config.vm.define "primary", primary: true do |primary|

      primary.vm.box = "ubuntu/trusty64"

      primary.vm.provision :shell, path: "bootstrap.sh"

      primary.vm.provider :virtualbox do |vb|
          vb.gui = true
          vb.customize ["modifyvm", :id, "--memory", "2048", "--vram", "32", "--cpus", "2", "--usb", "off", "--usbehci", "off"]

      end

      primary.vm.network "public_network"
      primary.vm.network "private_network", ip: "192.168.0.5" 
      primary.vm.network :forwarded_port, guest: 80, host: 4321   

  end

  config.vm.define "dockerhost", autostart: false do |dockerhost|

      dockerhost.vm.box = "ubuntu/trusty64"

       dockerhost.vm.provider :virtualbox do |vb|
          vb.customize ["modifyvm", :id, "--memory", "2048"]
      end
=begin
      dockerhost.vm.provision "docker" do |d0|
        d0.build_image "/vagrant/app/Tomcat", args: "-t tomcat"
        d0.run "tomcat:latest", args: "--cap-add SYS_PTRACE -tipd 8083:8080 --name tomcat "
      end

      dockerhost.vm.provision "docker" do |d1|   
        d1.build_image "/vagrant/app/Master", args: "-t ubujenkins"
        d1.run "ubujenkins:latest", args: "-tipd 8080:8080 --name jenkins0"      
      end

      dockerhost.vm.provision "docker" do |d2|
        d2.build_image "/vagrant/app/Apachedocker", args: "-t ubuapache"
        d2.run "ubuapache:latest", args: "-tipd 8081:80 --name apachecontainer"
      end

      dockerhost.vm.provision "docker" do |d3|
        d3.build_image "/vagrant/app/Slave", args: "-t ubujenkinsgradle"
        d3.run "ubujenkinsgradle:latest", args: "-tid --name jenkins1 --link jenkins0"
      end

      dockerhost.vm.provision "docker" do |d4|
        d4.build_image "/vagrant/app/Docker", args: "-t dockerdocker"
        d4.run "dockerdocker:latest", args: "--privileged -tid --name docker0 --link jenkins0"
      end

      dockerhost.vm.provision "docker" do |d6|
        d6.build_image "/vagrant/app/TomcatWorker", args: "-t worker"
        d6.run "worker0", image: "worker:latest", args: "-v /vagrant/app/tomcatworker/index.html:/var/lib/tomcat7/webapps/ROOT/index.html -tipd 8090:8080 "
        d6.run "worker1", image: "worker:latest", args: "-v /vagrant/app/tomcatworker/index2.html:/var/lib/tomcat7/webapps/ROOT/index.html -tipd 8091:8080 "
        d6.run "worker2", image: "worker:latest", args: "-v /vagrant/app/tomcatworker/index3.html:/var/lib/tomcat7/webapps/ROOT/index.html -tipd 8092:8080 "
      end
=end
      dockerhost.vm.provision "docker" do |d7|
        d7.build_image "/vagrant/app/Apache", args: "-t apache"
        d7.run "apache", image: "apache:latest", args: "-v /vagrant/app/apache/index.html:/var/www/html/index.html -tipd 81:80"
        d7.run "apache2", image: "apache:latest", args: "-tipd 82:80"
      end

      dockerhost.vm.provision "docker" do |d8|
        d8.build_image "/vagrant/app/Nginx", args: "-t nginx"
        d8.run "nginx", image: "nginx:latest", args: "-tipd 80:80"
      end

      dockerhost.vm.provision :shell, path: "dockerhoststartup.sh"

      dockerhost.vm.network "private_network", ip: "192.168.0.6"
      dockerhost.vm.network :forwarded_port, guest: 8090, host: 8090
      dockerhost.vm.network :forwarded_port, guest: 8091, host: 8091
      dockerhost.vm.network :forwarded_port, guest: 8091, host: 8093
      dockerhost.vm.network :forwarded_port, guest: 8083, host: 8083
      dockerhost.vm.network :forwarded_port, guest: 8082, host: 8082
      dockerhost.vm.network :forwarded_port, guest: 8081, host: 8081
      dockerhost.vm.network :forwarded_port, guest: 8080, host: 8080

      dockerhost.vm.network :forwarded_port, guest: 80, host: 80
      dockerhost.vm.network :forwarded_port, guest: 81, host: 81
      dockerhost.vm.network :forwarded_port, guest: 82, host: 82

  end

  config.vm.define "tomcats", autostart: false do |tomcats|

      tomcats.vm.box = "ubuntu/trusty64"

      tomcats.vm.provision :shell, path: "tomcatstartup.sh"

      tomcats.vm.network "private_network", ip: "192.168.0.7"
      tomcats.vm.network :forwarded_port, guest: 80, host: 80
      tomcats.vm.network :forwarded_port, guest: 8101, host: 8101
      tomcats.vm.network :forwarded_port, guest: 8102, host: 8102
      tomcats.vm.network :forwarded_port, guest: 8103, host: 8103
      
  end
    
end

