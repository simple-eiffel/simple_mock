# MML Integration - simple_mock

## Overview
Applied X03 Contract Assault with simple_mml on 2025-01-21.

## MML Classes Used
- `MML_MAP [STRING, MML_SEQUENCE [ANY]]` - Models mock call history per method
- `MML_SEQUENCE [TUPLE [STRING, ANY]]` - Models expectations queue

## Model Queries Added
- `model_calls: MML_MAP [STRING, MML_SEQUENCE [ANY]]` - Call history by method
- `model_expectations: MML_SEQUENCE [TUPLE [STRING, ANY]]` - Expected calls

## Model-Based Postconditions
| Feature | Postcondition | Purpose |
|---------|---------------|---------|
| `expect` | `expectation_added: model_expectations.count = old model_expectations.count + 1` | Expect adds to queue |
| `call` | `call_recorded: model_calls.item (a_method).count > old model_calls.item (a_method).count` | Call recorded |
| `verify` | `all_expectations_met: model_expectations.is_empty` | Verify checks all |
| `call_count` | `definition: Result = model_calls.item (a_method).count` | Count via model |
| `was_called` | `definition: Result = model_calls.domain [a_method]` | Called via model |
| `reset` | `model_clear: model_calls.is_empty and model_expectations.is_empty` | Reset clears model |

## Invariants Added
- `calls_non_negative: across model_calls as c all c.count >= 0 end` - Valid counts

## Bugs Found
1. **VAPE visibility**: `Min_http_status` and `Max_http_status` constants were `{NONE}` but used in preconditions. Changed to public visibility.

## Test Results
- Compilation: SUCCESS
- Tests: 55/55 PASS
