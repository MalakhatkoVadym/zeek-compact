#pragma once

#include "zeek/packet_analysis/Analyzer.h"
#include "zeek/packet_analysis/Component.h"

namespace zeek::packet_analysis::PacketDemo
	{

class LLCDemo : public Analyzer
	{
public:
	LLCDemo();
	~LLCDemo() override = default;

	bool AnalyzePacket(size_t len, const uint8_t* data, Packet* packet) override;

	static AnalyzerPtr Instantiate() { return std::make_shared<LLCDemo>(); }
	};

	}
