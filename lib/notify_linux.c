#include <stdio.h>
#include <dbus/dbus.h>
#include "notify.h"

/* Generate Linux notification using DBUS */
int send_notification(const char * title, const char * description){
  DBusConnection *connection;
  DBusError error;
  DBusMessage *message;

  DBusMessageIter iter;

  dbus_error_init(&error);
  if(!dbus_validate_bus_name("org.freedesktop.Notifications", &error)){
    printf("Validation Failed!\n");
    dbus_error_free(&error);
    return 1;
  }

  connection = dbus_bus_get(DBUS_BUS_SESSION, &error);
  if(!connection){
    printf("Failed to open connection to message bus!\n");
    dbus_error_free(&error);
    return 2;
  }

  message = dbus_message_new_method_call(
    NULL,
    "/org/freedesktop/Notifications",
    "org.freedesktop.Notifications",
    "Notify"
  );
  dbus_message_set_auto_start(message, TRUE);

  if(!dbus_message_set_destination(message, "org.freedesktop.Notifications")){
    printf("Failure setting the destination\n");
    return 1;
  }

  const char * app_name = "Testz";
  dbus_uint32_t replace_id = 0;
  const char * icon = "";
  dbus_int32_t expiration_timeout = -1;

  /* Prepare parameters for the Notify call */
  dbus_message_iter_init_append(message, &iter);
  dbus_message_iter_append_basic(&iter, DBUS_TYPE_STRING, &app_name);
  dbus_message_iter_append_basic(&iter, DBUS_TYPE_UINT32, &replace_id);
  dbus_message_iter_append_basic(&iter, DBUS_TYPE_STRING, &icon);
  dbus_message_iter_append_basic(&iter, DBUS_TYPE_STRING, &title);
  dbus_message_iter_append_basic(&iter, DBUS_TYPE_STRING, &description);

  DBusMessageIter array_iter;
  char sig[2];
	sig[0] = DBUS_TYPE_STRING;
	sig[1] = '\0';
  dbus_message_iter_open_container(&iter, DBUS_TYPE_ARRAY, sig, &array_iter);
  dbus_message_iter_close_container(&iter, &array_iter);

  char sig2[5];
  sig2[0] = DBUS_DICT_ENTRY_BEGIN_CHAR;
	sig2[1] = DBUS_TYPE_STRING;
	sig2[2] = DBUS_TYPE_VARIANT;
	sig2[3] = DBUS_DICT_ENTRY_END_CHAR;
	sig2[4] = '\0';

  /* Dictionary */
  DBusMessageIter array_iter2;
  DBusMessageIter dict_iter;
  DBusMessageIter variant_iter;
  char sig_variant[2];
  sig_variant[0] = DBUS_TYPE_BYTE;
  sig_variant[1] = '\0';
  const char * hint = "urgency";
  unsigned char level = 0x01;
  dbus_message_iter_open_container(&iter, DBUS_TYPE_ARRAY, sig2, &array_iter2);
  {
    dbus_message_iter_open_container(&array_iter2, DBUS_TYPE_DICT_ENTRY, NULL, &dict_iter);
    {
      dbus_message_iter_append_basic(&dict_iter, DBUS_TYPE_STRING, &hint);
      dbus_message_iter_open_container(&dict_iter, DBUS_TYPE_VARIANT, sig_variant, &variant_iter);
      {
        dbus_message_iter_append_basic(&variant_iter, DBUS_TYPE_BYTE, &level);
      }
      dbus_message_iter_close_container(&dict_iter, &variant_iter);
    }
    dbus_message_iter_close_container(&array_iter2, &dict_iter);
  }
  dbus_message_iter_close_container(&iter, &array_iter2);

  dbus_message_iter_append_basic(&iter, DBUS_TYPE_INT32, &expiration_timeout);

  /* Send to dbus */
  dbus_connection_send(connection, message, NULL);
  dbus_connection_flush(connection);

  dbus_message_unref(message);
  dbus_connection_unref(connection);
  return 0;
}
