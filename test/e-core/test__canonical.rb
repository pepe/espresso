module ECoreTest__Canonical

  class App < E
    map '/', '/cms', '/pages'

    def index
     rq.path
    end

    def post_eatme
      rq.path
    end

  end

  module Hlp
    def pass_validation? variations
      variations.each do |args|
        self.send(args[0], *args[1])
        is(args[2]).ok_body?
      end
    end
  end

  Spec.new self do
    include Hlp
    app(App.mount '/', '/a')

    Testing "base_url" do
      variations = [
        [:get, [:index], '/index'],
        [:get, [], '/'],
        [:post, [:eatme], '/eatme'],
      ]

      does(variations).pass_validation?
    end

    Testing "controller_canonicals" do
      variations = [
        [:get, [:cms, :index], '/cms/index'],
        [:get, [:cms], '/cms'],
        [:post, [:cms, :eatme], '/cms/eatme'],
        [:get, [:pages, :index], '/pages/index'],
        [:get, [:pages], '/pages'],
        [:post, [:pages, :eatme], '/pages/eatme'],
      ]

      does(variations).pass_validation?
    end

  end

  Spec.new self do
    include Hlp
    app(App.mount '/', '/a')

    Testing :app_canonicals do
      variations = [
        [:get, [:a], '/a'],
        [:get, [:a, :cms], '/a/cms'],
        [:get, [:a, :cms, :index], '/a/cms/index'],
        [:get, [:a, :pages, :index], '/a/pages/index'],
        [:get, [:a, :pages], '/a/pages'],
        [:post, [:a, :pages, :eatme], '/a/pages/eatme'],
      ]

      does(variations).pass_validation?
    end

  end
end
