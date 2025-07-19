# Deployment Guide

## Environment Variables Setup

This application requires several environment variables to function properly. Make sure to set these in your deployment platform.

### Required Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `MongoUri` | MongoDB connection string | `mongodb+srv://username:password@cluster.mongodb.net/database` |
| `OpenAI` | OpenAI API key | `sk-...` |
| `GEMINI_API_KEY` | Google Gemini API key | `AIza...` |
| `PLAY_HT_USER_ID` | PlayHT user ID | `your-user-id` |
| `PLAY_HT_API_KEY` | PlayHT API key | `your-api-key` |
| `ELEVENLABS_API_KEY` | ElevenLabs API key | `your-api-key` |
| `Cohere` | Cohere API key | `your-api-key` |
| `Groq` | Groq API key | `your-api-key` |
| `HuggingFace` | HuggingFace API key | `your-api-key` |
| `Tunestudio` | TuneStudio API key | `your-api-key` |

### Deployment Platforms

#### Render

1. Go to your service dashboard
2. Navigate to **Environment** tab
3. Add each environment variable with its corresponding value
4. Redeploy your service

#### Railway

1. Go to your project dashboard
2. Navigate to **Variables** tab
3. Add each environment variable
4. Redeploy your service

#### Heroku

```bash
heroku config:set MongoUri="your-mongodb-uri"
heroku config:set OpenAI="your-openai-key"
heroku config:set GEMINI_API_KEY="your-gemini-key"
# ... add all other variables
```

#### Docker

```bash
docker run -e MongoUri="your-mongodb-uri" \
           -e OpenAI="your-openai-key" \
           -e GEMINI_API_KEY="your-gemini-key" \
           # ... add all other variables
           your-app-image
```

### Local Development

Create a `.env` file in the root directory:

```env
MongoUri=mongodb+srv://username:password@cluster.mongodb.net/database
OpenAI=sk-your-openai-key
GEMINI_API_KEY=your-gemini-key
PLAY_HT_USER_ID=your-user-id
PLAY_HT_API_KEY=your-api-key
ELEVENLABS_API_KEY=your-api-key
Cohere=your-cohere-key
Groq=your-groq-key
HuggingFace=your-huggingface-key
Tunestudio=your-tunestudio-key
```

### Testing Environment Variables

Run the test script to verify all environment variables are loaded:

```bash
python test_env.py
```

### Troubleshooting

1. **Environment variables not found**: Make sure all variables are set in your deployment platform
2. **Docker build issues**: The Dockerfile now uses runtime environment variables instead of build arguments
3. **Local development**: Ensure your `.env` file is in the root directory and not gitignored

### Security Notes

- Never commit API keys to version control
- Use environment variables for all sensitive data
- Regularly rotate your API keys
- Use strong, unique passwords for database connections 