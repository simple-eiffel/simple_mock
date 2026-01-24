# S05: CONSTRAINTS - simple_mock

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## Technical Constraints

### Platform
- **OS**: Cross-platform
- **Compiler**: EiffelStudio 25.02+
- **Concurrency**: SCOOP compatible design

### Dependencies
- simple_mml for model types
- Base library collections

### Network
- Currently no actual HTTP server
- Designed for simple_http integration
- Future: Socket-based server

## Design Constraints

### Single Port Per Instance
- Each SIMPLE_MOCK has one port
- Use pool for multiple ports
- Port must be available

### Sequential Matching
- Expectations matched in order
- First match wins
- Multiple matches possible

### In-Memory State
- All state in memory
- No persistence
- Reset clears everything

## API Constraints

### Port Range
```eiffel
require
  port_positive: a_port > 0
  port_valid: a_port <= 65535
```

### Expectation Strings
```eiffel
require
  method_not_empty: not a_method.is_empty
  url_not_empty: not a_url.is_empty
```

### Lifecycle
- Must call start before handling requests
- Must be running to stop
- Reset can be called anytime

## Operational Constraints

### Test Isolation
- Call reset between tests
- Or create new instance
- State persists within instance

### Thread Safety
- Single-threaded design
- SCOOP would provide synchronization
- Not thread-safe without SCOOP

## Known Limitations

1. **No Actual HTTP**
   - Currently in-process only
   - Needs integration work

2. **No Pattern Matching**
   - Exact URL match only
   - Future: Regex patterns

3. **No Delays**
   - Responses immediate
   - Future: Delay simulation

4. **No Recording Mode**
   - Must configure expectations manually
   - Future: Record real traffic
