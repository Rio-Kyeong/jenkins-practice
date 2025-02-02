package practice.jenkins.h2;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Setter
@Getter
@Component
@ConfigurationProperties(prefix = "spring.datasource")
public class DataSourceProperties {

    @NotBlank
    private String url;

    @NotBlank
    private String driverClassName;

    @NotBlank
    private String username;

    private String password;
}
