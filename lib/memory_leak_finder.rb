require 'objspace'

module MemoryLeakFinder
  def self.trace
    raise "Block required" unless block_given?

    gc_params = {full_mark: true, immediate_sweep: true}.freeze

    ObjectSpace.trace_object_allocations_clear
    ObjectSpace.trace_object_allocations do
      yield
    end

    GC.start(gc_params)

    leaks = false
    ObjectSpace.each_object do |o|
      next unless ObjectSpace.allocation_sourcefile(o)
      leaks = true
      puts "LEAK! #{o.class} #{o.inspect} allocated at #{ObjectSpace.allocation_sourcefile(o)}:#{ObjectSpace.allocation_sourceline(o)}: approx. #{ObjectSpace.memsize_of(o)} bytes"
    end
    leaks
  end
end
