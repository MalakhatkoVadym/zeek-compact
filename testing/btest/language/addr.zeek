# @TEST-EXEC: zeek -b %INPUT >out
# @TEST-EXEC: btest-diff out
# @TEST-EXEC: btest-diff .stderr

function test_case(msg: string, expect: bool)
        {
        print fmt("%s (%s)", msg, expect ? "PASS" : "FAIL");
        }

# IPv4 addresses
global a1: addr = 0.0.0.0;
global a2: addr = 10.0.0.11;
global a3: addr = 255.255.255.255;
global a4 = 192.1.2.3;

# IPv6 addresses
global b1: addr = [::];
global b2: addr = [::255.255.255.255];
global b3: addr = [::ffff:ffff];
global b4: addr = [ffff::ffff];
global b5: addr = [0000:0000:0000:0000:0000:0000:0000:0000];
global b6: addr = [aaaa:bbbb:cccc:dddd:eeee:ffff:1111:2222];
global b7: addr = [AAAA:BBBB:CCCC:DDDD:EEEE:FFFF:1111:2222];
global b9 = [2001:db8:0:0:0:FFFF:192.168.0.5];

# IPv4-mapped-IPv6 (internally treated as IPv4)
global c1: addr = [::ffff:1.2.3.4];

event zeek_init()
{
	test_case( "IPv4 address inequality", a1 != a2 );
	test_case( "IPv4 address equality", a1 == 0.0.0.0 );
	test_case( "IPv4 address comparison", a1 < a2 );
	test_case( "IPv4 address comparison", a3 > a2 );
	test_case( "size of IPv4 address", |a1| == 32 );
	test_case( "IPv4 address type inference", type_name(a4) == "addr" );

	local b8 = [a::b];

	test_case( "IPv6 address inequality", b1 != b2 );
	test_case( "IPv6 address equality", b1 == b5 );
	test_case( "IPv6 address equality", b2 == b3 );
	test_case( "IPv6 address comparison", b1 < b2 );
	test_case( "IPv6 address comparison", b4 > b2 );
	test_case( "IPv6 address not case-sensitive", b6 == b7 );
	test_case( "size of IPv6 address", |b1| == 128 );
	test_case( "IPv6 address type inference", type_name(b8) == "addr" );

	test_case( "IPv4 and IPv6 address inequality", a1 != b1 );

	test_case( "IPv4-mapped-IPv6 equality to IPv4", c1 == 1.2.3.4 );
	test_case( "IPv4-mapped-IPv6 is IPv4", is_v4_addr(c1) == T );
}

