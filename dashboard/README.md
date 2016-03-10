##vulnerabilities.html

Description: Vulnerabilities of a dependency(package)
Data:
- number of vulnerabilities
- dependency(package) name
- vulnerability
    - Identifier: CVE number
    - Published data
    - CVSS Score
    
##dependency-description.html

Description: Vulnerabilities of a dependency(package)
Data:
- info of the dependency

##dependencies.html

Description: dependencies in the project(repo)

upper section: the overall analysis of dependencies(high risk dependency, non risk dependency, etc.)
lower section: the list of dependencies having vulnerbility

Data:
- dependency number of
    - have high risk vulnerability
    - have medium risk vulnerability
    - do not have vulnerability
- dependencies(packages)
    - name
    - version
    - vulnerabilities number of
        - high risk
        - medium risk
