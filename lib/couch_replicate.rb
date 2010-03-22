require 'restclient'

module CouchReplicate

  def self.replicate(source_host, target_host, db)
    RestClient.post("#{source_host}/_replicate",
                    %Q|{"source":"#{db}", "target":"#{target_host}/#{db}", "continuous":true}|)
  end

  def self.link(db, hosts)
    Array(hosts).each_cons(2) do |src, target|
      self.replicate(src, target, db)
    end
    self.replicate(hosts.last, hosts.first, db)
  end

  def self.reverse_link(db, hosts)
    self.link(db, hosts.reverse)
  end

  def self.nth(n, db, hosts)
    (Array(hosts) + Array(hosts)[0..n]).each_cons(n+1) do |src, *n_hosts|
      self.replicate(src, n_hosts.last, db)
    end
  end
end
