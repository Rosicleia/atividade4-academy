Feature: Pesquisar um usuário cadastrado por nome ou e-mail
    Como uma pessoa qualquer
    Desejo pesquisar usuário por nome ou e-mail
    Para ser capaz de encontrar um usuário cadastrado facilmente

    Background: Configurar base url
        Given url baseUrl

    Scenario: Pesquisar um usuário cadastrado pelo nome        
        * def usuario = { name: "#('Rosicleia ' + (java.util.UUID.randomUUID() + '').substring(24))", email: "#(java.util.UUID.randomUUID() + '@email.com')" }
        * print usuario
        Given path "users"
        And request usuario
        When method post
        Then status 201
        * def resposta = response

        Given path "search"
        And param value = resposta.name
        When method get
        Then status 200
        And match response == "#array"
        And match response[0] contains { id: "#uuid", name: "#string", email: "#string", createdAt: "#string", updatedAt: "#string" } 
        And assert response[0].id == resposta.id
        And assert response[0].name == resposta.name
        And assert response[0].email == resposta.email

    Scenario: Pesquisar um usuário cadastrado pelo email        
        * def usuario = { name: "#('Rosicleia ' + (java.util.UUID.randomUUID() + '').substring(24))", email: "#(java.util.UUID.randomUUID() + '@email.com')" }
        * print usuario
        Given path "users"
        And request usuario
        When method post
        Then status 201
        * def resposta = response

        Given path "search"
        And param value = resposta.email
        When method get
        Then status 200
        And match response == "#array"
        And match response[0] contains { id: "#uuid", name: "#string", email: "#string", createdAt: "#string", updatedAt: "#string" } 
        And assert response[0].id == resposta.id
        And assert response[0].name == resposta.name
        And assert response[0].email == resposta.email



        