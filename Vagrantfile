Vagrant.configure("2") do |config|
  # Define a imagem do sistema operacional (Box)
  config.vm.box = "bento/rockylinux-9"

  # Passo A: Configura o IP fixo para a rede privada
  config.vm.network "private_network", ip: "192.168.56.10"
end