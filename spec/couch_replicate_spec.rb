require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "CouchReplicate" do
  before(:each) do
    @src_host    = 'http://couch01.example.org:5984'
    @target_host = 'http://couch02.example.org:5984'
    @db  = 'test'
  end

  it "should be able to tell a node to replicate itself" do
    RestClient.
      should_receive(:post).
      with("#{@src_host}/_replicate",
           %Q|{"source":"#{@db}", "target":"#{@target_host}/#{@db}", "continuous":true}|)

    CouchReplicate.replicate(@src_host, @target_host, @db)
  end

  context "replicating to multiple hosts" do
    before(:each) do
      @host01 = 'http://couch01.example.org:5984'
      @host02 = 'http://couch02.example.org:5984'
      @host03 = 'http://couch03.example.org:5984'
      @host04 = 'http://couch04.example.org:5984'
      @host05 = 'http://couch05.example.org:5984'

      CouchReplicate.stub!(:replicate)
    end

    it "should replicate in a circle" do
      CouchReplicate.
        should_receive(:replicate).
        with(@host03, @host01, @db)

      CouchReplicate.link(@db, [@host01, @host02, @host03])
    end

    it "should replicate in pairs" do
      CouchReplicate.
        should_receive(:replicate).
        with(@host02, @host03, @db)

      CouchReplicate.link(@db, [@host01, @host02, @host03])
    end

    it "should be able to reverse link" do
      CouchReplicate.
        should_receive(:link).
        with(@db, [@host03, @host02, @host01])

      CouchReplicate.reverse_link(@db, [@host01, @host02, @host03])
    end

    it "should replicate nth host" do
      CouchReplicate.
        should_receive(:replicate).
        with(@host02, @host05, @db)

      CouchReplicate.nth(3, @db, [@host01, @host02, @host03, @host04, @host05])
    end

    it "should replicate nth host in a circle" do
      CouchReplicate.
        should_receive(:replicate).
        with(@host05, @host03, @db)

      CouchReplicate.nth(3, @db, [@host01, @host02, @host03, @host04, @host05])
    end
  end
end
