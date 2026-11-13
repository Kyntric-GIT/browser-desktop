#!/usr/bin/env bash
set -euo pipefail
if [[ -z "${VNC_PASSWORD:-}" ]]; then echo "ERROR: Set VNC_PASSWORD before starting." >&2; exit 1; fi
if [[ ${#VNC_PASSWORD} -lt 8 ]]; then echo "ERROR: VNC_PASSWORD must be at least 8 characters." >&2; exit 1; fi
mkdir -p /home/desktop/.vnc
chown -R desktop:desktop /home/desktop/.vnc
printf '%s\n%s\n' "$VNC_PASSWORD" "$VNC_PASSWORD" | su - desktop -c 'vncpasswd -f > /home/desktop/.vnc/passwd'
chmod 600 /home/desktop/.vnc/passwd
unset VNC_PASSWORD
GEOMETRY="${DESKTOP_GEOMETRY:-1280x800}"
DEPTH="${DESKTOP_DEPTH:-24}"
VNC_PORT="${VNC_PORT:-5901}"
NOVNC_PORT="${PORT:-${NOVNC_PORT:-6080}}"
su - desktop -c "Xvnc :1 -geometry '$GEOMETRY' -depth '$DEPTH' -rfbport '$VNC_PORT' -localhost yes -SecurityTypes VncAuth -rfbauth /home/desktop/.vnc/passwd -AlwaysShared" &
VNC_PID=$!
cleanup() { kill "$VNC_PID" 2>/dev/null || true; }
trap cleanup EXIT INT TERM
for attempt in $(seq 1 30); do
  if (echo > "/dev/tcp/127.0.0.1/$VNC_PORT") >/dev/null 2>&1; then break; fi
  sleep 1
done
su - desktop -c 'DISPLAY=:1 dbus-launch --exit-with-session startxfce4' &
exec websockify --web=/usr/share/novnc "$NOVNC_PORT" "127.0.0.1:$VNC_PORT"
