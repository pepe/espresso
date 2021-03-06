module ECoreTest__ActionAlias

  class AnyRequestMethod < E

    action_alias 'some-url', :endpoint
    action_alias 'some-another/url', :endpoint

    def index
    end

    def endpoint
    end
  end

  class SpecificRequestMethod < E

    action_alias 'some-url', :get_endpoint
    action_alias 'some-another/url', :get_endpoint

    def index
    end

    def get_endpoint
    end
  end

  class PrivateZone < E

    action_alias 'some-url', :private_method
    action_alias 'some-another/url', :private_method

    def index
    end

    protected
    def protected_method

    end
    private
    def private_method
    end
  end

  Spec.new AnyRequestMethod do

    Testing do
      ['endpoint', 'some-url', 'some-another/url'].each do |url|
        get url
        is(last_response).ok?

        post url
        is(last_response).ok?
      end

      get '/blah'
      is(last_response).not_found?
    end
  end

  Spec.new SpecificRequestMethod do

    Testing  do
      ['endpoint', 'some-url', 'some-another/url'].each do |url|
        get url
        is(last_response).ok?

        post url
        is(last_response).not_found?
      end

      get '/blah'
      is(last_response).not_found?
    end
  end

  Spec.new PrivateZone do

    Testing do
      ['some-url', 'some-another/url'].each do |url|
        get url
        is(last_response).ok?

        post
        is(last_response).ok?
      end

      %w(private_method protected_method blah).each do |m|
        get "/#{m}"
        is(last_response).not_found?
      end
    end
  end

end
