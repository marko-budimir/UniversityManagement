const express = require('express');
const axios = require('axios');
const fs = require('fs');

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const response = await axios.get('https://jsonplaceholder.typicode.com/posts');
        const data = response.data;

        fs.writeFileSync('data.json', JSON.stringify(data, null, 2));

        res.json({ message: 'Data fetched and saved successfully.' });
    } catch (error) {
        console.error('Error fetching and saving data:', error.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;