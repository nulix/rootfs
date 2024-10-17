software =
{
	version = "0.1.0";

	rpi = {
		hardware-compatibility: [ "1.0"];
		files: (
			{
				filename = "ota-update-os.swu";
				path = "/data/ota-update-os.swu";
				sha256 = "@@OTA_SHA256@@";
			}
		);
		scripts: (
			{
				filename = "trigger.sh";
				type = "shellscript";
				sha256 = "@@SCRIPT_SHA256@@";
			}
		);
	};
}
