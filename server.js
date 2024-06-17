const express = require('express')

const PORT = 8080
const HOST = '0.0.0.0'

const app = express()
app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(PORT, HOST, () => {
  console.log(`Running on http://${HOST}:${PORT}`)
})

const gracefulExit = (signal) => {
  console.log(`${signal} received: closing HTTP server`)
  process.exit(0)
}

process.on('SIGINT', gracefulExit)
process.on('SIGQUIT', gracefulExit)
process.on('SIGTERM', gracefulExit)
