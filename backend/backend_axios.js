const express = require('express');
const axios = require('axios');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json()); // To parse JSON request bodies

app.post('/api/callRemoteAPI', async (req, res) => {
  const ethAddress = req.body.eth_address; // Send the eth_address from frontend
  const blockParam = req.body.block_param || 'latest' //optionally send the blockParam from frontend as well
  const apiKey = process.env.API_KEY; // TRM provided key

  const remoteApiUrl = `https://mainnet.infura.io/v3/${apiKey}`;

  const requestBody = {
    jsonrpc: '2.0',
    method: 'eth_getBalance',
    params: [ethAddress, blockParam],
    id: 1,
  };

  const headers = {
    'Content-Type': 'application/json',
  };

  try {
    const response = await axios.post(remoteApiUrl, requestBody, { headers });
    res.json(response.data);
  } catch (error) {
    console.error('Error calling remote API:', error);
    if (error.response) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx
      console.error("Server responded with:", error.response.data);
      res.status(error.response.status).json(error.response.data);
    } else if (error.request) {
      // The request was made but no response was received
      console.error("No response received:", error.request);
      res.status(500).json({ error: 'No response from remote API' });
    } else {
      // Something happened in setting up the request that triggered an Error
      console.error("Error setting up request:", error.message);
      res.status(500).json({ error: 'Failed to call remote API' });
    }
  }
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
