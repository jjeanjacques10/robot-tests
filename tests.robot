*** Settings ***
Library        RequestsLibrary

*** Variables ***
${base_url}             https://pokeapi.co
${headers}              {'Content-Type': 'application/json'}


*** Keywords ***

When User Sends a GET Request
    [Arguments]    ${url}
    ${response}=    GET    ${base_url}${url}
    Log    ${response}
    [Return]    ${response}

Should Return Success Status Code
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    200

*** Test Cases ***

Get All Pokemons from API
    ${response}=    When User Sends a GET Request  /api/v2/pokemon
    Should Return Success Status Code  ${response}
    ${pokemons}=    Set Variable    ${response.json()}
    Log    ${pokemons}
    Log    ${pokemons['results'][0]['name']}
    Set Suite Variable    ${pokemon_name}    ${pokemons['results'][0]['name']}
    Set Suite Variable    ${pokemon_id}    ${pokemons['results'][0]['url'].split('/')[-2]}

Get Pokemon by Name
    ${response}=    When User Sends a GET Request  /api/v2/pokemon/${pokemon_name}
    Should Return Success Status Code  ${response}
    ${pokemon}=    Set Variable    ${response.json()}
    Log    ${pokemon}
    Log    ${pokemon['name']}
    Log    ${pokemon['weight']}
    Log    ${pokemon['height']}
    Log    ${pokemon['types'][0]['type']['name']}

Get Pokemon by ID
    ${response}=    When User Sends a GET Request  /api/v2/pokemon/${pokemon_id}
    Should Return Success Status Code  ${response}
    ${pokemon}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${pokemon['name']}    ${pokemon_name}    