async function testCustomProtocol() {
    let res = await fetch('http://app.path/')
    console.log("Received message from custom protocol:", await res.text())
}

window.luneweb.postMessage('load', null)

testCustomProtocol()
testCustomProtocol = undefined
