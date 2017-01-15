from tests.testcase import TestCase


class TestHeadlessCron(TestCase):

    def test_headless_cron_is_installed(self):
        expected_output = b'15 0 * * * /usr/etc/puppetfiles/papply.sh ' \
                          b'/usr/etc/puppetfiles/manifests/headless.pp'
        command_to_check_output_of = ['crontab', '-l']
        self.assertInOutput(expected_output, command_to_check_output_of)
