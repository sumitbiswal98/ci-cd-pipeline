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
        echo 'Building..'
        sh 'mvn clean package'
      }
    }
    
    
    
    
    stage('Create Container Image') 
    {
      steps 
      {
        echo 'Create Container Image..'
        
        script 
        {
            
            
            openshift.withCluster()
            {
                openshift.withProject("pipeline")
                {
                    def buildConfigExists = openshift.selector("bc", "a1").exists()
                    if(!buildConfigExists)
                    {
                        openshift.newBuild("--name=a1", "--docker-image=registry.redhat.io/jboss-webserver-3/webserver31-tomcat8-openshift
", "--binary")
                    }
                    openshift.selector("bc", "a1").startBuild("--from-file=target/simple-servlet-0.0.1-SNAPSHOT.war", "--follow")
                }
            }
            
            
            
        }
      }
    }
    
    
    
    
    
    stage('Deploy') 
    {
      steps 
      {
        echo 'Deploying....'
        script 
        {
            
            
            openshift.withCluster()
            {
                openshift.withProject("pipeline")
                {
                    def deployment = openshift.selector("dc", "a1")
                    if(!deployment.exists())
                    {
                        openshift.newApp('a1', "--as-deployment-config").narrow('svc').expose()
                    }
                    
                    timeout(5)
                    {
                        openshift.selector("dc", "a1").related('pods').untilEach(1)
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
