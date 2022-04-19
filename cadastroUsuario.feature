@ignore
Feature: Cadastrar Usuário
    
    Background: Configurar base url
        Given url baseUrl

    Scenario: Cadastrar usuário     
        * def usuario = read("payloadCriacaoUsuario.json")
        Given path "users"
        And request usuario
        When method post
        Then status 201