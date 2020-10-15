# Zygo Programming Challenge

## Dependências
- Ruby 2.7.1
- Rails 6.0.3
- Bundler 1.17.2
- Yarn 1.22.10


## Instalação

### 1. Clone o repositório

```bash
git clone git@github.com:bzumpano/zygo.git
```

### 2. Crie e configure o banco de dados

```ruby
bundle exec rake db:create
bundle exec rake db:setup
```

### 3. Inicie o servidor

```ruby
bundle exec rails s
```

Agora basta acessar a url http://localhost:3000. No primeiro acesso você precisará cadastrar um usuário e senha para acessar a seção de livros.
