To just view normal Trivy HTML output:

    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v ${PWD}/trivy-cache/:/root/.cache/ -v ${PWD}/trivy-output:/output aquasec/trivy image --exit-code 1 --no-progress --format template --template "@contrib/html.tpl" -o /output/report.html mendhak/http-https-echo:15

Now create a custom Trivy JSON output, using the custom.tpl as a template:

```
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                -v ${PWD}/trivy-cache/:/root/.cache/ \
                -v ${PWD}/custom.tpl:/input/custom.tpl \
                -v ${PWD}/trivy-output:/output aquasec/trivy \
                image --exit-code 1 --no-progress \
                --format template --template "@/input/custom.tpl" \
                -o /output/report.json \
                mendhak/http-https-echo:15
```

Finally, send the generated report.json to sonar:

    ./sonar-scanner-4.5.0.2216-linux/bin/sonar-scanner -Dsonar.projectKey=test -Dsonar.externalIssuesReportPaths=trivy-output/report.json -Dsonar.host.url=http://localhost:9000 -Dsonar.login=xxxxxxxxxxxxxxxxxxxxx

Run a sonar scan with that JSON file using

    docker run --rm -e SONAR_HOST_URL=http://host.docker.internal:9000 -e SONAR_LOGIN=xxxxxxxxxxxxxxxxxxxxx -v ${PWD}:/usr/src sonarsource/sonar-scanner-cli -Dsonar.projectKey=test -Dsonar.externalIssuesReportPaths=/usr/src/trivy-output/report.json 