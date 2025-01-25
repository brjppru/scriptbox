import re
from datetime import datetime, timedelta, tzinfo

ZERO = timedelta(0)


class UTC(tzinfo):
    """
    UTC implementation taken from Python's docs.
    """

    def __repr__(self):
        return "<UTC>"

    def utcoffset(self, dt):
        return ZERO

    def tzname(self, dt):
        return "UTC"

    def dst(self, dt):
        return ZERO


class FixedOffset(tzinfo):
    "Fixed offset in minutes east from UTC."
    def __init__(self, offset):
        if isinstance(offset, timedelta):
            self.__offset = offset
            offset = self.__offset.seconds // 60
        else:
            self.__offset = timedelta(minutes=offset)

        sign = '-' if offset < 0 else '+'
        self.__name = u"%s%02d%02d" % (sign, abs(offset) / 60., abs(offset) % 60)

    def __repr__(self):
        return self.__name

    def __getinitargs__(self):
        return self.__offset,

    def utcoffset(self, dt):
        return self.__offset

    def tzname(self, dt):
        return self.__name

    def dst(self, dt):
        return timedelta(0)


datetime_re = re.compile(
    r'(?P<year>\d{4})-(?P<month>\d{1,2})-(?P<day>\d{1,2})'
    r'[T ](?P<hour>\d{1,2}):(?P<minute>\d{1,2})'
    r'(?::(?P<second>\d{1,2})(?:\.(?P<microsecond>\d{1,6})\d{0,6})?)?'
    r'(?P<tzinfo>Z|[+-]\d{1,2}:\d{1,2})?$'
)

utc = UTC()


def parse_datetime(value):
    """Parses a string and return a datetime.datetime.

    This function supports time zone offsets. When the input contains one,
    the output uses an instance of FixedOffset as tzinfo.

    Sub-microsecond precision is accepted, but ignored.

    Raises ValueError if the input is well formatted but not a valid datetime.
    Returns None if the input isn't well formatted.
    """
    match = datetime_re.match(value)
    if match:
        kw = match.groupdict()
        if kw['microsecond']:
            kw['microsecond'] = kw['microsecond'].ljust(6, '0')
        tzinfo = kw.pop('tzinfo')
        if tzinfo == 'Z':
            tzinfo = utc
        elif tzinfo is not None:
            offset = 60 * int(tzinfo[1:3]) + int(tzinfo[4:6])
            if tzinfo[0] == '-':
                offset = -offset
            tzinfo = FixedOffset(offset)
        kw = dict((k, int(v)) for k, v in kw.iteritems() if v is not None)
        kw['tzinfo'] = tzinfo
        return datetime(**kw)
