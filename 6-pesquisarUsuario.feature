Feature: Pesquisar um usuário cadastrado por nome ou e-mail
    Como uma pessoa qualquer
    Desejo pesquisar usuário por nome ou e-mail
    Para ser capaz de encontrar um usuário cadastrado facilmente

    Background: Configurar base url
        Given url baseUrl

    Scenario: Pesquisar um usuário cadastrado pelo nome
        * def usuario = call read("cadastroUsuario.feature")

        Given path "search"
        And param value = usuario.response.name
        When method get
        Then status 200
        And match response == "#array"
        And match response[0] contains { id: "#uuid", name: "#string", email: "#string", createdAt: "#string", updatedAt: "#string" }
        And assert response[0].id == usuario.response.id
        And assert response[0].name == usuario.response.name
        And assert response[0].email == usuario.response.email

    Scenario: Pesquisar um usuário cadastrado pelo email
        * def usuario = call read("cadastroUsuario.feature")

        Given path "search"
        And param value = usuario.response.email
        When method get
        Then status 200
        And match response == "#array"
        And match response[0] contains { id: "#uuid", name: "#string", email: "#string", createdAt: "#string", updatedAt: "#string" }
        And assert response[0].id == usuario.response.id
        And assert response[0].name == usuario.response.name
        And assert response[0].email == usuario.response.email