package practice.jenkins.h2;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataSourceValidator {

    private final DataSourceProperties dataSourceProperties;

    @PostConstruct
    public void validate() {
        if (dataSourceProperties.getUrl() == null || dataSourceProperties.getUrl().isEmpty()) {
            throw new IllegalArgumentException("DataSource URL must not be empty");
        }
        if (dataSourceProperties.getDriverClassName() == null || dataSourceProperties.getDriverClassName().isEmpty()) {
            throw new IllegalArgumentException("DataSource Driver Class Name must not be empty");
        }
        if (dataSourceProperties.getUsername() == null || dataSourceProperties.getUsername().isEmpty()) {
            throw new IllegalArgumentException("DataSource Username must not be empty");
        }
    }
}
