import unittest
import logging
import json

from app import make_app

class APITestCase(unittest.TestCase):
    def setUp(self):
        self.debug = True
        self.app = make_app(
            DEBUG = self.debug
        )
        self.app.logger.setLevel(logging.DEBUG if self.debug else logging.CRITICAL)

    def tearDown(self):
        "Cleanup"

class Simple(APITestCase):
    def test_index(self):
        "No index page for api"
        with self.app.app_context():
            with self.app.test_client() as c:
                rv = c.get('/', follow_redirects=True)
                assert 404 == rv.status_code

class Llama(APITestCase):
    def test_method_unsupported(self):
        "No GET method"
        with self.app.app_context():
            with self.app.test_client() as c:
                rv = c.get('/llama/', follow_redirects=True)
                assert 405 == rv.status_code

    def test_empty_data(self):
        "Sent data should not be empty"
        with self.app.app_context():
            with self.app.test_client() as c:
                data = {}
                rv = c.post('/llama/', follow_redirects=True, data=data)
                if 400 != rv.status_code:
                    self.app.logger.debug(rv)
                    self.app.logger.debug(rv.data)
                assert 400 == rv.status_code

    # TODO: add relevant llama tests

if __name__ == '__main__':
    unittest.main()
