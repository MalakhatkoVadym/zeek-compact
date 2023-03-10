# Use -D so that the induced FPs checked for below are consistent.
# @TEST-EXEC: zeek -D -b %INPUT >output 2>err
# @TEST-EXEC: btest-diff output
# @TEST-EXEC: btest-diff err

function test_basic_bloom_filter()
  {
  # Basic usage with counts.
  print "basic";
  local bf_cnt = bloomfilter_basic_init(0.1, 1000);
  bloomfilter_add(bf_cnt, 42);
  bloomfilter_add(bf_cnt, 84);
  bloomfilter_add(bf_cnt, 168);
  print bloomfilter_lookup(bf_cnt, 0);
  print bloomfilter_lookup(bf_cnt, 42);
  print bloomfilter_lookup(bf_cnt, 168);
  print bloomfilter_lookup(bf_cnt, 336);
  bloomfilter_add(bf_cnt, 0.5); # Type mismatch
  bloomfilter_add(bf_cnt, "foo"); # Type mismatch

  # Alternative constructor.
  print "alternative constructor";
  local bf_dbl = bloomfilter_basic_init2(4, 10);
  bloomfilter_add(bf_dbl, 4.2);
  bloomfilter_add(bf_dbl, 3.14);
  print bloomfilter_lookup(bf_dbl, 4.2);
  print bloomfilter_lookup(bf_dbl, 3.14);

  # Basic usage with strings.
  print "basicstrings";
  local bf_str = bloomfilter_basic_init(0.9, 10);
  bloomfilter_add(bf_str, "foo");
  bloomfilter_add(bf_str, "bar");
  print bloomfilter_lookup(bf_str, "foo");
  print bloomfilter_lookup(bf_str, "bar");
  # print bloomfilter_lookup(bf_str, "bazzz"), "fp"; # FP false positive does no longer trigger after hash function change
  print bloomfilter_lookup(bf_str, "quuux"), "fp"; # FP
  bloomfilter_add(bf_str, 0.5); # Type mismatch
  bloomfilter_add(bf_str, 100); # Type mismatch

  # Edge cases.
  print "edgecases";
  local bf_edge0 = bloomfilter_basic_init(0.000000000001, 1);
  local bf_edge1 = bloomfilter_basic_init(0.00000001, 100000000);
  local bf_edge2 = bloomfilter_basic_init(0.9999999, 1);
  local bf_edge3 = bloomfilter_basic_init(0.9999999, 100000000000);

  # Merging
  print "merging";
  local bf_cnt2 = bloomfilter_basic_init(0.1, 1000);
  bloomfilter_add(bf_cnt2, 42);
  bloomfilter_add(bf_cnt, 100);
  local bf_merged = bloomfilter_merge(bf_cnt, bf_cnt2);
  print bloomfilter_lookup(bf_merged, 42);
  print bloomfilter_lookup(bf_merged, 84);
  print bloomfilter_lookup(bf_merged, 100);
  print bloomfilter_lookup(bf_merged, 168);

  #Intersection
  print "intersect";
  local bf_intersected = bloomfilter_intersect(bf_cnt, bf_cnt2);
  print bloomfilter_lookup(bf_intersected, 42);
  print bloomfilter_lookup(bf_intersected, 84);
  print bloomfilter_lookup(bf_intersected, 100);
  print bloomfilter_lookup(bf_intersected, 168);

  #empty filter tests
  print "empty filter";
  local bf_empty = bloomfilter_basic_init(0.1, 1000);
  print bloomfilter_lookup(bf_empty, 42);
  local bf_empty_merged = bloomfilter_merge(bf_merged, bf_empty);
  print bloomfilter_lookup(bf_empty_merged, 42);
  }

# We split off the following into their own tests because ZAM error handling
# needs to terminate the current function's execution when these generate
# run-time errors.
function test_bad_param1()
  {
  local bf_bug0 = bloomfilter_basic_init(-0.5, 42);
  }

function test_bad_param2()
  {
  local bf_bug1 = bloomfilter_basic_init(1.1, 42);
  }

function test_counting_bloom_filter()
  {
  print "counting";
  local bf = bloomfilter_counting_init(3, 32, 3);
  bloomfilter_add(bf, "foo");
  print bloomfilter_lookup(bf, "foo");    # 1
  bloomfilter_add(bf, "foo");
  print bloomfilter_lookup(bf, "foo");    # 2
  bloomfilter_add(bf, "foo");
  print bloomfilter_lookup(bf, "foo");    # 3
  bloomfilter_add(bf, "foo");
  print bloomfilter_lookup(bf, "foo");    # still 3


  bloomfilter_add(bf, "bar");
  bloomfilter_add(bf, "bar");
  print bloomfilter_lookup(bf, "bar");    # 2
  print bloomfilter_lookup(bf, "foo");    # still 3

  # Merging
  print "counting merge";
  local bf2 = bloomfilter_counting_init(3, 32, 3);
  bloomfilter_add(bf2, "baz");
  bloomfilter_add(bf2, "baz");
  bloomfilter_add(bf2, "bar");
  local bf_merged = bloomfilter_merge(bf, bf2);
  print bloomfilter_lookup(bf_merged, "foo");
  print bloomfilter_lookup(bf_merged, "bar");
  print bloomfilter_lookup(bf_merged, "baz");

  # Intersect
  print "counting intersect";
  bloomfilter_add(bf2, "foo");
  bloomfilter_add(bf2, "foo");
  local bf_intersected = bloomfilter_intersect(bf, bf2);
  print bloomfilter_lookup(bf_intersected, "foo");
  print bloomfilter_lookup(bf_intersected, "bar");
  print bloomfilter_lookup(bf_intersected, "baz");

  # Decrement
  print "counting decrement";
  bloomfilter_decrement(bf, "foo");
  print bloomfilter_lookup(bf, "foo"); # 2
  bloomfilter_decrement(bf, "foo");
  print bloomfilter_lookup(bf, "foo"); # 1
  print bloomfilter_decrement(bf, "foo"); # True
  print bloomfilter_lookup(bf, "foo"); # 0
  print bloomfilter_lookup(bf, "bar"); # still 2
  print bloomfilter_decrement(bf, "foo"); # False
  }

event zeek_init()
  {
  test_basic_bloom_filter();
  test_counting_bloom_filter();
  test_bad_param1();
  test_bad_param2();
  }
