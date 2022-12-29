'use strict'

const { Token, TOKEN_TYPE } = require('./model')
const EOF_TOKEN = Token('EOF')

const isCharBlank = (char) =>
    char === ' ' || char === '\n' || char === '\r' || char === '\t'

const skipXMLDocumentHeader = (xmlAsString, pos) => {
    if (xmlAsString.startsWith('<?xml', pos)) {
        const len = xmlAsString.length
        while (pos < len) {
            if (xmlAsString[pos] !== '?') {
                pos++
            } else if (xmlAsString[pos + 1] === '>') {
                return pos + 2 // skip "?>""
            } else {
                pos++
            }
        }
    }
    return pos
}

const replaceQuotes = (str) => str.replace(/'/g, '"')

const getInitialPosForLexer = (xmlAsString) => {
    let pos = 0
    while (pos < xmlAsString.length && isCharBlank(xmlAsString[pos])) pos++
    return skipXMLDocumentHeader(xmlAsString, pos)
}

function createLexer(xmlAsString) {
    let currentToken = null
    let pos = getInitialPosForLexer(xmlAsString)

    const peek = () => xmlAsString[pos]
    const hasNext = () => currentToken !== EOF_TOKEN && pos < xmlAsString.length
    const isBlankSpace = () => isCharBlank(xmlAsString[pos])

    const skipQuotes = () => {
        if (hasNext() && isQuote(peek())) pos++
    }

    const isQuote = (char) => '"' === char || "'" === char

    const skipSpaces = () => {
        while (hasNext() && isBlankSpace()) pos++
    }

    const readAlphaNumericCharsOrBrackets = (areSpecialCharsSupported) => {
        if (hasNext()) {
            if (xmlAsString[pos] === '<') {
                let buffer = '<'
                pos++
                if (hasNext() && xmlAsString[pos] === '/') {
                    pos++
                    buffer = '</'
                } else if (
                    hasNext() &&
                    xmlAsString[pos] === '!' &&
                    xmlAsString[pos + 1] === '-' &&
                    xmlAsString[pos + 2] === '-'
                ) {
                    // its a comment
                    pos++
                    pos++
                    pos++
                    buffer = '<!--'
                }
                return buffer
            } else if (xmlAsString[pos] === '=' || xmlAsString[pos] === '>') {
                const buffer = xmlAsString[pos]
                pos++
                return buffer
            }
        }
        return readAlphaNumericChars(!!areSpecialCharsSupported)
    }

    const readAlphaNumericChars = (areSpecialCharsSupported) => {
        const ELEMENT_TYPE_MATCHER = /[a-zA-Z0-9_:\-]/
        const NAMES_VALS_CONTENT_MATCHER = /[^>=<]/u
        const matcher = areSpecialCharsSupported
            ? NAMES_VALS_CONTENT_MATCHER
            : ELEMENT_TYPE_MATCHER
        let start = pos
        while (hasNext() && xmlAsString[pos].match(matcher)) pos++
        return replaceQuotes(xmlAsString.substring(start, pos))
    }

    const isElementBegin = () =>
        currentToken && currentToken.type === TOKEN_TYPE.OPEN_BRACKET
    const isAssignToAttribute = () =>
        currentToken && currentToken.type === TOKEN_TYPE.ASSIGN

    const next = () => {
        const prevPos = pos
        skipSpaces()
        const numOfSpacesSkipped = pos - prevPos
        if (!hasNext()) {
            currentToken = EOF_TOKEN
        } else if (isElementBegin()) {
            // starting new element
            skipSpaces()
            const buffer = readAlphaNumericCharsOrBrackets(false)
            currentToken = Token(TOKEN_TYPE.ELEMENT_TYPE, buffer)
        } else if (isAssignToAttribute()) {
            // assign value to attribute
            skipQuotes()
            let start = pos
            while (hasNext() && !isQuote(peek())) pos++
            const buffer = replaceQuotes(xmlAsString.substring(start, pos))
            pos++
            currentToken = Token(TOKEN_TYPE.ATTRIB_VALUE, buffer)
        } else {
            skipSpaces()
            let buffer = readAlphaNumericCharsOrBrackets(true)
            switch (buffer) {
                case '=': {
                    if (currentToken.type === TOKEN_TYPE.ATTRIB_NAME) {
                        currentToken = Token(TOKEN_TYPE.ASSIGN)
                    } else {
                        currentToken = Token(TOKEN_TYPE.CONTENT, buffer)
                    }
                    break
                }
                case '</': {
                    const start = pos
                    while (xmlAsString[pos] !== '>') pos++
                    currentToken = Token(
                        TOKEN_TYPE.CLOSE_ELEMENT,
                        xmlAsString.substring(start, pos)
                    )
                    pos++ // skip the ">"
                    break
                }
                case '<!--': {
                    // skipComment contents
                    const closingBuff = ['!', '-', '-']
                    while (
                        hasNext() &&
                        (closingBuff[2] !== '>' ||
                            closingBuff[1] !== '-' ||
                            closingBuff[0] !== '-')
                    ) {
                        closingBuff.shift()
                        closingBuff.push(xmlAsString[pos])
                        pos++
                    }
                    return next()
                }
                case '>': {
                    currentToken = Token(TOKEN_TYPE.CLOSE_BRACKET)
                    break
                }
                case '<': {
                    currentToken = Token(TOKEN_TYPE.OPEN_BRACKET)
                    break
                }
                default: {
                    // here we fall if we have alphanumeric string, which can be related to attributes, content or nothing
                    if (buffer && buffer.length > 0) {
                        if (currentToken.type === TOKEN_TYPE.CLOSE_BRACKET) {
                            let suffix = ''
                            if (peek() !== '<') {
                                suffix = readAlphaNumericChars(true)
                            }
                            currentToken = Token(
                                TOKEN_TYPE.CONTENT,
                                buffer + suffix
                            )
                        } else if (
                            currentToken.type !== TOKEN_TYPE.ATTRIB_NAME &&
                            currentToken.type !== TOKEN_TYPE.CONTENT
                        ) {
                            // it should be an attribute name token
                            currentToken = Token(TOKEN_TYPE.ATTRIB_NAME, buffer)
                        } else {
                            const contentBuffer =
                                ' '.repeat(numOfSpacesSkipped) + buffer // spaces included as content
                            currentToken = Token(
                                TOKEN_TYPE.CONTENT,
                                contentBuffer
                            )
                        }
                        break
                    } else {
                        const errMsg =
                            'Unknown Syntax : "' + xmlAsString[pos] + '"'
                        throw new Error(errMsg)
                    }
                }
            }
        }

        return currentToken
    }

    return {
        peek,
        next,
        hasNext
    }
}

module.exports = {
    createLexer
}
