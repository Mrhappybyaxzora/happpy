# Use the official Python image from the Docker Hub
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /code

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/code \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Define build arguments for all environment variables
ARG MongoUri
ARG Cohere
ARG HuggingFace
ARG OpenAI
ARG Groq
ARG GEMINI_API_KEY
ARG Tunestudio
ARG PLAY_HT_USER_ID
ARG PLAY_HT_API_KEY
ARG ELEVENLABS_API_KEY

# Set environment variables from build arguments
ENV MongoUri=$MongoUri \
    Cohere=$Cohere \
    HuggingFace=$HuggingFace \
    OpenAI=$OpenAI \
    Groq=$Groq \
    GEMINI_API_KEY=$GEMINI_API_KEY \
    Tunestudio=$Tunestudio \
    PLAY_HT_USER_ID=$PLAY_HT_USER_ID \
    PLAY_HT_API_KEY=$PLAY_HT_API_KEY \
    ELEVENLABS_API_KEY=$ELEVENLABS_API_KEY

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create a non-root user
RUN useradd -m appuser

# Copy the requirements file into the container
COPY --chown=appuser:appuser requirements.txt .

# Install the dependencies listed in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code to the working directory
COPY --chown=appuser:appuser . .

# Switch to non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:7860/ || exit 1

# Specify the command to run your FastAPI app with Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860", "--workers", "4"]
