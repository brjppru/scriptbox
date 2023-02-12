# coding: utf-8
import unittest
from werkzeug.datastructures import MultiDict
from krasweather.application import app
from krasweather.forms import DataForm


class DataFormTest(unittest.TestCase):
    def test_get_sensor_id_returns_one_on_empty_sensor_id_field(self):
        with app.app_context():
            form = DataForm(MultiDict({'date': '2013-06-21 12:00:00', 'temp': 1}))
            self.assertTrue(form.validate(), form.errors)
            sensor_id = form.get_sensor_id()
            self.assertEqual(sensor_id, 0)

    def test_get_sensor_id_returns_id(self):
        with app.app_context():
            form = DataForm(MultiDict({'date': '2013-06-21 12:00:00', 'temp': '1', 'sensor_id': '1'}))
            self.assertTrue(form.validate(), form.errors)
            sensor_id = form.get_sensor_id()
            self.assertEqual(sensor_id, 1)


if __name__ == '__main__':
    unittest.main()
