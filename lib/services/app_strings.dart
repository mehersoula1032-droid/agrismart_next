import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';

class AppStrings {
  final String code;

  AppStrings(this.code);

  static AppStrings of(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    return AppStrings(langProvider.languageCode);
  }

  static String t(BuildContext context, String key) {
    return of(context).tr(key);
  }

  static const Map<String, Map<String, String>> _values = {
    // --- General & Languages ---
    'app_name': {
      'fr': 'AgriSmart',
      'ar': 'أغري سمارت',
      'en': 'AgriSmart',
    },
    'choose_language': {
      'fr': 'Langue',
      'ar': 'اللغة',
      'en': 'Language',
    },
    'lang_ar': {
      'fr': 'العربية',
      'ar': 'العربية',
      'en': 'العربية',
    },
    'lang_fr': {
      'fr': 'Français',
      'ar': 'الفرنسية',
      'en': 'French',
    },
    'lang_en': {
      'fr': 'Anglais',
      'ar': 'الإنجليزية',
      'en': 'English',
    },
    'cancel': {
      'fr': 'Annuler',
      'ar': 'إلغاء',
      'en': 'Cancel',
    },
    'send': {
      'fr': 'Envoyer',
      'ar': 'إرسال',
      'en': 'Send',
    },
    'close': {
      'fr': 'Fermer',
      'ar': 'إغلاق',
      'en': 'Close',
    },
    'generic_error': {
      'fr': 'Une erreur est survenue',
      'ar': 'حدث خطأ ما',
      'en': 'Something went wrong',
    },
    'error_prefix': {
      'fr': 'Erreur',
      'ar': 'خطأ',
      'en': 'Error',
    },

    // --- Login & Auth ---
    'login_title': {
      'fr': 'Se connecter',
      'ar': 'تسجيل الدخول',
      'en': 'Sign In',
    },
    'signup_title': {
      'fr': 'S\'inscrire',
      'ar': 'إنشاء حساب',
      'en': 'Sign Up',
    },
    'farm_name': {
      'fr': 'Nom de l\'exploitation',
      'ar': 'اسم الضيعة / المزرعة',
      'en': 'Farm name',
    },
    'enter_name': {
      'fr': 'Veuillez saisir votre nom',
      'ar': 'يرجى إدخال الاسم',
      'en': 'Please enter your name',
    },
    'email': {
      'fr': 'Email',
      'ar': 'البريد الإلكتروني',
      'en': 'Email',
    },
    'enter_email': {
      'fr': 'Veuillez saisir votre email',
      'ar': 'يرجى إدخال البريد الإلكتروني',
      'en': 'Please enter your email',
    },
    'invalid_email': {
      'fr': 'Email invalide',
      'ar': 'البريد الإلكتروني غير صالح',
      'en': 'Invalid email',
    },
    'password': {
      'fr': 'Mot de passe',
      'ar': 'كلمة المرور',
      'en': 'Password',
    },
    'enter_password': {
      'fr': 'Veuillez saisir votre mot de passe',
      'ar': 'يرجى إدخال كلمة المرور',
      'en': 'Please enter your password',
    },
    'short_password': {
      'fr': 'Mot de passe trop court',
      'ar': 'كلمة المرور قصيرة جدا',
      'en': 'Password is too short',
    },
    'forgot_password': {
      'fr': 'Mot de passe oublié ?',
      'ar': 'هل نسيت كلمة المرور؟',
      'en': 'Forgot password?',
    },
    'reset_password_title': {
      'fr': 'Réinitialisation du mot de passe',
      'ar': 'إعادة تعيين كلمة المرور',
      'en': 'Reset Password',
    },
    'reset_password_desc': {
      'fr': 'Entrez votre adresse email pour recevoir un lien de réinitialisation.',
      'ar': 'أدخل بريدك الإلكتروني لتصلك رسالة إعادة التعيين.',
      'en': 'Enter your email address to receive a reset link.',
    },
    'reset_email_sent': {
      'fr': 'Email de réinitialisation envoyé',
      'ar': 'تم إرسال رسالة إعادة التعيين',
      'en': 'Reset email sent',
    },
    'reset_email_error': {
      'fr': 'Erreur d\'envoi de l\'email',
      'ar': 'خطأ في إرسال البريد الإلكتروني',
      'en': 'Error sending email',
    },
    'already_have_account': {
      'fr': 'Déjà un compte ? ',
      'ar': 'لديك حساب بالفعل؟ ',
      'en': 'Already have an account? ',
    },
    'no_account': {
      'fr': 'Pas de compte ? ',
      'ar': 'ليس لديك حساب؟ ',
      'en': 'Don\'t have an account? ',
    },

    // --- Bottom Navigation ---
    'nav_home': {
      'fr': 'Accueil',
      'ar': 'الرئيسية',
      'en': 'Home',
    },
    'nav_zones': {
      'fr': 'Zones',
      'ar': 'المساحات',
      'en': 'Zones',
    },
    'nav_stats': {
      'fr': 'Statistiques',
      'ar': 'الإحصائيات',
      'en': 'Statistics',
    },
    'nav_plant_scan': {
      'fr': 'Plant Scan',
      'ar': 'فحص النبات',
      'en': 'Plant Scan',
    },
    'nav_gps_mapping': {
      'fr': 'GPS Mapping',
      'ar': 'خريطة GPS',
      'en': 'GPS Mapping',
    },
    'nav_profile': {
      'fr': 'Profil',
      'ar': 'الملف الشخصي',
      'en': 'Profile',
    },

    // --- Home Screen ---
    'smart_farm_subtitle': {
      'fr': 'Votre exploitation intelligente',
      'ar': 'مزرعتك الذكية',
      'en': 'Your smart farm',
    },
    'hello_wave': {
      'fr': 'Bonjour 👋',
      'ar': 'أهلاً بك 👋',
      'en': 'Hello 👋',
    },
    'welcome_crops_msg': {
      'fr': 'Prenez soin de vos cultures avec AgriSmart.',
      'ar': 'اعتنِ بمحاصيلك مع أغري سمارت.',
      'en': 'Take care of your crops with AgriSmart.',
    },
    'weather_kebili': {
      'fr': 'Météo à Kébili',
      'ar': 'الطقس في قبلي',
      'en': 'Weather in Kebili',
    },
    'weather_sunny_no_rain': {
      'fr': 'Soleil • Pas de pluie prévue',
      'ar': 'مشمس • لا أمطار متوقعة',
      'en': 'Sunny • No rain expected',
    },
    'overview_title': {
      'fr': 'Vue d’ensemble',
      'ar': 'نظرة عامة',
      'en': 'Overview',
    },
    'parcels_title': {
      'fr': 'Parcelles',
      'ar': 'القطع الفلاحية',
      'en': 'Parcels',
    },
    'tracked_zones': {
      'fr': 'Zones suivies',
      'ar': 'مناطق متابعة',
      'en': 'Tracked zones',
    },
    'to_irrigate': {
      'fr': 'À irriguer',
      'ar': 'تحتاج للري',
      'en': 'Needs irrigation',
    },
    'below_threshold': {
      'fr': 'Sous le seuil',
      'ar': 'تحت العتبة',
      'en': 'Below threshold',
    },
    'avg_humidity': {
      'fr': 'Humidité moy.',
      'ar': 'متوسط الرطوبة',
      'en': 'Avg. humidity',
    },
    'all_parcels': {
      'fr': 'Toutes les parcelles',
      'ar': 'جميع القطع',
      'en': 'All parcels',
    },
    'soil_ok': {
      'fr': 'Sol correct',
      'ar': 'تربة جيدة',
      'en': 'Healthy soil',
    },
    'above_threshold': {
      'fr': 'Au-dessus du seuil',
      'ar': 'فوق العتبة',
      'en': 'Above threshold',
    },
    'my_parcels': {
      'fr': 'Mes parcelles',
      'ar': 'قطعي الفلاحية',
      'en': 'My parcels',
    },
    'zones_count': {
      'fr': 'zones',
      'ar': 'مناطق',
      'en': 'zones',
    },
    'quick_access': {
      'fr': 'Accès rapide',
      'ar': 'وصول سريع',
      'en': 'Quick access',
    },
    'scan_qr': {
      'fr': 'Scanner QR',
      'ar': 'مسح QR',
      'en': 'Scan QR',
    },
    'ai_assistant': {
      'fr': 'Assistant IA',
      'ar': 'المساعد الذكي',
      'en': 'AI Assistant',
    },

    // --- Profile Screen ---
    'about': {
      'fr': 'À propos',
      'ar': 'حول التطبيق',
      'en': 'About',
    },
    'about_description': {
      'fr':
      'AgriSmart Next est votre assistant d\'agriculture intelligente pour surveiller l\'humidité des sols, gérer vos parcelles et optimiser vos irrigations.\n\nVersion 1.0.0',
      'ar':
      'أغري سمارت نكست هو مساعدك للفلاحة الذكية لمراقبة رطوبة التربة وإدارة قطعك الفلاحية وتحسين الري.\n\nالإصدار 1.0.0',
      'en':
      'AgriSmart Next is your smart farming assistant to monitor soil moisture, manage your parcels, and optimize irrigation.\n\nVersion 1.0.0',
    },
    'logout': {
      'fr': 'Se déconnecter',
      'ar': 'تسجيل الخروج',
      'en': 'Log Out',
    },
    'logout_title': {
      'fr': 'Déconnexion',
      'ar': 'تأكيد الخروج',
      'en': 'Sign Out',
    },
    'logout_confirm_msg': {
      'fr': 'Voulez-vous vraiment vous déconnecter d\'AgriSmart ?',
      'ar': 'هل أنت متأكد أنك تريد تسجيل الخروج من أغري سمارت؟',
      'en': 'Are you sure you want to log out of AgriSmart?',
    },

    // --- Zones Screen ---
    'avg_humidity_label': {
      'fr': 'Humidité moyenne',
      'ar': 'متوسط الرطوبة',
      'en': 'Average humidity',
    },
    'min_humidity': {
      'fr': 'Humidité min',
      'ar': 'أدنى رطوبة',
      'en': 'Min. humidity',
    },
    'no_parcels_registered': {
      'fr': 'Aucune parcelle enregistrée',
      'ar': 'لا توجد أي قطعة مسجلة',
      'en': 'No parcels registered',
    },
    'add_parcel_hint': {
      'fr': 'Appuyez sur le bouton + pour ajouter une nouvelle zone.',
      'ar': 'اضغط على الزر + لإضافة منطقة جديدة.',
      'en': 'Tap the + button to add a new zone.',
    },

    // --- Statistics Screen ---
    'air_humidity_label': {
      'fr': 'Humidité de l\'air',
      'ar': 'رطوبة الهواء',
      'en': 'Air humidity',
    },
    'wind_label': {
      'fr': 'Vent',
      'ar': 'الرياح',
      'en': 'Wind',
    },
    'day_thu': {
      'fr': 'Jeu',
      'ar': 'الخميس',
      'en': 'Thu',
    },
    'day_fri': {
      'fr': 'Ven',
      'ar': 'الجمعة',
      'en': 'Fri',
    },
    'day_sat': {
      'fr': 'Sam',
      'ar': 'السبت',
      'en': 'Sat',
    },
    'no_significant_rain': {
      'fr': 'Pas de pluie significative prévue',
      'ar': 'لا أمطار مهمة متوقعة',
      'en': 'No significant rain expected',
    },
    'updated_at_1435': {
      'fr': 'Mis à jour à 14:35',
      'ar': 'محدّث في 14:35',
      'en': 'Updated at 14:35',
    },
    'zones_to_irrigate_summary': {
      'fr': 'zone(s) sur',
      'ar': 'منطقة (مناطق) من أصل',
      'en': 'zone(s) out of',
    },
    'to_irrigate_parenthesis': {
      'fr': 'à irriguer',
      'ar': 'تحتاج للري',
      'en': 'to irrigate',
    },
    'humidity_by_zone': {
      'fr': 'Humidité par zone',
      'ar': 'الرطوبة حسب المنطقة',
      'en': 'Humidity by zone',
    },

    // --- Plant Recognition Screen ---
    'plant_recognition_title': {
      'fr': 'Plant Recognition',
      'ar': 'التعرف على النبات',
      'en': 'Plant Recognition',
    },
    'analyze_plant_heading': {
      'fr': 'Analysez votre plante',
      'ar': 'حلّل نبتتك',
      'en': 'Analyze your plant',
    },
    'analyze_plant_subtitle': {
      'fr':
      'Prenez une photo ou choisissez une image pour analyser votre plante.',
      'ar': 'التقط صورة أو اختر صورة من المعرض لتحليل نبتتك.',
      'en': 'Take a photo or choose an image to analyze your plant.',
    },
    'no_image_selected': {
      'fr': 'Aucune image sélectionnée',
      'ar': 'لم يتم اختيار أي صورة',
      'en': 'No image selected',
    },
    'camera': {
      'fr': 'Caméra',
      'ar': 'الكاميرا',
      'en': 'Camera',
    },
    'gallery': {
      'fr': 'Galerie',
      'ar': 'المعرض',
      'en': 'Gallery',
    },
    'analyzing_image': {
      'fr': 'Analyse de votre image...',
      'ar': 'جاري تحليل الصورة...',
      'en': 'Analyzing your image...',
    },
    'no_result_found': {
      'fr': 'Aucun résultat trouvé.',
      'ar': 'لم يتم العثور على نتائج.',
      'en': 'No results found.',
    },
    'image_analysis_error': {
      'fr': 'Erreur lors de l’analyse de l’image.',
      'ar': 'حدث خطأ أثناء تحليل الصورة.',
      'en': 'Error while analyzing the image.',
    },
    'analysis_results': {
      'fr': 'Résultats de l’analyse',
      'ar': 'نتائج التحليل',
      'en': 'Analysis results',
    },
    'confidence_label': {
      'fr': 'Confiance',
      'ar': 'نسبة الثقة',
      'en': 'Confidence',
    },
    'plant_disclaimer_note': {
      'fr':
      'Remarque : cette analyse identifie des éléments généraux dans l’image. Elle ne permet pas de diagnostiquer les maladies des plantes.',
      'ar':
      'ملاحظة: يحدد هذا التحليل عناصر عامة في الصورة، ولا يغني عن تشخيص أمراض النباتات.',
      'en':
      'Note: this analysis identifies general elements in the image and does not diagnose plant diseases.',
    },

    // --- GPS Farm Mapping Screen ---
    'gps_map_title': {
      'fr': 'Carte & Marqueurs GPS',
      'ar': 'خريطة وعلامات GPS',
      'en': 'Map & GPS Markers',
    },
    'add_parcel_gps_tooltip': {
      'fr': 'Ajouter une parcelle avec GPS',
      'ar': 'إضافة قطعة بإحداثيات GPS',
      'en': 'Add a parcel with GPS',
    },
    'soil_ok_short': {
      'fr': 'Sol OK',
      'ar': 'تربة جيدة',
      'en': 'Soil OK',
    },
    'humidity_short': {
      'fr': 'Humidité',
      'ar': 'الرطوبة',
      'en': 'Humidity',
    },
    'threshold_short': {
      'fr': 'Seuil',
      'ar': 'العتبة',
      'en': 'Threshold',
    },
    'gps_short': {
      'fr': 'GPS',
      'ar': 'GPS',
      'en': 'GPS',
    },
    'center_action': {
      'fr': 'Centrer',
      'ar': 'توسيط',
      'en': 'Center',
    },
    'edit_action': {
      'fr': 'Modifier',
      'ar': 'تعديل',
      'en': 'Edit',
    },
    'no_geolocated_parcels': {
      'fr':
      'Aucune parcelle géolocalisée. Ajoutez des coordonnées GPS dans vos parcelles.',
      'ar': 'لا توجد قطع محددة الموقع. أضف إحداثيات GPS إلى قطعك.',
      'en': 'No geolocated parcels. Add GPS coordinates to your parcels.',
    },

    // --- Parcel Card ---
    'crop_label': {
      'fr': 'Culture',
      'ar': 'المحصول',
      'en': 'Crop',
    },
    'confirmation_title': {
      'fr': 'Confirmation',
      'ar': 'تأكيد الحذف',
      'en': 'Confirmation',
    },
    'delete_parcel_confirm_prefix': {
      'fr': 'Voulez-vous vraiment supprimer la parcelle',
      'ar': 'هل أنت متأكد أنك تريد حذف القطعة',
      'en': 'Are you sure you want to delete the parcel',
    },
    'delete_action': {
      'fr': 'Supprimer',
      'ar': 'حذف',
      'en': 'Delete',
    },
    'parcel_deleted_success': {
      'fr': 'Parcelle supprimée avec succès',
      'ar': 'تم حذف القطعة بنجاح',
      'en': 'Parcel deleted successfully',
    },

    // --- Smart Expiry Home Card ---
    'smart_expiry_title': {
      'fr': 'Smart Expiry Detector',
      'ar': 'كاشف انتهاء الصلاحية الذكي',
      'en': 'Smart Expiry Detector',
    },
    'expiring_soon_count': {
      'fr': 'bientôt expirés',
      'ar': 'تنتهي صلاحيتها قريباً',
      'en': 'expiring soon',
    },
    'expired_count': {
      'fr': 'expirés',
      'ar': 'منتهية الصلاحية',
      'en': 'expired',
    },

    // --- Parcel Form Screen ---
    'required_field': {
      'fr': 'Ce champ est obligatoire',
      'ar': 'هذا الحقل إجباري',
      'en': 'This field is required',
    },
    'invalid_number': {
      'fr': 'Entrez un nombre valide',
      'ar': 'أدخل رقماً صحيحاً',
      'en': 'Enter a valid number',
    },
    'invalid_coordinate': {
      'fr': 'Coordonnée invalide',
      'ar': 'إحداثية غير صالحة',
      'en': 'Invalid coordinate',
    },
    'parcel_updated_success': {
      'fr': 'Parcelle modifiée avec succès',
      'ar': 'تم تعديل القطعة بنجاح',
      'en': 'Parcel updated successfully',
    },
    'parcel_added_success': {
      'fr': 'Parcelle ajoutée avec succès',
      'ar': 'تمت إضافة القطعة بنجاح',
      'en': 'Parcel added successfully',
    },
    'edit_parcel_title': {
      'fr': 'Modifier la parcelle',
      'ar': 'تعديل القطعة',
      'en': 'Edit parcel',
    },
    'new_parcel_title': {
      'fr': 'Nouvelle parcelle',
      'ar': 'قطعة جديدة',
      'en': 'New parcel',
    },
    'parcel_management_heading': {
      'fr': 'Gestion de votre parcelle',
      'ar': 'إدارة القطعة الفلاحية',
      'en': 'Manage your parcel',
    },
    'parcel_form_subtitle': {
      'fr': 'Complétez les informations de votre terrain.',
      'ar': 'أدخل معلومات أرضك الفلاحية.',
      'en': 'Fill in your land details.',
    },
    'general_info': {
      'fr': 'Informations générales',
      'ar': 'معلومات عامة',
      'en': 'General information',
    },
    'parcel_name_label': {
      'fr': 'Nom de la parcelle',
      'ar': 'اسم القطعة',
      'en': 'Parcel name',
    },
    'parcel_name_hint': {
      'fr': 'Ex: Parcelle Nord',
      'ar': 'مثال: القطعة الشمالية',
      'en': 'Ex: North Parcel',
    },
    'crop_type_label': {
      'fr': 'Type de culture',
      'ar': 'نوع المحصول',
      'en': 'Crop type',
    },
    'crop_type_hint': {
      'fr': 'Ex: Olivier, Tomate...',
      'ar': 'مثال: زيتون، طماطم...',
      'en': 'Ex: Olive, Tomato...',
    },
    'area_label': {
      'fr': 'Surface',
      'ar': 'المساحة',
      'en': 'Area',
    },
    'location_label': {
      'fr': 'Localisation',
      'ar': 'الموقع',
      'en': 'Location',
    },
    'location_hint': {
      'fr': 'Ex: Kébili',
      'ar': 'مثال: قبلي',
      'en': 'Ex: Kebili',
    },
    'gps_position_heading': {
      'fr': 'Position GPS (Marqueur carte)',
      'ar': 'إحداثيات GPS (علامة الخريطة)',
      'en': 'GPS Position (Map marker)',
    },
    'ex_kebili': {
      'fr': 'Ex. Kébili',
      'ar': 'مثال: قبلي',
      'en': 'Ex. Kebili',
    },
    'latitude_label': {
      'fr': 'Latitude',
      'ar': 'خط العرض (Latitude)',
      'en': 'Latitude',
    },
    'longitude_label': {
      'fr': 'Longitude',
      'ar': 'خط الطول (Longitude)',
      'en': 'Longitude',
    },
    'irrigation_data_heading': {
      'fr': 'Données d’irrigation',
      'ar': 'بيانات الري',
      'en': 'Irrigation data',
    },
    'current_humidity_label': {
      'fr': 'Humidité actuelle',
      'ar': 'الرطوبة الحالية',
      'en': 'Current humidity',
    },
    'irrigation_threshold_label': {
      'fr': 'Seuil d’irrigation',
      'ar': 'عتبة الري',
      'en': 'Irrigation threshold',
    },
    'save_changes_btn': {
      'fr': 'Enregistrer les modifications',
      'ar': 'حفظ التعديلات',
      'en': 'Save changes',
    },
    'add_parcel_btn': {
      'fr': 'Ajouter la parcelle',
      'ar': 'إضافة القطعة',
      'en': 'Add parcel',
    },

    // --- Expiry Management Screen ---
    'ocr_error_prefix': {
      'fr': 'Erreur OCR',
      'ar': 'خطأ في التعرف على النص (OCR)',
      'en': 'OCR Error',
    },
    'confirm_product_title': {
      'fr': 'Confirmer le produit',
      'ar': 'تأكيد المنتج',
      'en': 'Confirm product',
    },
    'product_name_label': {
      'fr': 'Nom du produit',
      'ar': 'اسم المنتج',
      'en': 'Product name',
    },
    'product_name_hint': {
      'fr': 'Ex: Engrais NPK, Semences...',
      'ar': 'مثال: سماد NPK، بذور...',
      'en': 'Ex: NPK Fertilizer, Seeds...',
    },
    'category_label': {
      'fr': 'Catégorie',
      'ar': 'الفئة',
      'en': 'Category',
    },
    'cat_fertilizer': {
      'fr': 'Engrais',
      'ar': 'أسمدة',
      'en': 'Fertilizer',
    },
    'cat_seeds': {
      'fr': 'Semences',
      'ar': 'بذور',
      'en': 'Seeds',
    },
    'cat_phytosanitary': {
      'fr': 'Produit phyto',
      'ar': 'مبيدات / وقاية',
      'en': 'Phytosanitary',
    },
    'cat_other': {
      'fr': 'Autre',
      'ar': 'أخرى',
      'en': 'Other',
    },
    'expiry_date_label': {
      'fr': 'Date d\'expiration',
      'ar': 'تاريخ انتهاء الصلاحية',
      'en': 'Expiry date',
    },
    'detected_text_prefix': {
      'fr': 'Texte détecté',
      'ar': 'النص المكتشف',
      'en': 'Detected text',
    },
    'save_and_schedule_alerts': {
      'fr': 'Enregistrer & programmer alertes',
      'ar': 'حفظ وبرمجة التنبيهات',
      'en': 'Save & schedule alerts',
    },
    'unnamed_product': {
      'fr': 'Produit sans nom',
      'ar': 'منتج بدون اسم',
      'en': 'Unnamed product',
    },
    'status_valid_days': {
      'fr': 'Valide',
      'ar': 'صالح',
      'en': 'Valid',
    },
    'status_expiring_soon_days': {
      'fr': 'Expire bientôt',
      'ar': 'ينتهي قريباً',
      'en': 'Expiring soon',
    },
    'status_expired_days': {
      'fr': 'Expiré',
      'ar': 'منتهي الصلاحية',
      'en': 'Expired',
    },
    'days_short': {
      'fr': 'j',
      'ar': 'ي',
      'en': 'd',
    },
    'import_image_tooltip': {
      'fr': 'Importer une image',
      'ar': 'استيراد صورة',
      'en': 'Import an image',
    },
    'analyzing_short': {
      'fr': 'Analyse...',
      'ar': 'جاري التحليل...',
      'en': 'Analyzing...',
    },
    'scan_date_btn': {
      'fr': 'Scanner date',
      'ar': 'مسح التاريخ',
      'en': 'Scan date',
    },
    'filter_all': {
      'fr': 'Tous',
      'ar': 'الكل',
      'en': 'All',
    },
    'filter_valid': {
      'fr': 'Valide',
      'ar': 'صالح',
      'en': 'Valid',
    },
    'filter_expiring_soon': {
      'fr': 'Expire bientôt',
      'ar': 'ينتهي قريباً',
      'en': 'Expiring soon',
    },
    'filter_expired': {
      'fr': 'Expiré',
      'ar': 'منتهي',
      'en': 'Expired',
    },
    'no_products_yet': {
      'fr': 'Aucun produit enregistré pour le moment.',
      'ar': 'لا توجد منتجات مسجلة حالياً.',
      'en': 'No products registered yet.',
    },
    'exp_short': {
      'fr': 'Exp',
      'ar': 'انتهاء',
      'en': 'Exp',
    },

    // --- QR Scanner Screen ---
    'sensor_prefix': {
      'fr': 'Capteur',
      'ar': 'حساس',
      'en': 'Sensor',
    },
    'zone_label': {
      'fr': 'Zone',
      'ar': 'المنطقة',
      'en': 'Zone',
    },
    'measured_humidity_label': {
      'fr': 'Humidité mesurée',
      'ar': 'الرطوبة المقاسة',
      'en': 'Measured humidity',
    },
    'no_sensor_detected': {
      'fr': 'Aucun capteur détecté',
      'ar': 'لم يتم رصد أي حساس',
      'en': 'No sensor detected',
    },
    'sensor_detected_title': {
      'fr': 'Capteur Détecté',
      'ar': 'تم رصد حساس',
      'en': 'Sensor Detected',
    },
    'parcel_colon_label': {
      'fr': 'Parcelle',
      'ar': 'القطعة',
      'en': 'Parcel',
    },
    'transmitted_humidity_label': {
      'fr': 'Humidité transmise',
      'ar': 'الرطوبة المرسلة',
      'en': 'Transmitted humidity',
    },
    'sensor_data_synced': {
      'fr': 'Données du capteur synchronisées !',
      'ar': 'تمت مزامنة بيانات الحساس!',
      'en': 'Sensor data synced!',
    },
    'synchronize_btn': {
      'fr': 'Synchroniser',
      'ar': 'مزامنة',
      'en': 'Synchronize',
    },
    'qr_screen_title': {
      'fr': 'Scanner & Générateur QR',
      'ar': 'ماسح ومولّد QR',
      'en': 'QR Scanner & Generator',
    },
    'tab_scanner': {
      'fr': 'Scanner',
      'ar': 'مسح',
      'en': 'Scanner',
    },
    'tab_my_qr': {
      'fr': 'Mon QR Code',
      'ar': 'رمزي QR',
      'en': 'My QR Code',
    },
    'place_qr_in_frame': {
      'fr': 'Placez le QR code du capteur au centre du cadre',
      'ar': 'ضع رمز QR الخاص بالحساس في وسط الإطار',
      'en': 'Place the sensor QR code in the center of the frame',
    },
    'scan_sensor_btn': {
      'fr': 'Scanner le Capteur',
      'ar': 'مسح الحساس',
      'en': 'Scan Sensor',
    },
    'generate_qr_heading': {
      'fr': 'Générer un QR Code pour vos parcelles',
      'ar': 'توليد رمز QR لقطعك الفلاحية',
      'en': 'Generate a QR Code for your parcels',
    },
    'select_parcel_label': {
      'fr': 'Sélectionner une parcelle',
      'ar': 'اختر قطعة فلاحية',
      'en': 'Select a parcel',
    },
    'qr_ready_to_share': {
      'fr': 'QR Code prêt à être imprimé ou partagé',
      'ar': 'رمز QR جاهز للطباعة أو المشاركة',
      'en': 'QR Code ready to print or share',
    },
    'share_qr_btn': {
      'fr': 'Partager le QR Code',
      'ar': 'مشاركة رمز QR',
      'en': 'Share QR Code',
    },

    // --- Voice Assistant Screen ---
    'voice_assistant_title': {
      'fr': 'Assistant Vocal AgriSmart',
      'ar': 'المساعد الصوتي أغري سمارت',
      'en': 'AgriSmart Voice Assistant',
    },
    'voice_greeting': {
      'fr':
      'Bonjour ! Je suis votre assistant intelligent AgriSmart 🌾. Posez-moi vos questions sur vos parcelles, l\'irrigation, la météo ou le fonctionnement de l\'application !',
      'ar':
      'أهلاً بك! أنا مساعدك الذكي أغري سمارت 🌾. اسألني عن قطعك الفلاحية، الري، الطقس، أو كيفية استخدام التطبيق!',
      'en':
      'Hello! I am your smart AgriSmart assistant 🌾. Ask me about your parcels, irrigation, weather, or how to use the app!',
    },
    'spoken_sample_question': {
      'fr': 'Quelles parcelles nécessitent une irrigation ?',
      'ar': 'أي القطع الفلاحية تحتاج إلى ري؟',
      'en': 'Which parcels need irrigation?',
    },
    'ai_parcel_alert': {
      'fr': '⚠️ Attention : Humidité faible',
      'ar': '⚠️ تنبيه: رطوبة منخفضة',
      'en': '⚠️ Warning: Low humidity',
    },
    'ai_under_threshold': {
      'fr': 'sous le seuil de',
      'ar': 'تحت العتبة',
      'en': 'below threshold of',
    },
    'ai_irrigation_recommended': {
      'fr': 'Irrigation recommandée !',
      'ar': 'يُنصح بالري فوراً!',
      'en': 'Irrigation recommended!',
    },
    'ai_status_perfect': {
      'fr': '✅ Statut parfait : Humidité de',
      'ar': '✅ حالة ممتازة: الرطوبة',
      'en': '✅ Great status: Humidity at',
    },
    'ai_threshold_parens': {
      'fr': 'Seuil',
      'ar': 'العتبة',
      'en': 'Threshold',
    },
    'ai_area_bullet': {
      'fr': 'Surface',
      'ar': 'المساحة',
      'en': 'Area',
    },
    'ai_location_bullet': {
      'fr': 'Localisation',
      'ar': 'الموقع',
      'en': 'Location',
    },
    'ai_all_humidity_ideal': {
      'fr':
      '🎉 Excellente nouvelle ! Toutes vos parcelles sont à un niveau d\'humidité idéal. Aucune action d\'irrigation n\'est nécessaire actuellement.',
      'ar':
      '🎉 خبر ممتاز! جميع قطعك الفلاحية عند مستوى رطوبة مثالي ولا تحتاج إلى ري حالياً.',
      'en':
      '🎉 Great news! All your parcels have ideal moisture levels. No irrigation is needed right now.',
    },
    'ai_zones_below_prefix': {
      'fr': '💧 Vous avez',
      'ar': '💧 لديك',
      'en': '💧 You have',
    },
    'ai_zones_below_mid': {
      'fr': 'zone(s) sur',
      'ar': 'منطقة (مناطق) من أصل',
      'en': 'zone(s) out of',
    },
    'ai_zones_below_suffix': {
      'fr': 'sous le seuil d\'irrigation :',
      'ar': 'تحت عتبة الري:',
      'en': 'below irrigation threshold:',
    },
    'ai_advise_irrigate': {
      'fr': 'Je vous conseille d\'activer l\'irrigation sur ces zones.',
      'ar': 'أنصحك بتفعيل الري في هذه المناطق.',
      'en': 'I recommend starting irrigation in these zones.',
    },
    'ai_weather_kebili_title': {
      'fr': '☀️ Météo Kébili :',
      'ar': '☀️ طقس قبلي:',
      'en': '☀️ Kebili Weather:',
    },
    'ai_temp_bullet': {
      'fr': 'Température',
      'ar': 'درجة الحرارة',
      'en': 'Temperature',
    },
    'ai_forecast_bullet': {
      'fr':
      'Prévisions : Pas de pluie significative prévue pour les 3 prochains jours.',
      'ar': 'التوقعات: لا أمطار مهمة متوقعة خلال الأيام الثلاثة القادمة.',
      'en': 'Forecast: No significant rain expected over the next 3 days.',
    },
    'ai_guide_add': {
      'fr':
      '➕ Pour ajouter une parcelle :\n1. Allez sur l\'onglet Zones.\n2. Appuyez sur le bouton vert flottant + en bas à droite.\n3. Remplissez le nom, le type de culture, la surface et le seuil d\'irrigation.',
      'ar':
      '➕ لإضافة قطعة فلاحية:\n1. انتقل إلى تبويب المساحات (Zones).\n2. اضغط على الزر الأخضر + في الأسفل.\n3. أدخل الاسم، نوع المحصول، المساحة، وعتبة الري.',
      'en':
      '➕ To add a parcel:\n1. Go to the Zones tab.\n2. Tap the floating green + button at the bottom.\n3. Fill in name, crop type, area, and irrigation threshold.',
    },
    'ai_guide_delete': {
      'fr':
      '🗑️ Pour supprimer une parcelle :\nFaites un appui long sur la carte de la parcelle dans l\'onglet Zones, puis confirmez la suppression.',
      'ar':
      '🗑️ لحذف قطعة فلاحية:\nاضغط مطولاً على بطاقة القطعة في تبويب المساحات ثم أكد الحذف.',
      'en':
      '🗑️ To delete a parcel:\nLong-press the parcel card in the Zones tab and confirm deletion.',
    },
    'ai_guide_qr': {
      'fr':
      '📷 Pour utiliser le QR Code :\nAppuyez sur l\'icône du scanner QR en haut de l\'écran d\'accueil pour scanner vos capteurs ou générer un QR code.',
      'ar':
      '📷 لاستخدام رمز QR:\nاضغط على أيقونة ماسح QR أعلى الشاشة الرئيسية لمسح الحساسات أو توليد رمز QR.',
      'en':
      '📷 To use QR Code:\nTap the QR scanner icon at the top of the home screen to scan sensors or generate a QR code.',
    },
    'ai_guide_password': {
      'fr':
      '🔑 Pour réinitialiser votre mot de passe :\nSur l\'écran de connexion, cliquez sur "Mot de passe oublié ?" et saisissez votre email.',
      'ar':
      '🔑 لإعادة تعيين كلمة المرور:\nفي شاشة تسجيل الدخول، اضغط على "هل نسيت كلمة المرور؟" وأدخل بريدك الإلكتروني.',
      'en':
      '🔑 To reset your password:\nOn the login screen, tap "Forgot password?" and enter your email.',
    },
    'ai_agri_tips': {
      'fr':
      '🌱 Conseil Agricole AgriSmart :\n• Tomate : Maintenir l\'humidité au-dessus de 35%.\n• Olivier : Arrosage modéré, résistant à la sécheresse.\n• Heure conseillée : Irriguez tôt le matin ou tard le soir.',
      'ar':
      '🌱 نصيحة فلاحية من أغري سمارت:\n• الطماطم: حافظ على رطوبة أعلى من 35%.\n• الزيتون: ري معتدل ومقاوم للجفاف.\n• أفضل وقت: اسقِ في الصباح الباكر أو في المساء لتقليل التبخر.',
      'en':
      '🌱 AgriSmart Farming Tip:\n• Tomato: Keep moisture above 35%.\n• Olive: Moderate watering, drought-tolerant.\n• Best time: Irrigate early morning or late evening to reduce evaporation.',
    },
    'ai_farm_summary_title': {
      'fr': '📊 Résumé de votre exploitation :',
      'ar': '📊 ملخص مزرعتك:',
      'en': '📊 Your farm summary:',
    },
    'ai_total_parcels_bullet': {
      'fr': 'Total des parcelles',
      'ar': 'إجمالي القطع',
      'en': 'Total parcels',
    },
    'ai_total_area_bullet': {
      'fr': 'Surface totale',
      'ar': 'المساحة الإجمالية',
      'en': 'Total area',
    },
    'ai_fallback_help': {
      'fr':
      'Je suis à votre service ! Vous pouvez me demander :\n• "Quelles parcelles irriguer ?"\n• "Comment supprimer une parcelle ?"\n• "Quelle est la météo à Kébili ?"',
      'ar':
      'أنا في خدمتك! يمكنك أن تسألني:\n• "أي القطع تحتاج للري؟"\n• "كيف أحذف قطعة؟"\n• "ما هو الطقس في قبلي؟"',
      'en':
      'I\'m here to help! You can ask:\n• "Which parcels need irrigation?"\n• "How do I delete a parcel?"\n• "What is the weather in Kebili?"',
    },
    'listening_in_progress': {
      'fr': 'Écoute en cours... Posez votre question',
      'ar': 'جاري الاستماع... اطرح سؤالك',
      'en': 'Listening... Ask your question',
    },
    'tap_mic_to_speak': {
      'fr': 'Appuyez sur le micro pour parler',
      'ar': 'اضغط على الميكروفون للتحدث',
      'en': 'Tap the mic to speak',
    },
    'chip_zones_to_irrigate': {
      'fr': 'Zones à irriguer ?',
      'ar': 'مناطق تحتاج للري؟',
      'en': 'Zones to irrigate?',
    },
    'chip_how_delete_parcel': {
      'fr': 'Comment supprimer une parcelle ?',
      'ar': 'كيف أحذف قطعة؟',
      'en': 'How to delete a parcel?',
    },
    'chip_north_parcel': {
      'fr': 'Parcelle Nord ?',
      'ar': 'القطعة الشمالية؟',
      'en': 'North Parcel?',
    },
    'chip_kebili_weather': {
      'fr': 'Météo Kébili',
      'ar': 'طقس قبلي',
      'en': 'Kebili Weather',
    },
    'ask_assistant_hint': {
      'fr': 'Posez votre question à l\'assistant...',
      'ar': 'اطرح سؤالك على المساعد...',
      'en': 'Ask the assistant a question...',
    },

    // --- Ajouts : météo réelle, validations, détail parcelle ---
    'weather_loading': {
      'fr': 'Chargement de la météo...',
      'ar': 'جاري تحميل الطقس...',
      'en': 'Loading weather...',
    },
    'weather_retry': {
      'fr': 'Réessayer',
      'ar': 'إعادة المحاولة',
      'en': 'Retry',
    },
    'weather_updated_at': {
      'fr': 'Mis à jour à',
      'ar': 'محدّث في',
      'en': 'Updated at',
    },
    'weather_rain_expected': {
      'fr': 'Pluie prévue',
      'ar': 'أمطار متوقعة',
      'en': 'Rain expected',
    },
    'weather_postpone': {
      'fr': 'repoussez l\'irrigation',
      'ar': 'أجّل الري',
      'en': 'postpone irrigation',
    },
    'weather_unavailable': {
      'fr': 'Météo indisponible pour le moment. Vérifiez votre connexion.',
      'ar': 'الطقس غير متاح حاليا. تحقق من اتصالك.',
      'en': 'Weather is unavailable right now. Check your connection.',
    },
    'weather_err_timeout': {
      'fr': 'Le serveur met trop de temps à répondre',
      'ar': 'الخادم يستغرق وقتا طويلا للرد',
      'en': 'The server is taking too long to respond',
    },
    'weather_err_network': {
      'fr': 'Pas de connexion Internet',
      'ar': 'لا يوجد اتصال بالإنترنت',
      'en': 'No Internet connection',
    },
    'weather_err_server': {
      'fr': 'Erreur du serveur météo',
      'ar': 'خطأ في خادم الطقس',
      'en': 'Weather server error',
    },
    'weather_err_parse': {
      'fr': 'Réponse du serveur illisible',
      'ar': 'استجابة الخادم غير مقروءة',
      'en': 'Unreadable server response',
    },
    'weather_err_unknown': {
      'fr': 'Erreur inattendue',
      'ar': 'خطأ غير متوقع',
      'en': 'Unexpected error',
    },
    'day_mon': {
      'fr': 'Lun',
      'ar': 'الاثنين',
      'en': 'Mon',
    },
    'day_tue': {
      'fr': 'Mar',
      'ar': 'الثلاثاء',
      'en': 'Tue',
    },
    'day_wed': {
      'fr': 'Mer',
      'ar': 'الأربعاء',
      'en': 'Wed',
    },
    'day_sun': {
      'fr': 'Dim',
      'ar': 'الأحد',
      'en': 'Sun',
    },
    'advice_wait_rain': {
      'fr': 'Attendre la pluie',
      'ar': 'انتظر المطر',
      'en': 'Wait for the rain',
    },
    'advice_irrigate_now': {
      'fr': 'Irriguer maintenant',
      'ar': 'اسق الآن',
      'en': 'Irrigate now',
    },
    'min_two_chars': {
      'fr': '2 caractères minimum',
      'ar': 'حرفان على الأقل',
      'en': 'At least 2 characters',
    },
    'percent_range': {
      'fr': 'La valeur doit être comprise entre 0 et 100',
      'ar': 'يجب أن تكون القيمة بين 0 و 100',
      'en': 'Value must be between 0 and 100',
    },
    'password_min_6': {
      'fr': '6 caractères minimum',
      'ar': '6 أحرف على الأقل',
      'en': 'At least 6 characters',
    },
    'detail_needs_irrigation': {
      'fr': 'Besoin d\'irrigation',
      'ar': 'تحتاج إلى ري',
      'en': 'Needs irrigation',
    },
    'detail_soil_ok': {
      'fr': 'Sol correct',
      'ar': 'تربة جيدة',
      'en': 'Healthy soil',
    },
    'detail_current_humidity': {
      'fr': 'Humidité actuelle',
      'ar': 'الرطوبة الحالية',
      'en': 'Current humidity',
    },
    'detail_threshold': {
      'fr': 'Seuil d\'irrigation',
      'ar': 'عتبة الري',
      'en': 'Irrigation threshold',
    },
    'detail_valve': {
      'fr': 'Vanne',
      'ar': 'الصمام',
      'en': 'Valve',
    },
    'detail_valve_open': {
      'fr': 'Ouverte',
      'ar': 'مفتوح',
      'en': 'Open',
    },
    'detail_valve_closed': {
      'fr': 'Fermée',
      'ar': 'مغلق',
      'en': 'Closed',
    },
    'detail_edit_parcel': {
      'fr': 'Modifier cette zone',
      'ar': 'تعديل هذه المنطقة',
      'en': 'Edit this zone',
    },
  };

  String tr(String key) {
    final map = _values[key];
    if (map == null) return key;
    return map[code] ?? map['fr'] ?? key;
  }
}