Feature: Remover um usuário cadastrado
    Como uma pessoa qualquer
    Desejo remover um usuário
    Para que suas informações não estejam mais registradas

    Background: Configurar base url
        Given url baseUrl
        And path "users" 

    Scenario: Remover um usuário cadastrado pelo identificador único        
        * def usuario = call read("cadastroUsuario.feature")

        Given path usuario.response.id
        When method delete
        Then status 204

        Given path "users", usuario.response.id
        When method get
        Then status 404
  
    Scenario: Não deve ser possível remover um usuário se o identificador único for inválido       
        Given path "id-invalido"
        When method delete
        Then status 400

    Scenario: Deve responder como se tivesse removido um usuário se não for localizado pelo identificador único
        * def idUsuario = java.util.UUID.randomUUID().toString()
        Given path idUsuario
        When method delete
        Then status 204