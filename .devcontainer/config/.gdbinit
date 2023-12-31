directory /workspace/os161/src/kern/compile/DUMBVM
directory /workspace/os161/src/kern/compile/SYNCHPROBS

define db 
target remote unix:.sockets/gdb 
end

# gdb scripts for dumping resizeable arrays.
#
# Unfortunately, there does not seem to be a way to do this without
# cutting and pasting for every type.

define plainarray
    set $n = $arg0.num
    set $i = 0
    printf "%u items\n", $n
    while ($i < $n)
	print $arg0.v[$i]
	set $i++
    end
end
document plainarray
Print a plain (untyped) resizeable array.
Usage: plainarray myarray
end

define array
    set $n = $arg0.arr.num
    set $i = 0
    printf "%u items\n", $n
    while ($i < $n)
	print $arg0.arr.v[$i]
	set $i++
    end
end
document array
Print the pointers in a typed resizeable array.
(Use plainarray for an untyped resizeable array.)
Usage: array allcpus
end

define cpuarray
    set $n = $arg0.arr.num
    set $i = 0
    printf "%u cpus\n", $n
    while ($i < $n)
	printf "cpu %u:\n", $i
	print *(struct cpu *)($arg0.arr.v[$i])
	set $i++
    end
end
document cpuarray
Print an array of struct cpu.
Usage: cpuarray allcpus
end

define threadarray
    set $n = $arg0.arr.num
    set $i = 0
    printf "%u threads\n", $n
    while ($i < $n)
	printf "thread %u:\n", $i
	print *(struct thread *)($arg0.arr.v[$i])
	set $i++
    end
end
document threadarray
Print an array of struct thread.
Usage: threadarray curproc->p_threads
end

define vnodearray
    set $n = $arg0.arr.num
    set $i = 0
    printf "%u vnodes\n", $n
    while ($i < $n)
	printf "vnode %u:\n", $i
	print *(struct vnode *)($arg0.arr.v[$i])
	set $i++
    end
end
document vnodearray
Print an array of struct vnode.
Usage: vnodearray sfs->sfs_vnodes
end

