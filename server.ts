import express from 'express'

const PORT = 8080
const HOST = '0.0.0.0'

const app = express()

app.get('/', (_req, res) => {
  res.send('Hello World!!')
})

app.listen(PORT, () => {
  console.log(`Running on http://${HOST}:${PORT}`)
})

const gracefulExit = (signal: string) => {
  console.log(`${signal} received: closing HTTP server`)
  process.exit(0)
}

process.on('SIGINT', gracefulExit)
process.on('SIGQUIT', gracefulExit)
process.on('SIGTERM', gracefulExit)
