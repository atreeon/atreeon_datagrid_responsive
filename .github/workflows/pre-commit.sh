#!/bin/sh
# Pre-commit and CI test harness ensuring root and example packages pass Flutter tests.
# Ensures contributors catch regressions locally and the same logic runs on GitHub Actions.
set -e

# Guard the root package test suite before executing.
if [ -d "test" ]; then
  # Announce that the root package Flutter tests are starting.
  echo "🔍 Running Flutter tests in atreeon_datagrid_responsive/..."
  # Execute the root package Flutter test suite so library regressions fail fast.
  flutter test
else
  # Warn when the root package test directory cannot be located.
  echo "⚠️  Failure Flutter tests: atreeon_datagrid_responsive/test directory not found"
  # Exit with an error to stop the pipeline when tests cannot be executed.
  exit 1
fi

# Validate the example package tests mirror local coverage expectations.
if [ -d "example/test" ]; then
  # Announce that the example Flutter tests are running inside the subshell.
  echo "🔍 Running Flutter tests in example/..."
  # Execute the example project Flutter tests from within its directory.
  (cd example && flutter test)
else
  # Warn when the example project test directory is missing.
  echo "⚠️  Failure Flutter tests: example/test directory not found"
  # Exit with failure to surface missing example test coverage.
  exit 1
fi

# Confirm every configured check passed before allowing continuation.
echo "✅ Pre-commit checks passed."
# Exit successfully after all checks complete.
exit 0
