
Feature: Cadastrar um novo usuário
    Como uma pessoa qualquer
    Desejo registrar informações de usuário
    Para poder manipular estas informações livremente

    Background: Base url 
        Given url baseUrl
        And path "users"
      
    Scenario: Cadastrar um novo usuário com sucesso
        * def usuario = { name: "Rosicléia Sales", email: "rosicleia@email.com" }
        Given request usuario
        When method post
        Then status 201
        And match response contains {id: "#uuid", name: "#string", email: "#string", createdAt: "#string", updatedAt: "#string"}
        And assert response.name == usuario.name        
        And assert response.email == usuario.email     

    Scenario: Não deve ser possível cadastrar um usuário com e-mail já utilizado no cadastro de outro usuário
        * def usuario = { name: "Rosicléia Sales", email: "rosicleia@email.com" }
        Given request usuario
        When method post
        Then status 422
        And assert response.error == "User already exists."   
   
    Scenario: Não deve ser possível cadastrar um usuário sem o nome
        * def usuario = { email:"rosicleia@email.com" }
        Given request usuario
        When method post
        Then status 400
   
    Scenario: Não deve ser possível cadastrar um usuário sem o e-mail
        * def usuario = { nome: "Rosicléia Sales" }
        Given request usuario
        When method post
        Then status 400

    Scenario: Não deve ser possível cadastrar um usuário com e-mail inválido
        * def usuario = { name: "Rosicléia Sales", email:"rosicleia.com.br" }
        Given request usuario
        When method post
        Then status 400

    Scenario: Não deve ser possível cadastrar um nome com mais de 100 caracteres
        * def usuario = { nome:"Pedro de Alcântara João Carlos Leopoldo Salvador Bibiano Francisco Xavier de Paula Leocádio Miguel Gabriel Rafael Gonzaga de Bragança e Bourbon", email:"teste.123@email.com" }
        Given request usuario
        When method post
        Then status 400

    Scenario: Não deve ser possível cadastrar um e-mail com mais de 60 caracteres
        * def usuario = { nome:"Pedro Alcantara", email:"Pedro.Alcantara.Joao.Carlos.Leopoldo.Salvador.Bibiano.Francisco.Xavier@email.com" }
        Given request usuario
        When method post
        Then status 400