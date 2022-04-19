Feature: Atualizar um usuário cadastrado
    Como uma pessoa qualquer
    Desejo atualizar as informações de determinado usuário
    Para ter o registro de suas informações atualizadas

    Background: Configurar base url
        Given url baseUrl
        And path "users"

    Scenario: Atualizar informações de um usuário cadastrado
        * def usuario = call read("cadastroUsuario.feature")
        * def atualizaUsuario = { name: "Usuário Atualizado", email: "#('email-atual' + java.util.UUID.randomUUID() + '@email.com')" }
        Given path usuario.response.id
        And request atualizaUsuario
        When method put
        Then status 200
        And match response contains { id:"#uuid", name:"#string", email:"#string", createdAt:"#string", updatedAt:"#string" }
        And assert response.id == usuario.response.id
        And assert response.name == atualizaUsuario.name
        And assert response.email == atualizaUsuario.email
        And assert response.createdAt == usuario.response.createdAt
        And assert response.updatedAt > usuario.response.updatedAt
  
    Scenario: Não deve ser possível atualizar as informaões de um usuário se o identificador único for inválido
        * def atualizaUsuario = { name: "Usuário Atualizado", email: "#('email-atual' + java.util.UUID.randomUUID() + '@email.com')" }
        Given path "id-invalido"
        And request atualizaUsuario
        When method put
        Then status 400

    Scenario: Não deve ser possível atualizar as informações de um usuário se não for localizado pelo identificador único
        * def atualizaUsuario = { name: "Usuário Atualizado", email: "#('email-atual' + java.util.UUID.randomUUID() + '@email.com')" }
        * def idUsuario = java.util.UUID.randomUUID().toString()
        Given path idUsuario
        And request atualizaUsuario
        When method put
        Then status 404

    Scenario: Não deve ser possível atualizar um usuário com e-mail inválido
        * def usuario = call read("cadastroUsuario.feature")        
        * def atualizaUsuario = { name: "Usuário Atualizado", email:"email-invalido.com.br" }
        Given path usuario.response.id 
        And request atualizaUsuario
        When method put
        Then status 400

    Scenario: Não deve ser possível atualizar as informações de um usuário com e-mail já utilizado no cadastro de outro usuário
        * def usuario1 = call read("cadastroUsuario.feature")
        * def usuario2 = call read("cadastroUsuario.feature")
        * def atualizaUsuario = { name: "#(usuario2.response.name)", email: "#(usuario2.response.email)" }
        
        Given path usuario1.response.id 
        And request atualizaUsuario
        When method put
        Then status 422
        And assert response.error == "E-mail already in use." 

    Scenario: Não deve ser possível atualizar o nome do usuário com mais de 100 caracteres
        * def usuario = call read("cadastroUsuario.feature")
        * def atualizaUsuario = { name: "Pedro de Alcântara João Carlos Leopoldo Salvador Bibiano Francisco Xavier de Paula Leocádio Miguel Gabriel Rafael Gonzaga de Bragança e Bourbon", email: "email-atualizado@email.com" }
        Given path usuario.response.id 
        And request atualizaUsuario
        When method put
        Then status 400

    Scenario: Não deve ser possível atualizar o e-mail do usuário com mais de 60 caracteres
        * def usuario = call read("cadastroUsuario.feature")    
        * def atualizaUsuario = { name: "Usuário Aualizado", email: "Pedro.Alcantara.Joao.Carlos.Leopoldo.Salvador.Bibiano.Francisco.Xavier@email.com" }
        Given path usuario.response.id
        And request atualizaUsuario
        When method put
        Then status 400