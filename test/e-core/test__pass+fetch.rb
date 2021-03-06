module ECoreTest__Pass

  module Cms
    class Page < E
      map '/'

      def index key, val
        pass :destination, key, val
        puts 'this should not be happen'
        raise :something
      end

      def post_index key, val
        pass :post_destination, key, val
      end

      def custom_query_string key, val
        pass :destination, key, val, key => val
      end

      def destination key, val
        [[key, val], params].inspect
      end

      def post_destination key, val
        [[key, val], params].inspect
      end

      def inner_app action, key, val
        pass InnerApp, action.to_sym, key, val
      end

      def get_invoke action, key, val
        s,h,b = invoke(InnerApp, action.to_sym, key, val)
        [s, b.body].join('/')
      end

      def get_fetch action, key, val
        fetch(InnerApp, action.to_sym, key, val)
      end
    end

    class InnerApp < E
      map '/'

      def catcher key, val
        [[key, val].join('='), params.to_a.map {|e| e.join('=')}].join('/')
      end
    end
  end

  Spec.new self do
    app Cms.mount

    ARGS   = ["k", "v"]
    PARAMS = {"var" => "val"}

    def args
      ARGS.join('/')
    end

    def params
      PARAMS.dup
    end

    Testing :get_pass do
      get args, params
      refute(last_response.body) =~ /index/
      is([ARGS, PARAMS].inspect).current_body?
    end

    Testing :post_pass do
      post args, params
      is([ARGS, PARAMS].inspect).current_body?
    end

    Testing :custom_query_string do
      get :custom_query_string, args, params
      is([ARGS, {ARGS.first => ARGS.last}].inspect).current_body?
    end

    Testing :inner_app do
      get :inner_app, :catcher, args, params
      is("k=v/var=val").current_body?
    end

    Testing :invoke do
      get :invoke, :catcher, args, params
      is("200/k=v/var=val").current_body?
    end

    Testing :fetch do
      get :fetch, :catcher, args, params
      is("k=v/var=val").current_body?
    end

  end
end
