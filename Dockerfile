FROM python:3.11-slim-bullseye

# Install system packages required by pyodbc and the Microsoft ODBC driver
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		build-essential \
		gcc \
		g++ \
		unixodbc-dev \
		curl \
		gnupg \
		apt-transport-https \
		ca-certificates \
		libssl-dev \
	&& curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
	&& curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
	&& apt-get update \
	&& ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies first (cache layer)
COPY requirements.txt ./
RUN python -m pip install --upgrade pip \
	&& pip install --no-cache-dir -r requirements.txt

# Copy app source
COPY . .

EXPOSE 5000

ENV PYTHONUNBUFFERED=1
ENV FLASK_RUN_HOST=0.0.0.0

CMD ["python", "app.py"]