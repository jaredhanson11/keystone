#! /usr/bin/env python3
''' Dynamically creates nginx config based on deploy state '''
import os
from textwrap import dedent
from argparse import ArgumentParser
from yaml import safe_load

arg_parser = ArgumentParser()
arg_parser.add_argument('-d', '--deploys-dir', required=True)
arg_parser.add_argument('-o', '--output-dir', required=True)
args = arg_parser.parse_args()

DEPLOY_FILE_NAME = 'deploy.yml'


class ServiceDeployConf:
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

    def get_proxy_passes(self):
        ''' Get proxy pass block for paths. (name + extra_paths)'''
        blocks = ''
        paths = [self.name] + self.extra_paths
        for path in paths:
            blocks += self.get_proxy_pass(self.name, self.port, path)
        return blocks

    def get_proxy_pass(self, name, port, path):
        ''' Get proxy pass block for given path/port. '''
        return dedent(
            '''\
            location /{path} {{
                proxy_pass http://{name}:{port}/;
            }}
            '''.format(name=name, path=path, port=port))


def main(cli_args) -> None:
    ''' Main part of script '''
    for _conf in os.listdir(cli_args.deploys_dir):
        conf = ''
        deploy_fp = os.path.join(cli_args.deploys_dir, _conf)
        with open(deploy_fp) as deploy_file:
            deploy_conf = safe_load(deploy_file.read())
        for svc in deploy_conf.get('services'):
            service_conf = ServiceDeployConf(svc)
            if service_conf.deploy:
                conf += service_conf.get_proxy_passes()
        conf_fp = os.path.join(cli_args.output_dir, _conf + '.conf')
        with open(conf_fp, 'w') as conf_file:
            conf_file.write(conf)


if __name__ == '__main__':
    main(args)
