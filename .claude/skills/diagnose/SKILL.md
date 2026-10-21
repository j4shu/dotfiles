---
name: diagnose
description:
  Diagnose and fix a bug by building a failing feedback loop before forming any
  theory. Use when something is broken, throwing, failing, flaky, or regressed,
  or the user says "diagnose" or "debug this".
---

Find the root cause of a bug through a reproducible loop, then fix it and prove
the fix.

1. **Loop.** Build one command that goes red on the user's exact symptom, is
   deterministic, runs in seconds, and needs no human. Run it and show the
   invocation and output. For a flaky bug, raise the reproduction rate (repeat,
   parallelise, stress) until it fails reliably. This gate is hard: until the
   command exists, do not read code to build theories. If no loop is possible,
   stop, say what you tried, and ask for environment access, an artifact (log,
   trace, recording), or permission to add instrumentation.
2. **Minimise.** Cut inputs, callers, config, data, and steps one at a time,
   re-running the loop after each cut. Done when removing any remaining element
   turns the loop green.
3. **Hypothesise.** Write 3-5 ranked hypotheses, each a falsifiable prediction:
   "If X is the cause, changing Y makes the bug disappear." Show the list in
   chat and continue without waiting.
4. **Instrument.** Test hypotheses in rank order, one variable at a time, each
   probe tied to one prediction. Prefer a debugger or REPL to logs; place logs
   only at boundaries that tell hypotheses apart. Done when one hypothesis is
   confirmed and the rest are ruled out or irrelevant.
5. **Fix.** Before fixing, turn the minimised repro into a regression test and
   watch it fail, but only at a seam that exercises the real bug pattern as it
   occurs at the call site. If no such seam exists, skip the test and record the
   missing seam as a finding. Then fix, watch the test pass, and re-run the
   original, un-minimised loop until it is green.
6. **Clean.** Remove all temporary instrumentation and throwaway harnesses.
7. **Report.** In chat: the confirmed hypothesis and its evidence, the fix, the
   regression test or the missing-seam finding, and the loop command. Do not
   commit.

If the user passed arguments, treat them as the bug report.
