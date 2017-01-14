from tests.testcase import TestCase


class TestUbuntuXenialDocker(TestCase):

    def test_ubuntu_xenial_docker_headless_passes_integration_tests(self):
        self.check_spawned_machine_passes_integration(
            server_type='headless',
            compute_type='docker'
        )
