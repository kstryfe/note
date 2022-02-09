# Put this in /usr/share/zeek/site/scripts
# And add a @load statement to the /usr/share/zeek/site/local.zeek script

@load /usr/share/zeek/policy/frameworks/files/extract-all-files.zeek
redef FileExtract::prefix = "/data/zeek/extract_files/";
redef FileExtract::default_limit = 1048576000;
