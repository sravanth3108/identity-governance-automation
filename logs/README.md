# logs/

This folder stores structured execution logs generated at runtime.

## Important

- All `.log` files are **gitignored in production** to prevent sensitive data leakage
- The `audit.log` file in this folder is a **sample output only** for demonstration purposes
- Real logs are generated each time `Find-InactiveADUsers.ps1` runs

## Log Format

```
[YYYY-MM-DD HH:MM:SS] [LEVEL] Message
```

| Level | Meaning |
|-------|---------|
| INFO  | Normal execution step |
| WARN  | Non-critical issue or flagged account |
| ERROR | Script failure or exception |

## Retention

Consider implementing log rotation for production deployments.
Recommended retention: 90 days minimum for audit compliance.
