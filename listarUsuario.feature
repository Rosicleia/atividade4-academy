Feature: Listar todos os usuários cadastrados
    Como uma pessoa qualquer
    Desejo consultar todos os usuários cadastrados
    Para ter as informações de todos os usuários

    Background: Configurar base url
        Given url baseUrl
        And path "users"
    
    Scenario: Listar todos os usuários cadastrados
        When method get
        Then status 200
        And match response == "#array"
        And match each response contains { id: "#uuid", name: "#string", email: "#string", createdAt: "#string", updatedAt: "#string" } 