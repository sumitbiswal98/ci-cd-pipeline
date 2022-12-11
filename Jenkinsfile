pipeline
{
    agent
    {
        label 'maven'
    }
    
    
    stages
    {
        
        stage('Build')
        {
            steps
            {
                echo 'Building....'
                openshift.withCluster()
                {
                    openshift.withProject("ci-cd")
                    {
                        def buildConfigExists = openshift.selector("bc", "pipeline").exists()
                        if(!buildConfigExists)
                        {
                            openshift.newBuild("--name=pipeline", "--docker-image=registry.redhat.io/jboss-eap-7/eap74-openjdk8-openshift-rhel7", "--binary")
                        }
                        
                        openshift.selector("bc", "pipeline").startBuild("--from-file=target/simple-servlet-0.0.1-SNAPSHOT.war", "--follow")
                        
                    }
                }
            }
        }
        
        
        
        stage('Create Container Image')
        {
            steps
            {
                echo 'Create Container Image'
                
                script
                {
                    openshift.withCluster()
                    {
                        openshift.withProject("ci-cd")
                        {
                            def deployment = openshift.select("dc", "pipeline")
                            
                            if(!deployment.exists())
                            {
                                openshift.newApp('pipeline', "--as-deployment-config").narrow('svc').expose()
                            }
                            
                            timeout(5)
                            {
                                openshift.selector("dc", "pipeline").related('pods').untilEach(1)
                                {
                                    return (it.object().status.phase == "Running")
                                }
                            }
                            
                        }
                    }
                }
                
            }
        }
        
        
        
        
        
        
    }
    
    
}