"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const PORT = 8080;
const HOST = '0.0.0.0';
const app = (0, express_1.default)();
app.get('/', (_req, res) => {
    res.send('Hello World!!!!!!!');
});
app.listen(PORT, HOST, () => {
    console.log(`Running on http://${HOST}:${PORT}`);
});
const gracefulExit = (signal) => {
    console.log(`${signal} received: closing HTTP server`);
    process.exit(0);
};
process.on('SIGINT', gracefulExit);
process.on('SIGQUIT', gracefulExit);
process.on('SIGTERM', gracefulExit);
