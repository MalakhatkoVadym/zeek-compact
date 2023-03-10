#
# @TEST-EXEC: zeek -b %INPUT
# @TEST-EXEC: cat ssh.log | grep -E -v '#open|#close' >ssh.log.tmp && mv ssh.log.tmp ssh.log
# @TEST-EXEC: btest-diff ssh.log

redef LogAscii::separator = "||";

module SSH;

export {
	redef enum Log::ID += { LOG };

	type Log: record {
		t: time;
		id: conn_id; # Will be rolled out into individual columns.
		status: string &optional;
		country: string &default="unknown";
	} &log;
}

event zeek_init()
{
	Log::create_stream(SSH::LOG, [$columns=Log]);

    local cid = [$orig_h=1.2.3.4, $orig_p=1234/tcp, $resp_h=2.3.4.5, $resp_p=80/tcp];

	Log::write(SSH::LOG, [$t=network_time(), $id=cid, $status="success"]);
	Log::write(SSH::LOG, [$t=network_time(), $id=cid, $status="failure", $country="US"]);
	Log::write(SSH::LOG, [$t=network_time(), $id=cid, $status="fa||ure", $country="UK"]);
	Log::write(SSH::LOG, [$t=network_time(), $id=cid, $status="su||ess", $country="BR"]);
	Log::write(SSH::LOG, [$t=network_time(), $id=cid, $status="failure", $country="MX"]);
}
