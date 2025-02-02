# 베이스 이미지로 OpenJDK 17 사용
FROM bellsoft/liberica-openjdk-alpine:17 as build

# Gradle 캐시를 위한 디렉토리 생성
WORKDIR /app

# build.gradle 및 settings.gradle 파일 복사
COPY build.gradle settings.gradle ./
COPY gradle gradle

# 의존성 설치
RUN chmod +x gradlew && ./gradlew build --no-daemon || return 0

# 소스 코드 복사
COPY src src

# gradlew 파일의 줄 끝을 Unix 스타일로 변환
RUN sed -i 's/\r$//' ./gradlew

# 최종 빌드
RUN ./gradlew bootJar --no-daemon

# 실행할 최종 이미지
FROM bellsoft/liberica-openjdk-alpine:17

# application-dev.yml 파일을 Jenkins Credentials에서 가져오기 위한 위치
COPY application-dev.yml /config/application-dev.yml

# JAR 파일 복사
COPY --from=build /app/build/libs/your-app-name.jar app.jar

# 환경 변수 설정
ENV SPRING_CONFIG_LOCATION=/config/application-dev.yml
ENV TZ=Asia/Seoul

# 타임존 설정
RUN apt-get update && apt-get install -y tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# HTTP 및 HTTPS 포트 노출
EXPOSE 80
EXPOSE 443

# 힙 덤프를 위한 디렉토리 생성
RUN mkdir -p /dumps

# /dumps 디렉토리를 볼륨으로 설정
VOLUME ["/dumps"]

# 애플리케이션 실행
ENTRYPOINT ["java", "-Xmx1g", "-Xms1g", "-XX:+UseG1GC", "-XX:MaxGCPauseMillis=200", "-XX:+HeapDumpOnOutOfMemoryError", "-XX:HeapDumpPath=/dumps", "-XX:+UseContainerSupport", "-jar", "/app.jar"]