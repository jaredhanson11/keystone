'''
Orchestrator handles keeping deployments up to date by exposing endpoint
for webhooks to hit whenever new images are published.
'''
import os
from multiprocessing import Process
from subprocess import Popen

from yaml import safe_load
from flask import Flask, jsonify


KEYSTONE_DIR = '/keystone'
DEPLOYS_DIR = os.path.join(KEYSTONE_DIR, 'deploys')
COMPOSERS_DIR = os.path.join(KEYSTONE_DIR, 'composers')

app = Flask(__name__)


@app.route('/redeploy')
def redeploy():
    pull()
    process = Process(target=deploy)
    process.daemon = True
    process.start()
    return jsonify(True)


def pull():
    args_update = ['git', 'pull']
    app.logger.debug(args_update)
    Popen(args_update, cwd=KEYSTONE_DIR).wait()


def deploy():
    # Create network
    create_network = ['docker', 'network', 'create', 'endergy-network']
    Popen(create_network).wait()

    # Start stacks based on deploy files
    confs = list(filter(lambda f: f.endswith('.yml'), os.listdir(DEPLOYS_DIR)))
    common_services_i = confs.index('common-services.yml')
    ordered_confs = [confs.pop(common_services_i)] + confs
    for _conf in ordered_confs:
        compose = ['docker-compose', '-f', os.path.join(COMPOSERS_DIR, _conf)]
        down = compose + ['down']
        app.logger.debug(down)
        Popen(args=down).wait()
        deploy_fp = os.path.join(DEPLOYS_DIR, _conf)
        with open(deploy_fp) as deploy_file:
            deploy_conf = safe_load(deploy_file.read())
        deploy_services = []
        for svc in deploy_conf.get('services'):
            service_conf = ServiceDeployConf(svc)
            if service_conf.deploy:
                deploy_services.append(service_conf.name)
        if deploy_services:
            up = compose + ['up', '-d'] + deploy_services
            app.logger.debug(up)
            Popen(args=up).wait()


class ServiceDeployConf:  # This class should be moved to common library
    ''' Maps a service in the deploys/<service>/deploy.yml file to object '''
    # Fields mapped to object
    name: str = None  # name of service
    deploy: bool = None  # is deployed?
    port: int = None  # port that service runs on in container
    extra_paths: list = None  # (optional) extra paths

    # Constants
    NAME_KEY = 'name'
    DEPLOY_KEY = 'deploy'
    EXTRA_PATHS_KEY = 'extraPaths'
    PORT_KEY = 'containerPort'

    def __init__(self, deploy_yaml):
        self.name = deploy_yaml.get(ServiceDeployConf.NAME_KEY)
        self.deploy = deploy_yaml.get(ServiceDeployConf.DEPLOY_KEY, False)
        self.port = deploy_yaml.get(ServiceDeployConf.PORT_KEY)
        _paths = deploy_yaml.get(ServiceDeployConf.EXTRA_PATHS_KEY, list())
        self.extra_paths = _paths

        # Sanitize input a bit
        if self.deploy:
            assert self.name
            assert self.port


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
