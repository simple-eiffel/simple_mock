# 7S-05: SECURITY - simple_mock

**BACKWASH** | Generated: 2026-01-23 | Library: simple_mock

## Security Model

### Trust Boundary
- Test-only library
- No production network exposure
- Runs in test process

### Threat Assessment

| Threat | Risk | Mitigation |
|--------|------|------------|
| Port conflicts | Low | Configurable port |
| Accidental production use | Medium | Documentation warnings |
| Sensitive data in logs | Low | Request history in memory only |
| Resource exhaustion | Low | Manual reset available |

## Test Isolation

### Request History
- Stored in memory only
- Cleared on reset
- No persistent storage

### Port Management
- Default port 8080
- Configurable per instance
- Pool manages reuse

### Process Boundary
- Mock server in same process
- No external network exposure (currently)
- When HTTP enabled: localhost only

## Data Handling

### Request Data
- Method, URL, headers, body stored
- Available for verification
- Cleared on reset or stop

### Response Data
- Configured by test
- No dynamic data loading
- Static or programmatic responses

## Recommendations

1. **Test Only** - Never use in production
2. **Localhost Only** - Bind to 127.0.0.1 when HTTP enabled
3. **Reset Between Tests** - Avoid state leakage
4. **No Sensitive Data** - Use fake data in expectations

## Known Considerations

1. **No Authentication Mocking**
   - Implement in response configuration
   - Test code handles auth headers

2. **No HTTPS**
   - Tests should use HTTP
   - Or mock at different layer
