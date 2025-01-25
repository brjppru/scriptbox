# coding: utf-8
import re
from subprocess import Popen, PIPE
from smtplib import SMTP, SMTPException
from email.MIMEText import MIMEText
from email.Header import Header
from email.Utils import parseaddr, formataddr

from flask import Flask
from flask import render_template
from flask import request

app = Flask(__name__)
app.config.from_object(__name__)

IP = '0.0.0.0'
PORT = 8000

ARP_COMMAND = '/usr/sbin/arp'
ARP_FLAGS = '-n'
MAC_REGEXP = r"(([a-f\d]{1,2}\:){5}[a-f\d]{1,2})"

MAIL_SERVER = 'localhost'
MAIL_USERNAME = ''
MAIL_PASSWORD = ''

SENDER = 'www@localhost'
RECIPIENT = 'sam@brj.pp.ru'

message_subject = 'Регистрация'
message_body = u"""
Имя: %s
Номер телефона: %s
IP: %s
MAC: %s
"""


def send_email(name, phone, ip, mac):
    message = message_body % (name, phone, ip, mac)

    msg = MIMEText(message.encode('utf-8'), 'plain', 'utf-8')
    msg['From'] = SENDER
    msg['To'] = RECIPIENT
    msg['Subject'] = unicode(message_subject, 'utf-8')

    try:
        smtp = SMTP(MAIL_SERVER)
        if MAIL_USERNAME:
            smtp.login(MAIL_USERNAME, MAIL_PASSWORD)
        smtp.sendmail(SENDER, [RECIPIENT, ], msg.as_string())
        smtp.quit()
    except SMTPException as e:
        print 'Не удалось отправить письмо: %s' % str(e)


def get_mac_by_ip(ip_address):
    pid = Popen(["arp", "-n", ip_address], stdout=PIPE)
    s = pid.communicate()[0]
    try:
        mac = re.search(MAC_REGEXP, s).groups()[0]
    except:
        # mac = u'Не удалось определить'
        mac = u'Unknown'
    return mac


def validate_form(form):
    errors = {}
    if not form['name']:
        errors['name'] = u'Обязательное поле'
    if not form['phone']:
        errors['phone'] = u'Обязательное поле'
    return errors


@app.route("/", methods=['POST', 'GET'])
def index():
    errors = {}
    if request.method == 'POST':
        errors = validate_form(request.form)
        if not errors:
            send_email(request.form['name'], request.form['phone'],
                request.remote_addr, get_mac_by_ip(request.remote_addr))
            return render_template('success.html')
    return render_template('index.html', ip=request.remote_addr, mac=get_mac_by_ip(request.remote_addr), errors=errors)

if __name__ == "__main__":
    app.run(IP, PORT)
