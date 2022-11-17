from kubernetes import client
from kubernetes import config as k_config
from kubernetes.client import V1Pod
from kubernetes.client.models.v1_job import V1Job
from kubernetes.client.rest import ApiException
import logging


logger = logging.getLogger(__name__)

# create namespace 
def create_namespace(self):
    """
    create namespace with random name
    :return: name of new created namespace 

    """
    name = "Chris"

    print("creating namespace.....")
    namespace = client.V1Namespace(metadata=client.V1ObjectMeta(name=name))
    self.core_api.create_namespace(namespace)
  


    return name

    




