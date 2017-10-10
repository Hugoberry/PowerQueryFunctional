// Use this file to write queries to test your data connector
let
    result = _.IChain(10, { {each _/2}, {Number.Power, 3} })
in
    result