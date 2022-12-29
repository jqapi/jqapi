'use strict'

const fs = require('fs')

const readXMLFile = (fileName) => {
    return fs.readFileSync(fileName, { encoding: 'utf8' })
}

module.exports = {
    readXMLFile
}
