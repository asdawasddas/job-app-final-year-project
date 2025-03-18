from django.urls import path
from django.conf.urls.static import static
from django.conf import settings

from .Views import hirer_view
from .Views import applicant_view
from .Views import enterprise_view
from .Views import job_view
from .Views import application_view
from .Views import admin_view

urlpatterns = [

    # Việc làm, tin tuyển dụng
    path('jobs/', job_view.jobs),
    path('jobs/<str:id>/', job_view.detail),

    # Hồ sơ ứng tuyển
    path('jobs/<str:id>/applications/', application_view.jobApplications),
    path('applications/<str:id>/', application_view.detail),
    
    # Ứng viên
    path('applicants/', applicant_view.applicants),
    path('applicants/login/', applicant_view.login),
    path('applicants/signup/', applicant_view.signup),
    path('applicants/<str:id>/', applicant_view.info),
    path('applicants/<str:id>/avatar/', applicant_view.avatar),
    path('applicants/<str:id>/changePassword/', applicant_view.changePassword),
    path('applicants/<str:id>/appliedJobs/', applicant_view.appliedJobs),    
    path('applicants/<str:id>/favEnterprises/', applicant_view.favEnterprises),
    path('applicants/<str:id>/favEnterprises/jobs', applicant_view.favEnterprisesJobs),
    path('applicants/<str:id>/favJobs/', applicant_view.favJobs),

    # Nhà tuyển dụng
    path('hirers/', hirer_view.hirers),
    path('hirers/login/', hirer_view.login),
    path('hirers/signup/', hirer_view.signup),
    path('hirers/<str:id>/', hirer_view.info),
    path('hirers/<str:id>/avatar/', hirer_view.avatar),
    path('hirers/<str:id>/changePassword/', hirer_view.changePassword),
    path('hirers/<str:id>/jobs/', hirer_view.jobs),
    path('hirers/<str:id>/statistic/', hirer_view.statistic),

    # Doanh nghiệp
    path('enterprises/', enterprise_view.enterprises),
    path('enterprises/<str:id>/', enterprise_view.info),
    path('enterprises/<str:id>/logo/', enterprise_view.logo),
    path('enterprises/<str:id>/jobs/', enterprise_view.jobs),
    

    # Admin
    path('admins/', admin_view.admins),
    path('admins/login/', admin_view.login),
    path('admins/<str:id>/', admin_view.getInfo),
    path('admins/<str:id>/changePassword/', admin_view.changePassword),

] + static(settings.MEDIA_URL, document_root = settings.MEDIA_ROOT)