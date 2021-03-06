module ECoreTest__AppMap

  class App < E

    def index
    end
  end

  class Cms < E
    map :pages

    def index
    end
  end

  class Foo < E
    map :bar

    def index
    end
  end

  Spec.new self do

    app EApp.new { map '/some/path'; mount App }

    get '/some/path/app'
    is(last_response).ok?

    app EApp.new { map '/some/another/path'; mount Cms }

    get '/some/another/path/pages'
    is(last_response).ok?

    app EApp.new { map '/yet/another/path'; mount Foo, '/blah' }

    get '/yet/another/path/blah/bar'
    is(last_response).ok?

  end
end
