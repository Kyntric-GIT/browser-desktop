# Browser Desktop

A Linux XFCE desktop accessible in a browser with noVNC. It uses Docker and does not use GitHub Codespaces.

## Important: GitHub does not run the desktop

GitHub stores this repository and can build its container image with GitHub Actions. It does not provide a continuously running computer or VNC server. To use the desktop remotely, deploy this Docker project to a host that supports long-running Docker web services and WebSockets.

Free hosting may sleep, have usage limits, or require payment. This project does not promise a free, permanent server.

## Run on a Docker host

You need Docker Engine and Docker Compose.

1. Clone this repository.
2. Copy `.env.example` to `.env`.
3. Change `VNC_PASSWORD` in `.env` to a private password (at least 8 characters).
4. Run:

```bash
docker compose up -d --build
```

5. Open `http://localhost:6080/vnc.html`, choose **Connect**, and enter your VNC password.

Stop with `docker compose down`.

## Deploy to a hosting provider

Choose a provider supporting Dockerfile-based web services, WebSockets, long-running processes, and HTTPS.

Create a web service from this repository using its Dockerfile. Configure the HTTP port as **6080**, or let the provider inject its `PORT` variable. Add `VNC_PASSWORD` as a secret environment variable. Never commit your real password.

Open `https://YOUR-SERVICE-HOST/vnc.html`. The host must route WebSocket traffic to the same service.

## Configuration

| Variable | Default | Meaning |
|---|---:|---|
| `VNC_PASSWORD` | required | VNC authentication password |
| `PORT` | unset | Hosting provider's assigned HTTP port |
| `NOVNC_PORT` | `6080` | noVNC HTTP/WebSocket port |
| `VNC_PORT` | `5901` | Internal VNC port; not published by Compose |
| `DESKTOP_GEOMETRY` | `1280x800` | Desktop resolution |
| `DESKTOP_DEPTH` | `24` | Color depth |

## Security

- Never expose raw VNC port 5901 publicly.
- Use a strong, unique password configured as a hosting secret.
- Use HTTPS; do not send credentials over untrusted plain HTTP.
- Anyone who can access the endpoint and knows the password can control the desktop. Do not use it for sensitive accounts or files.
- VNC authentication has legacy limitations; use a secure host and HTTPS reverse proxy.

## What this is

This is a Linux XFCE desktop streamed to a browser. It is not Windows 11 and is not hosted by GitHub itself.
