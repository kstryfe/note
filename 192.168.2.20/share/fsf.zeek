# Put this in /usr/share/zeek/site/scripts
# And add a @load statement to the /usr/share/zeek/site/local.zeek script

event file_state_remove(f: fa_file)
    {
	if ( f$info?$extracted )
	{
	       # invoke the FSF-CLIENT and add the source metadata of ROCK01 (sensorID), we're suppressing the returned report
	       # becuase we don't need that
	       local file_path = "/data/zeek/extract_files/";
	       local script_path = "/opt/fsf/fsf-client/fsf_client.py";
	       local scan_cmd = fmt("python %s --suppress-report --archive none  %s%s", script_path, file_path, f$info$extracted);
	       system(scan_cmd);
	 }
}
