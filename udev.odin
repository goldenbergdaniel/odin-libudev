#+build linux
package udev

foreign import lib "system:udev"

UDev       :: distinct rawptr
List_Entry :: distinct rawptr
Device     :: distinct rawptr
Monitor    :: distinct rawptr
Enumerate  :: distinct rawptr
Queue      :: distinct rawptr
HWDB       :: distinct rawptr

@(default_calling_convention="c", link_prefix="udev_")
foreign lib
{
  new :: proc() -> UDev ---
  ref :: proc(udev: UDev) -> UDev ---
  unref :: proc(udev: UDev) -> UDev ---

  list_entry_get_next :: proc(list_entry: List_Entry) -> List_Entry ---
  list_entry_get_by_name :: proc(list_entry: List_Entry, name: cstring) -> List_Entry ---
  list_entry_get_name :: proc(list_entry: List_Entry) -> cstring ---
  list_entry_get_value :: proc(list_entry: List_Entry) -> cstring --- 

  device_ref :: proc(device: Device) -> Device ---
  device_unref :: proc(device: Device) -> Device ---
  device_get_udev :: proc(device: Device) -> UDev ---
  device_new_from_syspath :: proc(udev: UDev, syspath: cstring) -> Device ---
  device_new_from_devnum :: proc(udev: UDev, type: byte, devnum: u64) -> Device ---
  device_new_from_device_id :: proc(udev: UDev, id: cstring) -> Device ---
  device_new_from_environment :: proc(udev: UDev) -> Device ---
  device_get_parent :: proc(device: Device) -> Device ---
  device_get_devpath :: proc(device: Device) -> cstring ---
  device_get_subsystem :: proc(dev: Device) -> cstring ---
  device_get_devtype :: proc(dev: Device) -> cstring ---
  device_get_syspath :: proc(dev: Device) -> cstring ---
  device_get_sysname :: proc(dev: Device) -> cstring ---
  device_get_sysnum :: proc(dev: Device) -> cstring ---
  device_get_devnode :: proc(dev: Device) -> cstring ---
  device_get_is_initialized :: proc(device: Device) -> b32 ---
  device_get_devlinks_list_entry :: proc(device: Device) -> List_Entry ---
  device_get_properties_list_entry :: proc(device: Device) -> List_Entry ---
  device_get_tags_list_entry :: proc(device: Device) -> List_Entry ---
  device_get_current_tags_list_entry :: proc(device: Device) -> List_Entry ---
  device_get_sysattr_list_entry :: proc(device: Device) -> List_Entry ---
  device_get_property_value :: proc(device: Device, key: cstring) -> cstring ---
  device_get_driver :: proc(device: Device) -> cstring ---
  device_get_devnum :: proc(device: Device) -> u64 ---
  device_get_action :: proc(device: Device) -> cstring ---
  device_get_seqnum :: proc(device: Device) -> u64 ---
  device_get_usec_since_initialized :: proc(device: Device) -> u64 ---
  device_get_sysattr_value :: proc(device: Device, sysattr: cstring) -> cstring ---
  device_set_sysattr_value :: proc(device: Device, sysattr, value: cstring) -> b32 ---
  device_has_tag :: proc(device: Device, tag: cstring) -> b32 ---
  device_has_current_tag :: proc(device: Device, tag: cstring) -> b32 ---

  monitor_ref :: proc(monitor: Monitor) -> Monitor ---
  monitor_unref :: proc(monitor: Monitor) -> Monitor ---
  monitor_get_udev :: proc(monitor: Monitor) -> UDev ---
  /* kernel and udev generated events over netlink */
  monitor_new_from_netlink :: proc(udev: UDev, name: cstring) -> Monitor ---
  /* bind socket */
  monitor_enable_receiving :: proc(monitor: Monitor) -> i32 ---
  monitor_set_receive_buffer_size :: proc(monitor: Monitor, size: i32) -> i32 ---
  monitor_get_fd :: proc(monitor: Monitor) -> i32 ---
  monitor_receive_device :: proc(monitor: Monitor) -> Device ---
  /* in-kernel socket filters to select messages that get delivered to a listener */
  monitor_filter_add_match_subsystem_devtype :: proc(monitor: Monitor, subsystem, devtype: cstring) -> i32 ---
  monitor_filter_add_match_tag :: proc(monitor: Monitor, tag: cstring) -> i32 ---
  monitor_filter_update :: proc(monitor: Monitor) -> i32 ---
  monitor_filter_remove :: proc(monitor: Monitor) -> i32 ---

  enumerate_new :: proc(udev: UDev) -> Enumerate ---
  enumerate_ref :: proc(enumerate: Enumerate) -> Enumerate ---
  enumerate_unref :: proc(enumerate: Enumerate) -> Enumerate ---
  enumerate_get_udev :: proc(enumerate: Enumerate) -> UDev ---
  /* device properties filter */
  enumerate_add_match_subsystem :: proc(enumerate: Enumerate, subsystem: cstring) -> i32 ---
  enumerate_add_nomatch_subsystem :: proc(enumerate: Enumerate, subsystem: cstring) -> i32 ---
  enumerate_add_match_sysattr :: proc(enumerate: Enumerate, sysattr, value: cstring) -> i32 ---
  enumerate_add_nomatch_sysattr :: proc(enumerate: Enumerate, sysattr, value: cstring) -> i32 ---
  enumerate_add_match_property :: proc(enumerate: Enumerate, property, value: cstring) -> i32 ---
  enumerate_add_match_sysname :: proc(enumerate: Enumerate, sysname: cstring) -> i32 ---
  enumerate_add_match_tag :: proc(enumerate: Enumerate, tag: cstring) -> i32 ---
  enumerate_add_match_parent :: proc(enumerate: Enumerate, parent: Device) -> i32 ---
  enumerate_add_match_is_initialized :: proc(enumerate: Enumerate) -> i32 ---
  enumerate_add_syspath :: proc(enumerate: Enumerate, syspath: cstring) -> i32 ---
  /* run enumeration with active filters */
  enumerate_scan_devices :: proc(enumerate: Enumerate) -> i32 ---
  enumerate_scan_subsystems :: proc(enumerate: Enumerate) -> i32 ---
  /* return device list */
  enumerate_get_list_entry :: proc(enumerate: Enumerate) -> List_Entry ---

  queue_new :: proc(udev: UDev) -> Queue ---
  queue_ref :: proc(queue: Queue) -> Queue ---
  queue_unref :: proc(queue: Queue) -> Queue ---
  queue_get_udev :: proc(queue: Queue) -> UDev ---
  queue_get_udev_is_active :: proc(queue: Queue) -> b32 ---
  queue_get_queue_is_empty :: proc(queue: Queue) -> b32 ---
  queue_get_seqnum_sequence_is_finished :: proc(queue: Queue) -> b32 ---
  queue_get_fd :: proc(queue: Queue) -> i32 ---
  queue_flush :: proc(queue: Queue) -> i32 ---

  hwdb_new :: proc(udev: UDev) -> HWDB ---
  hwdb_ref :: proc(hwdb: HWDB) -> HWDB ---
  hwdb_unref :: proc(hwdb: HWDB) -> HWDB ---
  hwdb_get_properties_list_entry :: proc(hwdb: HWDB, modalias: cstring, flags: u32) -> List_Entry ---

  util_encode_string :: proc(str: cstring, str_enc: [^]byte, len: uint) -> i32 ---
}

/*
 Helper to iterate over all entries of a list.
 
 * @list_entry:  entry to store the current position
 * @first_entry: first entry to start with
*/
list_entry_foreach :: proc(list_entry, first_entry: List_Entry) -> List_Entry
{
  result: List_Entry
  
  for next_entry := first_entry; next_entry != nil; next_entry = list_entry_get_next(list_entry)
  {
    result = next_entry
  }

  return result
}
