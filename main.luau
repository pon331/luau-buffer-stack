--!strict
--!native
--!optimize 2

@native const function ensure_capacity(self: BufferStackInstance, additional: number)
	const buf = self._buf
	const required = self._pos + additional
	const current = buffer.len(buf)

	if required <= current then
		return
	end
	
	const new_capacity = current + additional
	const new_buf = buffer.create(new_capacity)
	buffer.copy(new_buf, 0, buf)
	self._buf = new_buf
	self._len = new_capacity
end

const __class = {} do
	@native function __class.push_u8(self: BufferStackInstance, value: number)
		ensure_capacity(self, 1)
		buffer.writeu8(self._buf, self._pos, value)
		self._pos += 1
	end

	@native function __class.push_i8(self: BufferStackInstance, value: number)
		ensure_capacity(self, 1)
		buffer.writei8(self._buf, self._pos, value)
		self._pos += 1
	end

	@native function __class.push_u16(self: BufferStackInstance, value: number)
		ensure_capacity(self, 2)
		buffer.writeu16(self._buf, self._pos, value)
		self._pos += 2
	end

	@native function __class.push_i16(self: BufferStackInstance, value: number)
		ensure_capacity(self, 2)
		buffer.writei16(self._buf, self._pos, value)
		self._pos += 2
	end

	@native function __class.push_u32(self: BufferStackInstance, value: number)
		ensure_capacity(self, 4)
		buffer.writeu32(self._buf, self._pos, value)
		self._pos += 4
	end

	@native function __class.push_i32(self: BufferStackInstance, value: number)
		ensure_capacity(self, 4)
		buffer.writei32(self._buf, self._pos, value)
		self._pos += 4
	end

	@native function __class.push_f32(self: BufferStackInstance, value: number)
		ensure_capacity(self, 4)
		buffer.writef32(self._buf, self._pos, value)
		self._pos += 4
	end

	@native function __class.push_f64(self: BufferStackInstance, value: number)
		ensure_capacity(self, 8)
		buffer.writef64(self._buf, self._pos, value)
		self._pos += 8
	end

	@native function __class.push_string(self: BufferStackInstance, value: string)
		const len = #value
		ensure_capacity(self, len)
		buffer.writestring(self._buf, self._pos, value, len)
		self._pos += len
	end

	@native function __class.pop_u8(self: BufferStackInstance): number
		self._pos -= 1
		const value = buffer.readu8(self._buf, self._pos)
		buffer.writeu8(self._buf, self._pos, 0)
		return value
	end

	@native function __class.pop_i8(self: BufferStackInstance): number
		self._pos -= 1
		const value = buffer.readi8(self._buf, self._pos)
		buffer.writei8(self._buf, self._pos, 0)
		return value
	end

	@native function __class.pop_u16(self: BufferStackInstance): number
		self._pos -= 2
		const value = buffer.readu16(self._buf, self._pos)
		buffer.writeu16(self._buf, self._pos, 0)
		return value
	end

	@native function __class.pop_i16(self: BufferStackInstance): number
		self._pos -= 2
		const value = buffer.readi16(self._buf, self._pos)
		buffer.writei16(self._buf, self._pos, 0)
		return value
	end

	@native function __class.pop_u32(self: BufferStackInstance): number
		self._pos -= 4
		const value = buffer.readu32(self._buf, self._pos)
		buffer.writeu32(self._buf, self._pos, 0)
		return value
	end

	@native function __class.pop_i32(self: BufferStackInstance): number
		self._pos -= 4
		const value = buffer.readi32(self._buf, self._pos)
		buffer.writei32(self._buf, self._pos, 0)
		return value
	end

	@native function __class.pop_f32(self: BufferStackInstance): number
		self._pos -= 4
		const value = buffer.readf32(self._buf, self._pos)
		buffer.fill(self._buf, self._pos, 0, 4)
		return value
	end

	@native function __class.pop_f64(self: BufferStackInstance): number
		self._pos -= 8
		const value = buffer.readf64(self._buf, self._pos)
		buffer.fill(self._buf, self._pos, 0, 8)
		return value
	end
	
	@native function __class.pop_string(self: BufferStackInstance, len: number): string
		self._pos -= len
		const value = buffer.readstring(self._buf, self._pos, len)
		buffer.fill(self._buf, self._pos, 0, len)
		return value
	end

	@native function __class.size(self: BufferStackInstance): number
		return self._pos
	end

	@native function __class.capacity(self: BufferStackInstance): number
		return self._len
	end

	@native function __class.is_empty(self: BufferStackInstance): boolean
		return self._pos == 0
	end

	@native function __class.clear(self: BufferStackInstance)
		buffer.fill(self._buf, 0, 0, self._len)
		self._pos = 0
	end

	@native function __class.reserve(self: BufferStackInstance, additional: number)
		ensure_capacity(self, additional)
	end

	@native function __class.to_buffer(self: BufferStackInstance): buffer
		const current_buf = buffer.create(self._len)
		buffer.copy(current_buf, 0, self._buf)
		return current_buf
	end

	table.freeze(__class)
end

const __meta = table.freeze({ __index = __class })
export type BufferStackInstance = setmetatable<{
	_buf: buffer,
	_pos: number,
	_len: number,
}, typeof(__meta)>

const BufferStack = {}

function BufferStack.new(): BufferStackInstance
	return setmetatable({
		_buf = buffer.create(0),
		_pos = 0,
		_len = 0
	}, __meta)
end

function BufferStack.with_capacity(capacity: number): BufferStackInstance
	capacity = math.max(capacity, 0)
	return setmetatable({
		_buf = buffer.create(capacity),
		_pos = 0,
		_len = capacity
	}, __meta)
end

function BufferStack.from_buffer(buf: buffer, pos: number?): BufferStackInstance
	const len = buffer.len(buf)
	return setmetatable({
		_buf = buf,
		_pos = pos or len,
		_len = len
	}, __meta)
end

return table.freeze(BufferStack)
