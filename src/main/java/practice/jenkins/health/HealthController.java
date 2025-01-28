package practice.jenkins.health;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class HealthController {

    @GetMapping("/health")
    public ResponseEntity<String> handleServerStatusRequest() {
        return new ResponseEntity<>("서버가 정상적으로 작동 중입니다.", HttpStatus.OK);
    }
}
