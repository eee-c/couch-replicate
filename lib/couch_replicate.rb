require 'restclient'

module CouchReplicate
  def self.version
    File.read(File.expand_path(File.dirname(__FILE__) + '/../VERSION')).chomp
  end

  def self.replicate(source_host, target_host, db)
    source = hostify(source_host)
    target = hostify(target_host)
    RestClient.post("#{source}/_replicate",
                    %Q|{"source":"#{db}", "target":"#{target}/#{db}", "continuous":true}|)
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
    return if n == db.length + 1
    (Array(hosts) + Array(hosts)[0..n]).each_cons(n+1) do |src, *n_hosts|
      self.replicate(src, n_hosts.last, db)
    end
  end

  protected
  def self.hostify(raw_host)
    host = raw_host.dup
    host.sub!(%r{/$}, '')
    unless host =~ /\:\d+$/
      host += ":5984"
    end
    unless host =~ %r{^http://}
      host = "http://" + host
    end
    host
  end
end
