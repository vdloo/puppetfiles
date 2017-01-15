import json
import unittest
from contextlib import contextmanager
from os.path import join, dirname, realpath, expanduser, basename
from subprocess import check_call, check_output
from uuid import uuid4

from mock import patch, Mock
from shutil import rmtree

from os import makedirs


class TestCase(unittest.TestCase):

    project_dir = join(dirname(dirname(realpath(__file__))))

    def set_up_patch(self, patch_target, mock_target=None, **kwargs):
        patcher = patch(patch_target, mock_target or Mock(**kwargs))
        self.addCleanup(patcher.stop)
        return patcher.start()

    @contextmanager
    def temp_config_dir(self):
        temp_config_dir = '.raptiformica.test.{}'.format(uuid4().hex)
        try:
            makedirs(join(expanduser("~"), temp_config_dir))
            yield temp_config_dir
        finally:
            rmtree(temp_config_dir, ignore_errors=True)

    def install_raptiformica_module(self, cache_dir, module_name):
        install_module_command = [
            'raptiformica', 'modprobe',
            module_name, '--cache-dir', cache_dir
        ]
        check_call(install_module_command)

    def spawn_server_type(self, cache_dir, server_type='headless',
                          compute_type='docker'):
        spawn_server_command = [
            'raptiformica', 'spawn', '--server-type',
            server_type, '--compute-type', compute_type,
            '--cache-dir', cache_dir, '--no-after-mesh'
        ]
        check_call(spawn_server_command)

    def clean_up_server(self, cache_dir):
        clean_up_command = [
            'raptiformica', 'destroy', '--cache-dir', cache_dir,
            '--purge-artifacts', '--purge-modules'
        ]
        check_call(clean_up_command)

    def get_ssh_command(self, cache_dir):
        get_ssh_command_command = [
            'raptiformica', 'ssh', '--info-only',
            '--cache-dir', cache_dir
        ]
        return check_output(get_ssh_command_command)

    def run_command_in_instance(self, cache_dir, command_as_string):
        ssh_command = self.get_ssh_command(cache_dir).decode('utf-8').rstrip()
        if not ssh_command:
            raise RuntimeError(
                "Failed to get SSH command from raptiformica "
                "for the config in {}".format(cache_dir)
            )
        check_call(
            ssh_command + ' ' + command_as_string,
            shell=True
        )

    def run_local_integration(self, cache_dir):
        integration_test_command = '"cd /root/{}/modules/{} && ' \
                                   './runtests.sh -1l"' \
                                   ''.format(cache_dir,
                                             basename(self.project_dir))
        self.run_command_in_instance(
            cache_dir, integration_test_command
        )

    @contextmanager
    def pretend_revision_is_repository(self):
        def change_source(source):
            config_file = join(self.project_dir, 'raptiformica.json')
            with open(config_file, 'r') as f:
                config = json.load(f)
                for server_type in config['server'].keys():
                    config['server'][server_type]['puppetfiles'][
                        'source'
                    ] = source
            with open(config_file, 'w') as f:
                json.dump(config, f, indent=4, sort_keys=True)

        module_name = 'file://{}'.format(self.project_dir)
        change_source(module_name)
        try:
            yield
        finally:
            change_source("https://github.com/vdloo/puppetfiles")

    def check_spawned_machine_passes_integration(self, **kwargs):
        with self.pretend_revision_is_repository():
            with self.temp_config_dir() as tempdir:
                try:
                    module_name = 'file://{}'.format(self.project_dir)
                    self.install_raptiformica_module(
                        tempdir, module_name
                    )
                    self.spawn_server_type(tempdir, **kwargs)
                    self.run_local_integration(tempdir)
                finally:
                    self.clean_up_server(tempdir)

    def assertInOutput(self, member, command, shell=False):
        output = check_output(command, shell=shell)
        self.assertIn(member, output)
