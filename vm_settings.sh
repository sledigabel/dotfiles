# from https://stackoverflow.com/questions/57674233/how-to-modify-the-behaviour-of-filesystem-cache-in-mac-os
sysctl kern.vm_page_free_target=163840
sysctl kern.vm_page_free_min=147456
sysctl kern.vm_page_free_reserved=16384
sysctl kern.vm_page_speculative_percentage=1
sysctl vm.vm_page_background_exclude_external=0
sysctl vm.vm_page_background_mode=1
sysctl vm.vm_page_background_target=163840
sysctl vm.compressor_timing_enabled=1
