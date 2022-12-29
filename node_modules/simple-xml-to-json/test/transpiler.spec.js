'use strict'

const testUtils = require('./testUtils')
const { transpile, AttribNode, ElementNode } = require('../src/transpiler')
const { convertXML } = require('../src/xmlToJson')
const astToJson = require('../src/converters/astToJson')

const XML_HEADER = '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>'

describe('issues', () => {
    it('issue #17 - support special char ¬', () => {
        const json = convertXML('<a><child>hi ¬</child></a>')
        expect(json).toEqual({
            a: {
                children: [
                    {
                        child: {
                            content: 'hi ¬'
                        }
                    }
                ]
            }
        })
    })
})

describe('transpiler', () => {
    describe('to AST', () => {
        it('should convert a very simple XML to a simple AST', () => {
            const mockXML = '<a></a>'
            const ast = transpile(mockXML)
            expect(ast).toEqual({
                type: 'ROOT',
                value: {
                    children: [
                        {
                            type: 'ELEMENT',
                            value: {
                                type: 'a',
                                attributes: [],
                                children: []
                            }
                        }
                    ]
                }
            })
        })

        it('should convert a simple XML with content to a simple AST', () => {
            const mockXML = '<a>Hello content</a>'
            const ast = transpile(mockXML)
            expect(ast).toEqual({
                type: 'ROOT',
                value: {
                    children: [
                        {
                            type: 'ELEMENT',
                            value: {
                                type: 'a',
                                attributes: [],
                                children: [
                                    {
                                        type: 'CONTENT',
                                        value: 'Hello content'
                                    }
                                ]
                            }
                        }
                    ]
                }
            })
        })

        it('should convert a very simple XML to a simple AST with XML schema declaration', () => {
            const mockXML = `
            ${XML_HEADER}
            <a></a>
            `
            const ast = transpile(mockXML)
            expect(ast).toEqual({
                type: 'ROOT',
                value: {
                    children: [
                        {
                            type: 'ELEMENT',
                            value: {
                                type: 'a',
                                attributes: [],
                                children: []
                            }
                        }
                    ]
                }
            })
        })

        it('should convert a simple xml element with attributes to AST', () => {
            const mockXML = '<a p1="v1" p2="v2"></a>'
            const ast = transpile(mockXML)
            expect(ast).toEqual({
                type: 'ROOT',
                value: {
                    children: [
                        {
                            type: 'ELEMENT',
                            value: {
                                type: 'a',
                                attributes: [
                                    AttribNode('p1', 'v1'),
                                    AttribNode('p2', 'v2')
                                ],
                                children: []
                            }
                        }
                    ]
                }
            })
        })

        it('should convert a full XML to AST', () => {
            const mockXML = `
            <a ap1="av1" ap2="av2">
            <b bp1='bv1'></b>
            <b bp2='bv2'></b>
            <b bp3='bv3'>
            <c cp1='cv1' cp2='cv2'></c>
            </b>
            </a>
            `
            const ast = transpile(mockXML)
            expect(ast).toEqual({
                type: 'ROOT',
                value: {
                    children: [
                        {
                            type: 'ELEMENT',
                            value: {
                                type: 'a',
                                attributes: [
                                    AttribNode('ap1', 'av1'),
                                    AttribNode('ap2', 'av2')
                                ],
                                children: [
                                    ElementNode(
                                        'b',
                                        [AttribNode('bp1', 'bv1')],
                                        []
                                    ),
                                    ElementNode(
                                        'b',
                                        [AttribNode('bp2', 'bv2')],
                                        []
                                    ),
                                    ElementNode(
                                        'b',
                                        [AttribNode('bp3', 'bv3')],
                                        [
                                            {
                                                type: 'ELEMENT',
                                                value: {
                                                    type: 'c',
                                                    attributes: [
                                                        AttribNode(
                                                            'cp1',
                                                            'cv1'
                                                        ),
                                                        AttribNode('cp2', 'cv2')
                                                    ],
                                                    children: []
                                                }
                                            }
                                        ]
                                    )
                                ]
                            }
                        }
                    ]
                }
            })
        })
    })

    describe('to JSON', () => {
        describe('simple XML', () => {
            it('should transform a simple XML to JSON', () => {
                const mockXML = '<a></a>'
                const expectedJSON = {
                    a: {}
                }
                const actualJSON = transpile(mockXML, astToJson)
                expect(actualJSON).toEqual(expectedJSON)
            })

            it('should transform a simple XML to JSON with an XML header', () => {
                const mockXML = `
                ${XML_HEADER}
                <a></a>
                `
                const expectedJSON = {
                    a: {}
                }
                const actualJSON = transpile(mockXML, astToJson)
                expect(actualJSON).toEqual(expectedJSON)
            })
        })

        describe('simple XML with attributes', () => {
            it('should transform a simple XML to JSON with an XML header', () => {
                const mockXML = `
                ${XML_HEADER}
                <a a="5" b="hello"></a>
                `
                const expectedJSON = {
                    a: {
                        a: '5',
                        b: 'hello'
                    }
                }
                const actualJSON = transpile(mockXML, astToJson)
                expect(actualJSON).toEqual(expectedJSON)
            })
        })

        describe('XML with children', () => {
            it('should transform the XML children to nested JSONs', () => {
                const mockXML = `
                ${XML_HEADER}
                <a a="5" b="hello">
                <empty></empty>
                <message>Hello JSON world</message>
                <specialMessage color="purple">Special Hello</specialMessage>
                <nested>
                <message from="sender">Nested hello</message>
                </nested>
                </a>
                `

                const expectedJSON = {
                    a: {
                        a: '5',
                        b: 'hello',
                        children: [
                            {
                                empty: {}
                            },
                            {
                                message: {
                                    content: 'Hello JSON world'
                                }
                            },
                            {
                                specialMessage: {
                                    color: 'purple',
                                    content: 'Special Hello'
                                }
                            },
                            {
                                nested: {
                                    children: [
                                        {
                                            message: {
                                                from: 'sender',
                                                content: 'Nested hello'
                                            }
                                        }
                                    ]
                                }
                            }
                        ]
                    }
                }
                const actualJSON = transpile(mockXML, astToJson)
                expect(actualJSON).toEqual(expectedJSON)
            })
        })

        describe('Special characters', () => {
            describe('XML attributes with characters', () => {
                it('should transform the XML to JSON when {:, -} chars are in attribute name', () => {
                    const mockXML =
                        '<a attrib:n1="v1" attrib-n2="v2">content</a>'
                    const expectedJSON = {
                        a: {
                            'attrib:n1': 'v1',
                            'attrib-n2': 'v2',
                            content: 'content'
                        }
                    }
                    const actualJSON = transpile(mockXML, astToJson)
                    expect(actualJSON).toEqual(expectedJSON)
                })
            })

            describe('XML content with characters', () => {
                it('should transform the XML to JSON supporting chars - {:, /, -, +, "," }', () => {
                    const mockXML =
                        '<link>https://www.acme.com/abc/A-B_C,d+E/</link>'
                    const expectedJSON = {
                        link: {
                            content: 'https://www.acme.com/abc/A-B_C,d+E/'
                        }
                    }
                    const actualJSON = transpile(mockXML, astToJson)
                    expect(actualJSON).toEqual(expectedJSON)
                })

                it('should transform the XML to JSON supporting unicode chars', () => {
                    const mockXML = '<link>á</link>'
                    const expectedJSON = {
                        link: {
                            content: 'á'
                        }
                    }
                    const actualJSON = transpile(mockXML, astToJson)
                    expect(actualJSON).toEqual(expectedJSON)
                })

                it('should transform a random XML to JSON without failing', () => {
                    const mockXML = `
                    <?xml version="1.0" encoding="UTF-8" ?>
                    <root>
                        <HDshFn2rCQZMG>
                            <k>K[</k>
                            <c8s3k least="saw">
                                <o1DU education="trade">_Su&gt;%Z8</o1DU>
                                <u8JYzwdeWwGn>1673963950.2489343</u8JYzwdeWwGn>
                            </c8s3k>
                            <yI1dht0 opportunity="look">&lt;&amp;RY~HyxRC&lt;d{</yI1dht0>
                        </HDshFn2rCQZMG>
                        <R9Z28 train="please">a=b.JD&amp;m3&gt;vP.AG</R9Z28>
                    </root>
                    `
                    const expectedJSON = {
                        root: {
                            children: [
                                {
                                    HDshFn2rCQZMG: {
                                        children: [
                                            {
                                                k: {
                                                    content: 'K['
                                                }
                                            },
                                            {
                                                c8s3k: {
                                                    least: 'saw',
                                                    children: [
                                                        {
                                                            o1DU: {
                                                                education:
                                                                    'trade',
                                                                content:
                                                                    '_Su&gt;%Z8'
                                                            }
                                                        },
                                                        {
                                                            u8JYzwdeWwGn: {
                                                                content:
                                                                    '1673963950.2489343'
                                                            }
                                                        }
                                                    ]
                                                }
                                            },
                                            {
                                                yI1dht0: {
                                                    opportunity: 'look',
                                                    content:
                                                        '&lt;&amp;RY~HyxRC&lt;d{'
                                                }
                                            }
                                        ]
                                    }
                                },
                                {
                                    R9Z28: {
                                        train: 'please',
                                        content: 'a=b.JD&amp;m3&gt;vP.AG'
                                    }
                                }
                            ]
                        }
                    }
                    const actualJSON = transpile(mockXML, astToJson)
                    expect(actualJSON).toEqual(expectedJSON)
                })
            })

            describe('XML content with "\t" (tabs) ', () => {
                it('should succeed transforming the XML to JSON (based on issue#10 - tab char after new line)', () => {
                    const mockXML = testUtils.readXMLFile(
                        __dirname + '/mock-with-tabs.xml'
                    )
                    const actualJSON = transpile(mockXML, astToJson)
                    const expectedJSON = {
                        'testng-results': {
                            ignored: '20',
                            total: '40',
                            passed: '8',
                            failed: '11',
                            skipped: '1',
                            children: [
                                {
                                    'reporter-output': {}
                                }
                            ]
                        }
                    }
                    expect(actualJSON).toEqual(expectedJSON)
                })
            })
        })

        it('Spaces as content', () => {
            const json = convertXML(
                '<a><child>hello     world</child><child>1    + 1  =  2</child></a>'
            )
            expect(json).toEqual({
                a: {
                    children: [
                        {
                            child: {
                                content: 'hello     world'
                            }
                        },
                        {
                            child: {
                                content: '1    + 1  =  2'
                            }
                        }
                    ]
                }
            })
        })

        it('Spaces and Tabs as content', () => {
            const json = convertXML(
                '<a><child>2 tabs        between</child><child>1tab  + 1space</child></a>'
            )
            expect(json).toEqual({
                a: {
                    children: [
                        {
                            child: {
                                content: '2 tabs        between'
                            }
                        },
                        {
                            child: {
                                content: '1tab  + 1space'
                            }
                        }
                    ]
                }
            })
        })
    })
})
