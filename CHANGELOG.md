## 1.0.0 (2026-06-11)

### Features

* [CO-513] Update smtpd_sender_restrictions restrictions ([#2](https://github.com/zextras/carbonio-mta/issues/2)) ([441ac1a](https://github.com/zextras/carbonio-mta/commit/441ac1a6b16aef6c5e03e062c70a562fd045cc3a))
* [CO-597] add carbonio-clamav upstream ([#5](https://github.com/zextras/carbonio-mta/issues/5)) ([f57a922](https://github.com/zextras/carbonio-mta/commit/f57a9222e032a3b66ed9e1dac9126c29548460d5))
* [CO-825] Align Clamd conf and use carbonioClamAVReadTimeout ([#8](https://github.com/zextras/carbonio-mta/issues/8)) ([5f5f5e3](https://github.com/zextras/carbonio-mta/commit/5f5f5e31f8d69a2da6a40ced4b20e367bcb9a58a))
* add systemd units ([#19](https://github.com/zextras/carbonio-mta/issues/19)) ([03ea0fc](https://github.com/zextras/carbonio-mta/commit/03ea0fcc8d6630b51f06f7d429cd23b18926cd1c))
* add ubuntu 24.04 (ubuntu-noble) support ([5380a54](https://github.com/zextras/carbonio-mta/commit/5380a5436ae1e25da55a44560ae75f42d06005c1))
* carbonio release ([a46ea24](https://github.com/zextras/carbonio-mta/commit/a46ea24eee015c63a1d57725c407b96c7670ebd6))
* **IN-951:** add arm64 multiarch Docker image support ([#58](https://github.com/zextras/carbonio-mta/issues/58)) ([f89257a](https://github.com/zextras/carbonio-mta/commit/f89257a2e8df0727e57c3469977ce6f718ed6e2e))
* **IN-951:** set arch=any for noarch package ([cae9ac6](https://github.com/zextras/carbonio-mta/commit/cae9ac6cee2ce935cbf8085146d434fee505b254))
* mta sidecar sd_notify and systemd hardening ([#53](https://github.com/zextras/carbonio-mta/issues/53)) ([3ac45bc](https://github.com/zextras/carbonio-mta/commit/3ac45bcf511b3c80ed31375929cbbf8018e02ebd))

### Bug Fixes

* add timestamp version to devel package ([c51ba0d](https://github.com/zextras/carbonio-mta/commit/c51ba0dc1c108d512aca79fbc93b67ebe0d667f9))
* carbonio-mta license header ([#15](https://github.com/zextras/carbonio-mta/issues/15)) ([9f4990a](https://github.com/zextras/carbonio-mta/commit/9f4990a82535d785ea63c54876b60a112e6d0193))
* **deps:** add explicit service-discover-base dependency ([#60](https://github.com/zextras/carbonio-mta/issues/60)) ([b0b0340](https://github.com/zextras/carbonio-mta/commit/b0b034085f2731a46c8fb7f3730e62910e2d196f))
* **docker:** add missing carbonio runtime deps + postfix users ([#65](https://github.com/zextras/carbonio-mta/issues/65)) ([4b7f505](https://github.com/zextras/carbonio-mta/commit/4b7f505dd348e8f1f0eb523af90728008f0d9af1))
* **docker:** create postfix user/groups for Docker compatibility ([#52](https://github.com/zextras/carbonio-mta/issues/52)) ([03baa13](https://github.com/zextras/carbonio-mta/commit/03baa1319c70c0c744db13a92851355d9798ac70))
* expand tmpfiles.d for MTA services (CO-2524) ([#44](https://github.com/zextras/carbonio-mta/issues/44)) ([ab762d4](https://github.com/zextras/carbonio-mta/commit/ab762d4adb073be4d0393b31494db2f53b4daedd))
* expand tmpfiles.d for MTA services (CO-2524) ([#44](https://github.com/zextras/carbonio-mta/issues/44)) ([941c24f](https://github.com/zextras/carbonio-mta/commit/941c24fd30db7492f5c40a4502f0dbb0bc0a8da0))
* sidecar-units: revert WantedBy for compatibility with older systems ([#32](https://github.com/zextras/carbonio-mta/issues/32)) ([f666e8e](https://github.com/zextras/carbonio-mta/commit/f666e8e0c79191144f32f7bacc9cbf493eaa9f20))
