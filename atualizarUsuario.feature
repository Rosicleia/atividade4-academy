Feature: Atualizar um usuário cadastrado
    Como uma pessoa qualquer
    Desejo atualizar as informações de determinado usuário
    Para ter o registro de suas informações atualizadas

    Background: Configurar base url
        Given url "https://crud-api-academy.herokuapp.com/api/v1"
        And path "users"
        * configure logPrettyResponse = true       


    Scenario: Atualizar informações de um usuário cadastrado
        # Função para gerar e-mail aleatório java.util.UUID.randomUUID() + '@email.com'
        * def usuario = { name: "Rosicléia Sales", email: "#(java.util.UUID.randomUUID() + '@email.com')" }
        Given request usuario
        When method post
        Then status 201
        * def resposta = response

        * def atualizaUsuario = { name: "Rosicléia", email: "#(java.util.UUID.randomUUID() + '@email.com')" }
        Given path "users", resposta.id
        And request atualizaUsuario
        When method put
        Then status 200
        And match response contains { id:"#uuid", name:"#string", email:"#string", createdAt:"#string", updatedAt:"#string" }
        And assert response.id == resposta.id
        And assert response.name == atualizaUsuario.name
        And assert response.email == atualizaUsuario.email
        And assert response.createdAt == resposta.createdAt
        And assert response.updatedAt > resposta.updatedAt

  
    Scenario: Não deve atualizar as informaões de um usuário se o identificador único for inválido
        * def atualizaUsuario = { name: "Rosicléia", email: "#(java.util.UUID.randomUUID() + '@email.com')" }   
        Given path "identificador-invalido"
        And request atualizaUsuario
        When method put
        Then status 400

    Scenario: Não deve atualizar as informações de um usuário se não for localizado pelo identificador único
        * def atualizaUsuario = { name: "Rosicléia", email: "#(java.util.UUID.randomUUID() + '@email.com')" }
        # Gerando um id aleatório válido que não esta cadastrado
        * def idUsuario = java.util.UUID.randomUUID() + ''
        Given path idUsuario
        And request atualizaUsuario
        When method put
        Then status 404

    Scenario: Não deve ser possível atualizar um usuário com e-mail inválido
        * def usuario = { name: "Rosicléia Sales", email: "#(java.util.UUID.randomUUID() + '@email.com')" }
        Given request usuario
        When method post
        Then status 201
        * def idUsuario = response.id
        
        * def atualizaUsuario = { name: "Rosicléia Sales", email:"rosicleia.com.br" }
        Given request atualizaUsuario
        And path "users", idUsuario
        When method put
        Then status 400

    Scenario: Não deve ser possível atualizar as informações de um usuário com e-mail já utilizado no cadastro de outro usuário
        * def usuario1 = { name: "Rosicléia Sales", email: "#(java.util.UUID.randomUUID() + '@email.com')" }
        * def usuario2 = { name: "Rosicléia Sales", email: "#(java.util.UUID.randomUUID() + '@email.com')" }
        
        Given request usuario1
        When method post
        Then status 201
        * def idUsuario1 = response.id

        Given request usuario2
        And path "users"
        When method post
        Then status 201
        * def idUsuario2 = response.id
        
        Given request usuario1
        And path "users", idUsuario2
        When method put
        Then status 422
        And assert response.error == "E-mail already in use." 

    Scenario: Não deve ser possível atualizar o nome do usuário com mais de 100 caracteres
        * def usuario = { name: "Rosicléia Sales", email: "#(java.util.UUID.randomUUID() + '@email.com')" }
        Given request usuario
        When method post
        Then status 201
        * def idUsuario = response.id

        * def atualizaUsuario = { nome:"Pedro de Alcântara João Carlos Leopoldo Salvador Bibiano Francisco Xavier de Paula Leocádio Miguel Gabriel Rafael Gonzaga de Bragança e Bourbon", email:"teste.123@email.com" }
        Given request atualizaUsuario
        And path "users", idUsuario
        When method put
        Then status 400

    Scenario: Não deve ser possível atualizar o e-mail do usuário com mais de 60 caracteres
        * def usuario = { name: "Rosicléia Sales", email: "#(java.util.UUID.randomUUID() + '@email.com')" }
        Given request usuario
        When method post
        Then status 201
        * def idUsuario = response.id
    
        * def atualizaUsuario = { nome:"Rosicléia Sales", email:"Pedro.Alcantara.Joao.Carlos.Leopoldo.Salvador.Bibiano.Francisco.Xavier@email.com" }
        Given request atualizaUsuario
        And path "users", idUsuario
        When method put
        Then status 400