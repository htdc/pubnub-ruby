require 'spec_helper'
require 'rr'
require 'stringio'
require 'webmock/rspec'

describe '.publish' do
  before do
    @output = StringIO.new
    @callback = lambda { |envelope|
      @output.write envelope.response
      EM.stop if EM.reactor_running?
    }
    @pn = Pubnub.new(:publish_key => :demo, :subscribe_key => :demo)
    @pn.session_uuid = nil
  end

  context 'when it gets server error' do
    context 'via http' do
      context 'and response message is usable' do
        context 'and it\'s synchronous' do
          it 'fires given callback on response envelope' do
            my_response = '[0,"Message Too Large","13619441967053834"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22Soooolooong%22').
                to_return(
                :body => [0,"Message Too Large","13619441967053834"].to_json,
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'Soooolooong', :channel => :hello_world, :callback => @callback, :http_sync => true)

            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on response envelope' do
            my_response = '[0,"Message Too Large","13619441967053834"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22Soooolooong%22').
                to_return(
                :body => [0,"Message Too Large","13619441967053834"].to_json,
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'Soooolooong', :channel => :hello_world, :callback => @callback, :http_sync => true, &@callback)

            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end

        context 'and it\'s asynchronous' do
          it 'fires given callback on response envelope' do
            my_response = '[0,"Message Too Large","13619441967053834"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22Soooolooong%22').
                to_return(
                :body => [0,"Message Too Large","13619441967053834"].to_json,
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'Soooolooong', :channel => :hello_world, :callback => @callback, :http_sync => false)
            while EM.reactor_running? do end

            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on response envelope' do
            my_response = '[0,"Message Too Large","13619441967053834"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22Soooolooong%22').
                to_return(
                :body => [0,"Message Too Large","13619441967053834"].to_json,
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'Soooolooong', :channel => :hello_world, :http_sync => false, &@callback)
            while EM.reactor_running? do end

            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end
      end

      context 'and response message is not usable' do
        context 'and it\'s synchronous' do
          it 'fires given callback on hardcoded envelope' do
            my_response = '[0, "Bad server response: 500"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22SomethingWrong%22').
                to_return(
                :body => '23e4eduf58$#%YHRE%#',
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'SomethingWrong', :channel => :hello_world, :callback => @callback, :http_sync => true)
            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on hardcoded envelope' do
            my_response = '[0, "Bad server response: 500"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22SomethingWrong%22').
                to_return(
                :body => '23e4eduf58$#%YHRE%#',
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'SomethingWrong', :channel => :hello_world, :http_sync => true, &@callback)
            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end

        context 'and it\'s asynchronous' do
          it 'fires given callback on hardcoded envelope' do

            my_response = '[0, "Bad server response: 500"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22SomethingWrong%22').
                to_return(
                :body => '23e4eduf58$#%YHRE%#',
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'SomethingWrong', :channel => :hello_world, :callback => @callback)
            while EM.reactor_running? do end
            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on hardcoded envelope' do

            my_response = '[0, "Bad server response: 500"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22SomethingWrong%22').
                to_return(
                :body => '23e4eduf58$#%YHRE%#',
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'SomethingWrong', :channel => :hello_world, &@callback)
            while EM.reactor_running? do end
            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end
      end
    end

    context 'via https' do
      before do
        @pn.ssl = true
      end
      context 'and response message is usable' do
        context 'and it\'s synchronous' do
          it 'fires given callback on response envelope' do
            my_response = '[0,"Message Too Large","13619441967053834"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22Soooolooong%22').
                to_return(
                :body => [0,"Message Too Large","13619441967053834"].to_json,
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'Soooolooong', :channel => :hello_world, :callback => @callback, :http_sync => true)

            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on response envelope' do
            my_response = '[0,"Message Too Large","13619441967053834"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22Soooolooong%22').
                to_return(
                :body => [0,"Message Too Large","13619441967053834"].to_json,
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'Soooolooong', :channel => :hello_world, :callback => @callback, :http_sync => true, &@callback)

            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end

        context 'and it\'s asynchronous' do
          it 'fires given callback on response envelope' do
            my_response = '[0,"Message Too Large","13619441967053834"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22Soooolooong%22').
                to_return(
                :body => [0,"Message Too Large","13619441967053834"].to_json,
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'Soooolooong', :channel => :hello_world, :callback => @callback, :http_sync => false)
            while EM.reactor_running? do end

            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on response envelope' do
            my_response = '[0,"Message Too Large","13619441967053834"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22Soooolooong%22').
                to_return(
                :body => [0,"Message Too Large","13619441967053834"].to_json,
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'Soooolooong', :channel => :hello_world, :http_sync => false, &@callback)
            while EM.reactor_running? do end

            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end
      end

      context 'and response message is not usable' do
        context 'and it\'s synchronous' do
          it 'fires given callback on hardcoded envelope' do
            my_response = '[0, "Bad server response: 500"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22SomethingWrong%22').
                to_return(
                :body => '23e4eduf58$#%YHRE%#',
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'SomethingWrong', :channel => :hello_world, :callback => @callback, :http_sync => true)
            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on hardcoded envelope' do
            my_response = '[0, "Bad server response: 500"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22SomethingWrong%22').
                to_return(
                :body => '23e4eduf58$#%YHRE%#',
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'SomethingWrong', :channel => :hello_world, :http_sync => true, &@callback)
            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end

        context 'and it\'s asynchronous' do
          it 'fires given callback on hardcoded envelope' do

            my_response = '[0, "Bad server response: 500"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22SomethingWrong%22').
                to_return(
                :body => '23e4eduf58$#%YHRE%#',
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'SomethingWrong', :channel => :hello_world, :callback => @callback)
            while EM.reactor_running? do end
            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on hardcoded envelope' do

            my_response = '[0, "Bad server response: 500"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22SomethingWrong%22').
                to_return(
                :body => '23e4eduf58$#%YHRE%#',
                :status => 500,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'SomethingWrong', :channel => :hello_world, &@callback)
            while EM.reactor_running? do end
            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end
      end
    end
  end

  context 'it publish correct message' do
    context 'without cipher_key' do
      context 'via http' do
        context 'and it\'s asynchronous' do
          it 'fires given callback on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22good_times%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, :callback => @callback)
            while EM.reactor_running? do end
            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22good_times%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, &@callback)
            while EM.reactor_running? do end
            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end

        context 'and it\'s synchronous' do
          it 'fires given callback on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22good_times%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, :callback => @callback, :http_sync => true)
            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22good_times%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, :http_sync => true, &@callback)
            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end
      end

      context 'via https' do
        before do
          @pn.ssl = true
        end
        context 'and it\'s asynchronous' do
          it 'fires given callback on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22good_times%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, :callback => @callback)
            while EM.reactor_running? do end
            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22good_times%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, &@callback)
            while EM.reactor_running? do end
            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end

        context 'and it\'s synchronous' do
          it 'fires given callback on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22good_times%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, :callback => @callback, :http_sync => true)
            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22good_times%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, :http_sync => true, &@callback)
            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end
      end
    end

    context 'using cipher_key' do
      before do
        @pn.cipher_key = 'enigma'
      end
      context 'via http' do
        context 'and it\'s asynchronous' do
          it 'fires given callback on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22f15upEZgHvh6rSP0xi/c1g==%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, :callback => @callback)
            while EM.reactor_running? do end
            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22f15upEZgHvh6rSP0xi/c1g==%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, &@callback)
            while EM.reactor_running? do end
            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end

        context 'and it\'s synchronous' do
          it 'fires given callback on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22f15upEZgHvh6rSP0xi/c1g==%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, :callback => @callback, :http_sync => true)
            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'http://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22f15upEZgHvh6rSP0xi/c1g==%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, :http_sync => true, &@callback)
            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end
      end

      context 'via https' do
        before do
          @pn.ssl = true
        end
        context 'and it\'s asynchronous' do
          it 'fires given callback on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22f15upEZgHvh6rSP0xi/c1g==%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, :callback => @callback)
            while EM.reactor_running? do end
            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22f15upEZgHvh6rSP0xi/c1g==%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, &@callback)
            while EM.reactor_running? do end
            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end

        context 'and it\'s synchronous' do
          it 'fires given callback on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22f15upEZgHvh6rSP0xi/c1g==%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, :callback => @callback, :http_sync => true)
            @output.seek(0)
            assert_equal my_response, @output.read
          end

          it 'fires given block on response envelope' do
            my_response = '[1,"Sent","13692992007063494"]'

            stub_request(:get, 'https://pubsub.pubnub.com/publish/demo/demo/0/hello_world/0/%22f15upEZgHvh6rSP0xi/c1g==%22').
                to_return(
                :body => [1,"Sent","13692992007063494"].to_json,
                :status => 200,
                :headers => {
                    'Content-Type' => 'text/javascript; charset="UTF-8"'
                }
            )

            @pn.publish(:publish_key => :demo, :message => 'good_times', :channel => :hello_world, :http_sync => true, &@callback)
            @output.seek(0)
            assert_equal my_response, @output.read
          end
        end
      end
    end
  end
end