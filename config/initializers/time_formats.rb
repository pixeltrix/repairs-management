# User friendly GOV.UK date formats, based on:
# https://www.gov.uk/guidance/style-guide/a-to-z-of-gov-uk-style#dates
# https://www.gov.uk/guidance/style-guide/a-to-z-of-gov-uk-style#times

# 1 January 2013
Date::DATE_FORMATS[:govuk_date] = '%-e %B %Y'

# 1 Jan 2013
Date::DATE_FORMATS[:govuk_date_short] = '%-e %b %Y'

# 1:15pm, 1 January 2013
Time::DATE_FORMATS[:govuk_date] = '%-I:%M%P, %-e %B %Y'

# 1:15pm, 1 Jan 2013
Time::DATE_FORMATS[:govuk_date_short] = '%-I:%M%P, %-e %b %Y'

# 1:15pm
Time::DATE_FORMATS[:govuk_time] = '%-I:%M%P'

# 13:15 2013-01-01
Time::DATE_FORMATS[:technical] = '%H:%M %d-%m-%Y'
