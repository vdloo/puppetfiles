from tests.testcase import TestCase


class TestArchlinuxVagrant(TestCase):

    def test_archlinux_vagrant_headless_passes_integration_tests(self):
        self.check_spawned_machine_passes_integration(
            server_type='headless',
            compute_type='vagrant'
        )
