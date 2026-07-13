local function get_cpu_stats()
	local file = io.open("/proc/stat", "r")

	if not file then
		return "--"
	end

	local line = file:read("*l")
	file:close()

	local user, nice, system, idle, iowait, irq, softirq =
		line:match("cpu%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")

	return {
		user = tonumber(user),
		nice = tonumber(nice),
		system = tonumber(system),
		idle = tonumber(idle),
		iowait = tonumber(iowait),
		irq = tonumber(irq),
		softirq = tonumber(softirq),
	}
end

local function get_ram_usage()
	local total, available

	for line in io.lines("/proc/meminfo") do
		if line:match("^MemTotal:") then
			total = tonumber(line:match("%d+"))
		elseif line:match("^MemAvailable:") then
			available = tonumber(line:match("%d+"))
		end

		if total and available then
			break
		end
	end

	if total and available then
		local total_gb = total / 1000 / 1000 -- aproximated KB to GB conversion
		local used_gb = (total - available) / 1024 / 1024 -- precise KB to GB conversion

		return string.format("%.1fGi/%.0fGi", used_gb, total_gb)
	end

	return "--/--"
end

local function get_disk_usage()
	local handle = io.popen("df /")

	if handle then
		local line = handle:read("*l") -- useless header line
		line = handle:read("*l") or "--"
		handle:close()

		local percent = line:match("(%d+)%%") or "--"

		return percent .. "%"
	end
end

local function get_nvidia_gpu_usage()
	local handle = io.popen("nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null", "r")
	local data = "--"

	if handle then
		data = handle:read("*l") or "--"
		handle:close()
	end

	return data
end

local prev_total, prev_idle = 0, 0
local last_output = ""

while true do
	local cpu_usage = "--"
	local cpu_status = get_cpu_stats()
	local ram_usage = get_ram_usage()
	local disk_usage = get_disk_usage()
	local gpu_usage = get_nvidia_gpu_usage()

	if cpu_status then
		local total = cpu_status.iowait
			+ cpu_status.irq
			+ cpu_status.nice
			+ cpu_status.softirq
			+ cpu_status.system
			+ cpu_status.user
			+ cpu_status.idle

		local diff_total = total - prev_total
		local diff_idle = cpu_status.idle - prev_idle

		if diff_total > 0 then
			cpu_usage = string.format("%.0f", ((diff_total - diff_idle) * 100) / diff_total)
		end

		prev_total = total
		prev_idle = cpu_status.idle
	end

	local tooltip = string.format(
		" <b>CPU:</b> %s%% \\n <b>RAM:</b> %s \\n <b>GPU:</b> %s%% \\n <b>Disk:</b> %s ",
		cpu_usage,
		ram_usage,
		gpu_usage,
		disk_usage
	)

	local current_output = string.format('{"text": "", "tooltip": "%s", "class": "default"}', tooltip)

	if current_output ~= last_output then
		print(current_output)
		io.stdout:flush()

		last_output = current_output
	end

	os.execute("sleep 0.5")
end
