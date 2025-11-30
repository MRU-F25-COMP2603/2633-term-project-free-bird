/// Simple translation map for multi-language support
/// Use: AppTranslations.get('key', currentLanguage)
class AppTranslations {
  static final Map<String, Map<String, String>> _translations = {
    'English': {
      // Main app
      'app_title': 'Free Bird',
      'logout': 'Log Out',
      
      // Settings page
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'text_size': 'Text Size',
      'text_to_speech': 'Text-to-Speech',
      'speak_screen': 'Speak Screen',
      'language': 'Language',
      'notifications': 'Notifications',
      'about_this_app': 'About This App',
      'version': 'Version',
      'about_description': 'FreeBird Travel Companion App\nCreated as a COMP 2633 Final Project.\nFeatures: Document Storage, Camera Uploads, Translation, Flight Tracking, and Hotel Bookings.',
      
      // Login page
      'log_in': 'Log in',
      'email': 'Email',
      'password': 'Password',
      'create_an_account': 'Create an Account',
      
      // Create account page
      'create_account': 'Create Account',
      'confirm_password': 'Confirm Password',
      'already_have_account': 'Already have an account? Log in',
      
      // Navigation
      'flight_tracker': 'Flight Tracker',
      'hotel_bookings': 'Hotel Bookings',
      'documents': 'Documents',
      'translation': 'Translation & Currency',
      'camera': 'Camera',
      
      // Documents page
      'file_upload': 'File Upload',
      'stored_documents': 'Stored Documents',
      
      // Flight tracker
      'add_new_flight': 'Add New Flight',
      'flight_number': 'Flight Number',
      'airline': 'Airline',
      'start_date': 'Start Date',
      'end_date': 'End Date',
      'from': 'From',
      'to': 'To',
      'departure_time': 'Departure Time',
      'arrival_time': 'Arrival Time',
      'add_flight': 'Add Flight',
      'your_flights': 'Your Flights',
      'no_flights': 'No flights added yet.\nAdd one above!',
      'flight_overview': 'Flight Overview',
      'please_fill_all_fields': 'Please fill all fields',
      'flight_added': 'Flight added!',
      
      // Hotel bookings
      'add_new_booking': 'Add New Booking',
      'hotel_name': 'Hotel Name',
      'address': 'Address',
      'check_in_date': 'Check-in Date',
      'check_out_date': 'Check-out Date',
      'add_booking': 'Add Booking',
      'your_bookings': 'Your Bookings',
      'no_bookings': 'No bookings added yet.\nAdd one above!',
      'hotel_overview': 'Hotel Overview',
      'hotel_booking_added': 'Hotel booking added successfully!',
      
      // File upload
      'choose_file_upload': 'Choose File & Upload',
      'upload_complete': 'Upload complete',
      
      // Common
      'error': 'Error',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'share': 'Share',
      
      // Stored documents page
      'your_documents': 'Your Documents',
      'shared_documents': 'Shared Documents',
      'no_files_found': 'No files found.',
      'shared_with': 'Shared with: ',
      'download': 'Download',
      'rename': 'Rename',
      'deleted': 'Deleted',
      
      // Home/Overview page
      'data_overview': 'Data Overview',
      'please_log_in': 'Please log in to view your data',
      'your_travel_dashboard': 'Your Travel Dashboard',
      'overview_of_travel': 'Overview of all your travel data',
      'flights': 'Flights',
      'total_flights': 'Total Flights',
      'your_flight_history': 'Your flight history',
      'flights_tracked': 'Flights tracked',
      'loading': 'Loading...',
      'recent_flights': 'Recent Flights',
      'hotels': 'Hotels',
      'total_hotels': 'Total Hotels',
      'your_hotel_bookings': 'Your hotel bookings',
      'recent_bookings': 'Recent Bookings',
      'documents_count': 'Documents',
      'total_documents': 'Total Documents',
      'your_stored_files': 'Your stored files',
      'recent_uploads': 'Recent Uploads',
      'stored_documents_title': 'Stored Documents',
      'mb_total': 'MB total',
      'quick_stats': 'Quick Stats',
      'recent_activity': 'Recent Activity',
      'no_recent_activity': 'No recent activity\nAdd your first flight to get started!',
      
      // Translation page
      'translator': 'Translator',
      'text_to_translate': 'Text to translate',
      'target': 'Target',
      'translate': 'Translate',
      'result': 'Result',
      'currency_converter': 'Currency Converter (Bank of Canada)',
      'amount': 'Amount',
      'from_currency': 'From',
      'to_currency': 'To',
      'convert': 'Convert',
      
      // Camera page
      'no_camera_detected': 'No camera detected on this device.',
      'photo_saved_at': 'Photo saved at:',
      'capture_photo': 'Capture Photo',
      'saved': 'Saved:',
      
      // Stored documents additional
      'saved_to': 'Saved to',
      'download_failed': 'Download failed:',
      'kb': 'KB',
      'no_shared_documents': 'No shared documents.',
    },
    
    'French': {
      // Main app
      'app_title': 'Free Bird',
      'logout': 'Se Déconnecter',
      
      // Settings page
      'settings': 'Paramètres',
      'dark_mode': 'Mode Sombre',
      'text_size': 'Taille du Texte',
      'text_to_speech': 'Synthèse Vocale',
      'speak_screen': 'Lire l\'Écran',
      'language': 'Langue',
      'notifications': 'Notifications',
      'about_this_app': 'À Propos',
      'version': 'Version',
      'about_description': 'Application de Voyage FreeBird\nCréée comme Projet Final COMP 2633.\nFonctionnalités: Stockage de Documents, Téléchargements de Caméra, Traduction, Suivi des Vols et Réservations d\'Hôtel.',
      
      // Login page
      'log_in': 'Se Connecter',
      'email': 'Email',
      'password': 'Mot de Passe',
      'create_an_account': 'Créer un Compte',
      
      // Create account page
      'create_account': 'Créer un Compte',
      'confirm_password': 'Confirmer le Mot de Passe',
      'already_have_account': 'Vous avez déjà un compte? Se connecter',
      
      // Navigation
      'flight_tracker': 'Suivi des Vols',
      'hotel_bookings': 'Réservations d\'Hôtel',
      'documents': 'Documents',
      'translation': 'Traduction et Devise',
      'camera': 'Caméra',
      
      // Documents page
      'file_upload': 'Télécharger un Fichier',
      'stored_documents': 'Documents Stockés',
      
      // Flight tracker
      'add_new_flight': 'Ajouter un Nouveau Vol',
      'flight_number': 'Numéro de Vol',
      'airline': 'Compagnie Aérienne',
      'start_date': 'Date de Début',
      'end_date': 'Date de Fin',
      'from': 'De',
      'to': 'À',
      'departure_time': 'Heure de Départ',
      'arrival_time': 'Heure d\'Arrivée',
      'add_flight': 'Ajouter Vol',
      'your_flights': 'Vos Vols',
      'no_flights': 'Aucun vol ajouté.\nAjoutez-en un ci-dessus!',
      'flight_overview': 'Aperçu du Vol',
      'please_fill_all_fields': 'Veuillez remplir tous les champs',
      'flight_added': 'Vol ajouté!',
      
      // Hotel bookings
      'add_new_booking': 'Ajouter une Nouvelle Réservation',
      'hotel_name': 'Nom de l\'Hôtel',
      'address': 'Adresse',
      'check_in_date': 'Date d\'Arrivée',
      'check_out_date': 'Date de Départ',
      'add_booking': 'Ajouter Réservation',
      'your_bookings': 'Vos Réservations',
      'no_bookings': 'Aucune réservation ajoutée.\nAjoutez-en une ci-dessus!',
      'hotel_overview': 'Aperçu de l\'Hôtel',
      'hotel_booking_added': 'Réservation d\'hôtel ajoutée avec succès!',
      
      // File upload
      'choose_file_upload': 'Choisir et Télécharger',
      'upload_complete': 'Téléchargement terminé',
      
      // Common
      'error': 'Erreur',
      'cancel': 'Annuler',
      'save': 'Enregistrer',
      'delete': 'Supprimer',
      'share': 'Partager',
      
      // Stored documents page
      'your_documents': 'Vos Documents',
      'shared_documents': 'Documents Partagés',
      'no_files_found': 'Aucun fichier trouvé.',
      'shared_with': 'Partagé avec: ',
      'download': 'Télécharger',
      'rename': 'Renommer',
      'deleted': 'Supprimé',
      
      // Home/Overview page
      'data_overview': 'Aperçu des Données',
      'please_log_in': 'Veuillez vous connecter pour voir vos données',
      'your_travel_dashboard': 'Votre Tableau de Bord de Voyage',
      'overview_of_travel': 'Aperçu de toutes vos données de voyage',
      'flights': 'Vols',
      'total_flights': 'Vols Totaux',
      'your_flight_history': 'Votre historique de vols',
      'flights_tracked': 'Vols suivis',
      'loading': 'Chargement...',
      'recent_flights': 'Vols récents',
      'hotels': 'Hôtels',
      'total_hotels': 'Hôtels Totaux',
      'your_hotel_bookings': 'Vos réservations d\'hôtel',
      'recent_bookings': 'Réservations Récentes',
      'documents_count': 'Documents',
      'total_documents': 'Documents Totaux',
      'your_stored_files': 'Vos fichiers stockés',
      'recent_uploads': 'Téléchargements récents',
      'stored_documents_title': 'Documents stockés',
      'mb_total': 'MB au total',
      'quick_stats': 'Statistiques rapides',
      'recent_activity': 'Activité récente',
      'no_recent_activity': 'Aucune activité récente\nAjoutez votre premier vol pour commencer!',
      
      // Translation page
      'translator': 'Traducteur',
      'text_to_translate': 'Texte à traduire',
      'target': 'Cible',
      'translate': 'Traduire',
      'result': 'Résultat',
      'currency_converter': 'Convertisseur de Devises (Banque du Canada)',
      'amount': 'Montant',
      'from_currency': 'De',
      'to_currency': 'À',
      'convert': 'Convertir',
      
      // Camera page
      'no_camera_detected': 'Aucune caméra détectée sur cet appareil.',
      'photo_saved_at': 'Photo enregistrée à:',
      'capture_photo': 'Capturer une photo',
      'saved': 'Enregistré:',
      
      // Stored documents additional
      'saved_to': 'Enregistré dans',
      'download_failed': 'Échec du téléchargement:',
      'kb': 'Ko',
      'no_shared_documents': 'Aucun document partagé.',
    },
    
    'Spanish': {
      // Main app
      'app_title': 'Free Bird',
      'logout': 'Cerrar Sesión',
      
      // Settings page
      'settings': 'Ajustes',
      'dark_mode': 'Modo Oscuro',
      'text_size': 'Tamaño de Texto',
      'text_to_speech': 'Texto a Voz',
      'speak_screen': 'Leer Pantalla',
      'language': 'Idioma',
      'notifications': 'Notificaciones',
      'about_this_app': 'Acerca de',
      'version': 'Versión',
      'about_description': 'Aplicación de Viaje FreeBird\nCreada como Proyecto Final COMP 2633.\nCaracterísticas: Almacenamiento de Documentos, Subidas de Cámara, Traducción, Seguimiento de Vuelos y Reservas de Hotel.',
      
      // Login page
      'log_in': 'Iniciar Sesión',
      'email': 'Email',
      'password': 'Contraseña',
      'create_an_account': 'Crear una Cuenta',
      
      // Create account page
      'create_account': 'Crear Cuenta',
      'confirm_password': 'Confirmar Contraseña',
      'already_have_account': '¿Ya tienes una cuenta? Iniciar sesión',
      // Navigation
      'flight_tracker': 'Rastreador de Vuelos',
      'hotel_bookings': 'Reservas de Hotel',
      'documents': 'Documentos',
      'translation': 'Traducción y Moneda',
      'camera': 'Cámara',
      
      // Documents page
      'file_upload': 'Subir Archivo',
      'stored_documents': 'Documentos Guardados',
      
      // Flight tracker
      'add_new_flight': 'Agregar Nuevo Vuelo',
      'flight_number': 'Número de Vuelo',
      'airline': 'Aerolínea',
      'start_date': 'Fecha de Inicio',
      'end_date': 'Fecha de Fin',
      'from': 'Desde',
      'to': 'Hasta',
      'departure_time': 'Hora de Salida',
      'arrival_time': 'Hora de Llegada',
      'add_flight': 'Agregar Vuelo',
      'your_flights': 'Tus Vuelos',
      'no_flights': 'No hay vuelos agregados.\n¡Agrega uno arriba!',
      'flight_overview': 'Vista del Vuelo',
      'please_fill_all_fields': 'Por favor complete todos los campos',
      'flight_added': '¡Vuelo agregado!',
      
      // Hotel bookings
      'add_new_booking': 'Agregar Nueva Reserva',
      'hotel_name': 'Nombre del Hotel',
      'address': 'Dirección',
      'check_in_date': 'Fecha de Entrada',
      'check_out_date': 'Fecha de Salida',
      'add_booking': 'Agregar Reserva',
      'your_bookings': 'Tus Reservas',
      'no_bookings': 'No hay reservas agregadas.\n¡Agrega una arriba!',
      'hotel_overview': 'Vista del Hotel',
      'hotel_booking_added': '¡Reserva de hotel agregada exitosamente!',
      
      // File upload
      'choose_file_upload': 'Elegir y Subir',
      'upload_complete': 'Subida completa',
      
      // Common
      'error': 'Error',
      'cancel': 'Cancelar',
      'save': 'Guardar',
      'delete': 'Eliminar',
      'share': 'Compartir',
      
      // Stored documents page
      'your_documents': 'Tus Documentos',
      'shared_documents': 'Documentos Compartidos',
      'no_files_found': 'No se encontraron archivos.',
      'shared_with': 'Compartido con: ',
      'download': 'Descargar',
      'rename': 'Renombrar',
      'deleted': 'Eliminado',
      
      // Home/Overview page
      'data_overview': 'Vista de Datos',
      'please_log_in': 'Inicia sesión para ver tus datos',
      'your_travel_dashboard': 'Tu Panel de Viajes',
      'overview_of_travel': 'Vista general de todos tus datos de viaje',
      'flights': 'Vuelos',
      'total_flights': 'Vuelos Totales',
      'your_flight_history': 'Su historial de vuelos',
      'flights_tracked': 'Vuelos rastreados',
      'loading': 'Cargando...',
      'recent_flights': 'Vuelos recientes',
      'hotels': 'Hoteles',
      'total_hotels': 'Hoteles Totales',
      'your_hotel_bookings': 'Tus reservas de hotel',
      'recent_bookings': 'Reservas Recientes',
      'documents_count': 'Documentos',
      'total_documents': 'Documentos Totales',
      'your_stored_files': 'Tus archivos guardados',
      'recent_uploads': 'Subidas recientes',
      'stored_documents_title': 'Documentos almacenados',
      'mb_total': 'MB en total',
      'quick_stats': 'Estadísticas rápidas',
      'recent_activity': 'Actividad reciente',
      'no_recent_activity': 'Sin actividad reciente\n¡Agregue su primer vuelo para comenzar!',
      
      // Translation page
      'translator': 'Traductor',
      'text_to_translate': 'Texto a traducir',
      'target': 'Objetivo',
      'translate': 'Traducir',
      'result': 'Resultado',
      'currency_converter': 'Convertidor de Divisas (Banco de Canadá)',
      'amount': 'Cantidad',
      'from_currency': 'Desde',
      'to_currency': 'Hasta',
      'convert': 'Convertir',
      
      // Camera page
      'no_camera_detected': 'No se detectó ninguna cámara en este dispositivo.',
      'photo_saved_at': 'Foto guardada en:',
      'capture_photo': 'Capturar foto',
      'saved': 'Guardado:',
      
      // Stored documents additional
      'saved_to': 'Guardado en',
      'download_failed': 'Fallo en la descarga:',
      'kb': 'KB',
      'no_shared_documents': 'No hay documentos compartidos.',
    },
  };

  /// Get translated string for the given key and language
  /// Falls back to English if key not found
  static String get(String key, String language) {
    return _translations[language]?[key] ?? 
           _translations['English']?[key] ?? 
           key;
  }

  /// Get all available languages
  static List<String> get supportedLanguages => _translations.keys.toList();
}
