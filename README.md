본 레포지토리의 Dockerfile 을 이용하여 컨테이너를 생성하면,
해당 컨테이너에서는 SSH 서버가 실행되어 동작하게 될 것이다.

SSH Client는 자유롭게 선택하여 사용하면 되는데, 만약 자신의 PC에서 도커를 호스트하고 있고, 이 컨테이너를 빌드하여 사용중이라면 Hostname으로는 `localhost`를 사용하면 된다.

SSH 포트 번호는 도커 컨테이너의 내부 포트가 외부로 어떤 포트에 포워딩 되어지고 있는지를 직접 파악해야 한다.

---

1. 먼저, Wireshark 등의 도구를 통해 패킷을 분석하려면 서버에서 다음의 코드를 실행해주어야 한다.

```bash
# Server
$ tcpdump -s 0 -U -n -w - -i lo > paccap
tcpdump: listening on lo, link-type EN10MB (Ethernet), snapshot length 262144 bytes
```


2. SSH 클라이언트가 서버에 접속하기 위한 명령어는 다음과 같다.

```bash
# Client
$ ssh root@<HOSTNAME> -p <PORT>
```

비밀번호는 `pw` 로 초기화 되어있으니, 그대로 사용하면 될 것이다.
만약 수정해서 사용해야 한다면 `Dockerfile`에 비밀번호를 변경하는 라인이 있으니 수정하여 사용하면 된다.

3. SSH 로그인 및 패킷을 충분히 생성했다면 서버에서 실행중인 `tcpdump` 프로세스를 종료한다.

```bash
# Server
$ ^C # Ctrl+C 로 작업 중지
3363 packets captured
6766 packets received by filter
0 packets dropped by kernel
```

4. `tcpdump` 프로세스에 의해 생성된 paccap 파일을 Wireshark에서 열어보면 패킷 정보들이 나타난다.
