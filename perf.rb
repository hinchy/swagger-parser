require "benchmark"
require_relative "../swagger"

Benchmark.bm do |x|
  x.report("Remove attachable") do
  end
end
