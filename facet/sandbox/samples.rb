##
# save some sample ethscriptions.com requestions

require 'ethscribe'

net = Ethscribe::Api.goerli

nums = [455648]
nums.each do |num|
  data = net.ethscription( num )
  write_json( "./tmp/#{num}.json", data )
end

## by owner (contract)
addresses = [
     '0x82dd9ceed833f78d45dd54e2a3755e022b0bad70',
     '0x5f9c41c921db18ff0d3578680615e1783e93cc1e']
addresses.each do |address|
  data = net.ethscriptions_owned_by( address ) 

  write_json( "./tmp/address-#{address}.json", data)
end



puts "bye"

