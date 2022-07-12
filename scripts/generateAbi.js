const fs = require('fs');
const solc = require('solc');

var input = {
  language: 'Solidity',
  sources: {
    'IPyth.sol': {
      content: fs.readFileSync('IPyth.sol').toString()
    }
  },
  settings: {
    outputSelection: {
      'IPyth.sol': {
        'IPyth': ['abi']
      }
    }
  }
};

function findImports(path) {
  return {
    contents: fs.readFileSync(path).toString()
  };
}

const output = JSON.parse(solc.compile(JSON.stringify(input), { import: findImports }));
const abi = output.contracts['IPyth.sol'].IPyth.abi;

fs.writeFileSync('IPythAbi.json', JSON.stringify(abi, null, 2));
