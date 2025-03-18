from django.conf import settings

class FilePath:
    APPLICANT_AVATAR_DIR = settings.MEDIA_ROOT + '\\applicant'
    
    HIRER_AVATAR_DIR = settings.MEDIA_ROOT + '\\hirer'

    HIRER_LOGO_DIR = settings.MEDIA_ROOT + '\\enterprise'

    CV_DIR = settings.MEDIA_ROOT + '\\cv'

    # ENTERPRISE_PHOTO_DIR = settings.MEDIA_ROOT + '\\enterprise\\cover_photo'
    # ENTERPRISE_LOGO_DIR = settings.MEDIA_ROOT + '\\enterprise'