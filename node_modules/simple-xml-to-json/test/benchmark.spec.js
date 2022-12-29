'use strict'

const { readXMLFile } = require('./testUtils')
const { convertXML } = require('../src/xmlToJson')
const { convert } = require('../src/converters/astToJson')

describe('transpiler', () => {
    it('Benchmarking the library', () => {
        const xmlInput = readXMLFile(__dirname + '/benchmark-input.xml')
        const start = performance.now()
        const iterations = 1000
        for (let i = 0; i < iterations; i++) {
            convertXML(xmlInput)
        }
        const end = performance.now()
        console.log(
            `avg exec time of ${iterations} iterations (in ms): ${
                (end - start) / iterations
            }`
        )
        expect(end - start).toBeGreaterThan(0)
    })
})
