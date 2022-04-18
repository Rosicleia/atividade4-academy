Feature: Encontrar um usuário cadastrado
    Como uma pessoa qualquer
    Desejo consultar os dados de um usuário
    Para visualizar as informações deste usuário

    Background: Configurar base url
        Given url "https://crud-api-academy.herokuapp.com/api/v1"
        And path "users"
        * configure logPrettyResponse = true


    Scenario: Encontrar um usuário por Id
        # Função para gerar e-mail aleatório java.util.UUID.randomUUID() + '@email.com'
        * def usuario = { name: "Rosicléia Sales", email: "#(java.util.UUID.randomUUID() + '@email.com')" }
        Given request usuario
        When method post
        Then status 201
        * def idUsuario = response.id
        
        Given path "users"
        And path idUsuario
        When method get
        Then status 200
        And match response contains { id:"#uuid", name:"#string", email:"#string", createdAt:"#string", updatedAt:"#string" }
        And assert response.id == idUsuario
        And assert response.name == usuario.name
        And assert response.email == usuario.email
  
    Scenario: Não deve encontrar um usuário se o identificador único for inválido     
        Given path "identificador-invalido"
        When method get
        Then status 400

    Scenario: Não deve encontrar um usuário se não for localizado pelo identificador único
        # Gerando um id aleatório válido que não esta cadastrado
        * def idUsuario = java.util.UUID.randomUUID() + ''
        Given path idUsuario
        When method get
        Then status 404