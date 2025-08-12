const authenticateApiKey = (req, res, next) => {
  const apiKey = req.headers['x-api-key'];
  const validApiKey = process.env.API_KEY || 'aws-ec2-api-key';
  
  if (!apiKey) {
    return res.status(401).json({
      success: false,
      message: 'API key required. Include X-API-Key header.'
    });
  }
  
  if (apiKey !== validApiKey) {
    return res.status(401).json({
      success: false,
      message: 'Invalid API key.'
    });
  }
  
  next();
};

module.exports = { authenticateApiKey };