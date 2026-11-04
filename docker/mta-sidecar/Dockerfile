FROM registry.dev.zextras.com/dev/carbonio-sidecar:main

RUN useradd -r -U carbonio-mta

COPY mta/carbonio-mta.hcl /consul/config/

COPY mta/service-protocol.json /etc/carbonio/mta/service-discover/service-protocol.json
COPY mta/intentions.json /etc/carbonio/mta/service-discover/intentions.json
COPY mta/policies.json /etc/carbonio/mta/service-discover/policies.json

COPY --chmod=755 mta/carbonio-mta.sh /usr/local/bin/carbonio-mta

ENV SERVICE_NAME=carbonio-mta
ENV SETUP_SCRIPT="carbonio-mta setup"
ENV TOKEN_FILE=/etc/carbonio/mta/service-discover/token
