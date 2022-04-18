Feature: Remover um usuário cadastrado
    Como uma pessoa qualquer
    Desejo remover um usuário
    Para que suas informações não estejam mais registradas

    Background: Configurar base url
        Given url baseUrl
        And path "users" 

    Scenario: Remover um usuário cadastrado pelo identificador único        
        * def usuario = { name: "Rosicléia Sales", email: "#(java.util.UUID.randomUUID() + '@email.com')" }
        Given request usuario
        When method post
        Then status 201
        * def idUsuario = response.id
               
        Given path "users", idUsuario
        When method delete
        Then status 204

        Given path "users", idUsuario
        When method get
        Then status 404
  
    Scenario: Não deve remover o usuário se o identificador único for inválido       
        Given path "identificador-invalido"
        When method delete
        Then status 400

    Scenario: Deve responder como se tivesse removido um usuário se não for localizado pelo identificador único
        * def idUsuario = java.util.UUID.randomUUID() + ''
        Given path idUsuario
        When method delete
        Then status 204