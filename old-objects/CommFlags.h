#pragma once

enum class CommFlags {
  OK = 200,
  INSTR = 104,
  TOOL = 400,
  RST = 401,
  UPDATE = 500,
  LOG = 600,
  EXFIL = 601,
  CRYPT = 700,
  SIGN = 701,
  UNKNOWN = 404
};