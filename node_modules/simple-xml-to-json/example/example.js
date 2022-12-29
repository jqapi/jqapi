'use strict'

const fs = require('fs')
const { convertXML } = require('../src/xmlToJson')

const xmlToConvert = fs.readFileSync(__dirname + '/example.xml', {
    encoding: 'UTF8'
})

const ANSI_RESET = '\u001b[0m'
const ANSI_BLUE = '\u001b[34m'
const ANSI_YELLOW = '\u001b[33m'

const blueText = (text) => `${ANSI_BLUE}${text}${ANSI_RESET}`
const yellowText = (text) => `${ANSI_YELLOW}${text}${ANSI_RESET}`

console.log(blueText('------ XML ------'))
console.log(xmlToConvert)
console.log('\n\n\n')

console.log(yellowText('------ JSON ------'))
console.log(JSON.stringify(convertXML(xmlToConvert), null, 4))
