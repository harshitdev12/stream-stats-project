const express = require('express');
const path = require('path');
const app = express();


app.use(express.static(path.join(__dirname, 'public')));


app.get('/config', (req, res) => {
    res.json({ API_URL: process.env.API_URL || 'http://localhost:5000' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Overlay server running on port ${PORT}`);
});