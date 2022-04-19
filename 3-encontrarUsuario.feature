Feature: Encontrar um usuário cadastrado
    Como uma pessoa qualquer
    Desejo consultar os dados de um usuário
    Para visualizar as informações deste usuário

    Background: Configurar base url
        Given url baseUrl
        And path "users"

    Scenario: Encontrar um usuário por Id
        * def usuario = call read("cadastroUsuario.feature")

        Given path usuario.response.id
        When method get
        Then status 200
        And match response contains { id:"#uuid", name:"#string", email:"#string", createdAt:"#string", updatedAt:"#string" }
        And assert response.id == usuario.response.id
        And assert response.name == usuario.response.name
        And assert response.email == usuario.response.email
  
    Scenario: Não deve ser possível encontrar um usuário se o identificador único for inválido     
        Given path "identificador-invalido"
        When method get
        Then status 400

    Scenario: Não deve ser possível encontrar um usuário se não for localizado pelo identificador único
        * def idUsuario = java.util.UUID.randomUUID().toString()
        Given path idUsuario
        When method get
        Then status 404