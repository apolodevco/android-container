pipeline_template = "web"

application_environments{
    dev{
        approversIT = ""
        approversBussiness = ""
    }
    staging{
        approversIT = ""
        approversBussiness = ""
    }
    prod{        
        approversIT = ""
        approversBussiness = ""
    }
}

libraries{
    git{
        source_type = "bitbucket"
    }
    sonarqube{
        appWorkSpace = "."
    }
    angularjs
    slack
    web{
        test_runner = "co.com.qiip.empresas.runners.*"
    }
}