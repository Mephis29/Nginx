const http = require('http');
const express = require('express');
const fs = require('fs');
const responseTime = require('response-time');
const quotes = require("quotesy");
const cors = require('cors');
const { APP_PORT, NODE_ENV, ENV_CONFIGURATION } = require('./app/environment')

const app = express();
const index = fs.readFileSync('./client/ngQuote/maintenance/index.html', 'utf8')
const server = app.listen(APP_PORT)

let myQuotes;
let resTime;

myQuotes = createMyQuotes(3);

app.use(cors());
app.options('*', cors());
app.use(express.json());
app.use(responseTime((req, res, time) => {
    resTime = time;
}))

app.get('/', (req, res) => {
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end(index);
});

app.get('/ping', (req, res) => {
    res.send(JSON.stringify({'statusCode': 200, 'message': 'OK', 'time': `${resTime} ms`}));
    res.end();
});

app.get('/api/quotes', (req, res) => {
    res.send(JSON.stringify(myQuotes));
    res.end();
});

app.get('/api/quotes/random', (req, res) => {
    if (req.query.tag) {
        res.send(JSON.stringify(quotes.random_by_tag(`${req.query.tag}`)));
        res.end();
    }
    res.send(JSON.stringify(quotes.random()));
    res.end();
});

app.get('/api/quotes/:id', (req, res) => {
    const findQuote = myQuotes.find(item => item.id === parseInt(req.params.id));
    if (findQuote) {
        res.send(JSON.stringify(findQuote));
    } else {
        res.status(404).send(JSON.stringify('Error 404'));
    }
    res.end();
});

app.post('/api/quotes', (req, res) => {
    const newQuote = {
        id: `${myQuotes.length + 1}`,
        author: req.body.author,
        text: req.body.text
    };
    myQuotes.push(newQuote);
    res.send(newQuote);
    res.end();
});

app.put('/api/quotes/:id', (req, res) => {
    let trigger = false;
    let indexChangeQuote;
    let changeQuote = {};

    myQuotes.find((item, index) => {
        if (item.id === req.params.id) {
            indexChangeQuote = index;
            changeQuote.id = item.id;
            changeQuote.author = req.body.author;
            changeQuote.text = req.body.text;
            trigger = true;
            return
        }
    });

    if(trigger) {
        myQuotes.splice(indexChangeQuote, 1, changeQuote)
        res.send(myQuotes).end();
    } else {
        res.status(404).send(JSON.stringify('Error 404')).end();
    }
});

app.delete('/api/quotes/:id', (req, res) => {
    let trigger = false;
    let indexChangeQuote;

    myQuotes.find((item, index) => {
        if (item.id === req.params.id) {
            indexChangeQuote = index;
            trigger = true;
            return
        }
    });

    if(trigger) {
        myQuotes.splice(indexChangeQuote, 1)
        res.send(myQuotes).end();
    } else {
        res.status(404).send(JSON.stringify('Error 404')).end();
    }
});

function createMyQuotes (length) {
    let arr = [];
    for (let i = 0; i < length; i++) {
        arr.push({
            id: `${i}`,
            author: quotes.random().author,
            text: quotes.random().text
        });
    }
    return arr
}

process.on('SIGINT', () => {
    console.log('SIGINT signal received: closing HTTP server');
    server.close(() => {
        // console.log(process.env);
        console.log('HTTP server closed');
    })
  })
console.log(`Server Listening on Port ${APP_PORT}...`);
