'use strict'

const jsonConverter = require('./converters/astToJson')
const { transpile } = require('./transpiler')

function convertXML(xmlAsString, customConverter) {
    return transpile(xmlAsString, customConverter || jsonConverter)
}

function createAST(xmlAsString) {
    return transpile(xmlAsString)
}

module.exports = {
    convertXML,
    createAST
}
