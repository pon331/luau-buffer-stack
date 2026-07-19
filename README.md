# BufferStack
Simple and fast stack-based buffer module with automatic memory allocation

# API

### `BufferStack.new() -> BufferStackInstance`
Creates a new BufferStack instance with 0 allocated bytes

### `BufferStack.with_capacity(capacity: number) -> BufferStackInstance`
Creates a new BufferStack instance pre-allocated with `capacity` bytes

### `BufferStack.from_buffer(buf: buffer, pos: number?) -> BufferStackInstance`
Creates a new BufferStack instance with from existing buffer

----

### Pushing methods

### `BufferStackInstance:push_u8(value: number)`
Pushes an unsigned 8-bit integer

### `BufferStackInstance:push_i8(value: number)`
Pushes a signed 8-bit integer

### `BufferStackInstance:push_u16(value: number)`
Pushes an unsigned 16-bit integer

### `BufferStackInstance:push_i16(value: number)`
Pushes a signed 16-bit integer

### `BufferStackInstance:push_u32(value: number)`
Pushes an unsigned 32-bit integer

### `BufferStackInstance:push_i32(value: number)`
Pushes a signed 32-bit integer

### `BufferStackInstance:push_f32(value: number)`
Pushes a single-precision float

### `BufferStackInstance:push_f64(value: number)`
Pushes a double-precision float

### `BufferStackInstance:push_string(value: number)`
Pushes a string (length bytes not included)

----

### Popping methods

### `BufferStackInstance:pop_u8() -> number`
Pops and returns an unsigned 8-bit integer

### `BufferStackInstance:pop_i8() -> number`
Pops and returns a signed 8-bit integer

### `BufferStackInstance:pop_u16() -> number`
Pops and returns an unsigned 16-bit integer

### `BufferStackInstance:pop_i16() -> number`
Pops and returns a signed 16-bit integer

### `BufferStackInstance:pop_u32() -> number`
Pops and returns an unsigned 32-bit integer

### `BufferStackInstance:pop_i32() -> number`
Pops and returns a signed 32-bit integer

### `BufferStackInstance:pop_f32() -> number`
Pops and returns a single-precision float

### `BufferStackInstance:pop_f64() -> number`
Pops and returns a double-precision float

### `BufferStackInstance:pop_string(len: number) -> number`
Pops and returns a string with length of `len` bytes

----

### Other methods

### `BufferStackInstance:size() -> number`
Returns the number of bytes currently occupied in the stack

### `BufferStackInstance:capacity() -> number`
Returns the total amount of allocated space in the stack (in bytes)

### `BufferStackInstance:is_empty() -> boolean`
Returns `true` if no data has been pushed (or everything has been popped)

### `BufferStackInstance:clear()`
Initializes the stack with zeroes

### `BufferStackInstance:reserve(additional: number)`
Allocates `additional` bytes

### `BufferStackInstance:to_buffer() -> buffer`
Returns a complete copy of the current stack buffer 

----

# Usage examples

### Serializing a simple packet
```luau
-- Serverside:
const BufferStack = require(path.to.bufferstack)

-- Replicate some effect to all clients
const Stack = BufferStack.with_capacity(13)
Stack:push_u8(1) -- effect id
Stack:push_f32(2) -- pos Z
Stack:push_f32(7) -- pos Y
Stack:push_f32(4) -- pos X
-- Pushing position in reverse order for easy reading

SomeRemoteEvent:FireAllClient(Stack:to_buffer)


-- Clientside:
const BufferStack = require(path.to.bufferstack)

SomeRemoteEvent.OnClientEvent:Connect(function(buf: buffer)
    const Stack = BufferStack.from_buffer(buf)
    const Position = Vector3.new(Stack:pop_f32(), Stack:pop_f32(), Stack:pop_f32())

    handle_effect_logic(Stack:pop_u8(), Position)
end)

```
