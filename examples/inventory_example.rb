require_relative './example_helper'

def print_object(object, caption, indent = 0, recurse = true)
  indentation = "\t" * indent
  puts "#{indentation}================= #{caption} ======================"
  object.keys.sort { |a,b| a.to_s <=> b.to_s }.each do |key|
    puts "#{indentation}#{key.to_s}:\t#{object[key].inspect}"
  end
  puts "#{indentation}relationships:\t#{object.relationships.inspect}"
  puts "#{indentation}operations:\t#{object.operations.inspect}"

  if recurse
    object.relationships.keys.sort { |a,b| a.to_s <=> b.to_s}.each do |rel|
      object.send(rel).each { |obj| print_object(obj, rel.to_s.singularize.upcase, indent+1) }
    end
  end
end

def collect(rhevm, method, caption = nil)
  caption ||= method.to_s
  puts ">>> Collecting #{caption.upcase} <<<"
  rhevm.send(method).each { |obj| print_object(obj, caption.singularize.upcase) }
  puts ">>> Collecting #{caption.upcase} COMPLETE <<<"
  puts "----------------------------------------------"
end

rhevm = ExampleHelper.service
collect(rhevm, :datacenters)
collect(rhevm, :clusters)
collect(rhevm, :hosts)
collect(rhevm, :vmpools)
collect(rhevm, :vms)
collect(rhevm, :templates)
collect(rhevm, :networks)
collect(rhevm, :events)
collect(rhevm, :roles)
