# vncp-apn (Cellular APN via PPP)

Dial a cellular **APN** using `pppd/chat` inside a container.

- **Image:** `ghcr.io/versa-node/vncp-apn:latest` (builds locally)
- **Privileged:** `true`
- **Capabilities:** `NET_ADMIN`, `SYS_ADMIN`
- **Device:** e.g., `/dev/ttyUSB0`
- **Network:** `versanode`

## Configure

`vncp.config.yaml` → `.env`

**Keys**
- `APN_NAME` *(string, default `internet`)* — APN name from carrier
- `APN_USER` *(string)* — username (if required)
- `APN_PASSWORD` *(password, secret)* — password (if required)
- `DIAL_NUMBER` *(string, default `*99#`)* — dial number
- `MODEM_DEV` *(string, default `/dev/ttyUSB0`)* — modem device

**Example `.env`**
```env
APN_NAME=internet
APN_USER=
APN_PASSWORD=
DIAL_NUMBER=*99#
MODEM_DEV=/dev/ttyUSB0
```

## Run
```bash
bash ../../tools/ensure-network.sh
docker compose up -d
```

> Device names vary (`/dev/ttyACM0`, multiple interfaces). Host may need udev rules or drivers for your modem.
