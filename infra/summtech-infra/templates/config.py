import os
from pathlib import Path


class Config(object):
    """Config objects and constants utility"""

    # Env Vars
    DEPLOYS_DIR_ENVVAR = "DEPLOYS_DIR"
    CHARTS_DIR_ENVVAR = "CHARTS_DIR"

    @classmethod
    def get_deploys_dir(cls) -> str:
        """Get deploys directory, default set to root of repo"""
        curr_file_dir = os.path.dirname(os.path.realpath(__file__))
        deploys_dir_default = os.path.join(curr_file_dir, "../../../deploys/")
        return str(os.environ.get(cls.DEPLOYS_DIR_ENVVAR, default=deploys_dir_default))

    @classmethod
    def get_charts_dir(cls) -> str:
        """Get charts directory, default set to root of repo"""
        curr_file_dir = os.path.dirname(os.path.realpath(__file__))
        deploys_dir_default = os.path.join(curr_file_dir, "../../../charts/")
        return str(os.environ.get(cls.CHARTS_DIR_ENVVAR, default=deploys_dir_default))
