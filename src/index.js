const pdfform = require("pdfform.js")()
const fetch = require("node-fetch")

exports.listFields = async function(event) {
    const body = JSON.parse(event.body)
    const pdfBytes = await getPdfBytes(body.pdf)
    const fields = pdfform.list_fields(pdfBytes)
    return gatewayResponse(200, "application/json", false, JSON.stringify(fields))
}

exports.transform = async function(event) {
    const body = JSON.parse(event.body)
    const pdfBytes = await getPdfBytes(body.pdf)
    const transformedPdf = pdfform.transform(pdfBytes, body.fields)
    return gatewayResponse(200, "application/pdf", true, transformedPdf)
}

function gatewayResponse(statusCode, contentType, isBase64Encoded, body) {
    const response = {
        isBase64Encoded: isBase64Encoded,
        statusCode: statusCode,
        headers: {
            'Content-Type': contentType,
        },
        body: isBase64Encoded ? Buffer.from(body).toString("base64") : body
    }
    console.log(`response = ${JSON.stringify(response)}`)
    return response
}

async function getPdfBytes(pdf) {
    if (Array.isArray(pdf)) {
        console.log(`pdf is an array`)
        return pdf
    }
    if (pdf.toLowerCase().startsWith("http")) {
        console.log(`fetching pdf from ${pdf}`)
        const url = new URL(pdf)
        const response = await fetch(url)
        return await response.buffer()
    }
    console.log("assuming pdf is a base64 encoded string")
    return atob(pdf)
}
